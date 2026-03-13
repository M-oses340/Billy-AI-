import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import billRoutes from './routes/billRoutes';
import paymentRoutes from './routes/paymentRoutes';
import walletRoutes from './routes/walletRoutes';
import smsRoutes from './routes/smsRoutes';
import billerRoutes from './routes/billerRoutes';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.use('/api/bills', billRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/wallet', walletRoutes);
app.use('/api/sms', smsRoutes);
app.use('/api/billers', billerRoutes);

app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'Billy backend with SMS auto-pay is running' });
});

app.listen(PORT, () => {
  console.log(`Billy backend running on port ${PORT}`);
  console.log('SMS auto-pay enabled with Claude AI');
});
