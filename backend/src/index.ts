import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import mongoose from 'mongoose';
import billRoutes from './routes/billRoutes';
import paymentRoutes from './routes/paymentRoutes';
import walletRoutes from './routes/walletRoutes';
import smsRoutes from './routes/smsRoutes';
import billerRoutes from './routes/billerRoutes';
import { listenForPayments } from './services/web3Service';
import { startRecurringBillScheduler } from './services/recurringBillService';

dotenv.config();

const app = express();
const PORT = Number(process.env.PORT) || 3000;

app.use(cors());
app.use(express.json());

// Connect to MongoDB (optional - can work without it)
if (process.env.MONGODB_URI) {
  mongoose.connect(process.env.MONGODB_URI)
    .then(() => console.log('✅ MongoDB connected'))
    .catch((err) => console.log('⚠️  MongoDB not connected:', err.message));
}

// Routes
app.use('/api/bills', billRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/wallet', walletRoutes);
app.use('/api/sms', smsRoutes);
app.use('/api/billers', billerRoutes);

app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'Billy backend with SMS auto-pay is running',
    features: {
      smsAutoPay: true,
      aiParsing: 'Google Gemini',
      blockchain: 'Polygon Amoy',
      contract: process.env.CONTRACT_ADDRESS,
    }
  });
});

// Listen for blockchain payment events
listenForPayments((billId, payer, amount) => {
  console.log(`💰 Payment detected: Bill ${billId}, Payer: ${payer}, Amount: ${amount}`);
  // TODO: Update bill status in database
});

// Start recurring bill scheduler
startRecurringBillScheduler();

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Billy backend running on port ${PORT}`);
  console.log(`📱 SMS auto-pay enabled with Google Gemini AI`);
  console.log(`⛓️  Connected to: ${process.env.RPC_URL}`);
  console.log(`📝 Contract: ${process.env.CONTRACT_ADDRESS}`);
  console.log(`🌐 Accessible at: http://192.168.0.108:${PORT}`);
});

export default app;
