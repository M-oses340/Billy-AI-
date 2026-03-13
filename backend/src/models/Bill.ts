import mongoose from 'mongoose';

const billSchema = new mongoose.Schema({
  userId: { type: String, required: true, index: true },
  userAddress: { type: String, required: true },
  
  // Bill details
  biller: { type: String, required: true },
  amount: { type: Number, required: true },
  currency: { type: String, default: 'USD' },
  dueDate: { type: Date, required: true },
  reference: { type: String },
  billType: { type: String, enum: ['electricity', 'water', 'internet', 'phone', 'gas', 'rent', 'other'] },
  
  // SMS details
  smsContent: { type: String },
  fromNumber: { type: String },
  aiConfidence: { type: Number },
  
  // Payment status
  status: { 
    type: String, 
    enum: ['pending', 'queued', 'paid', 'failed', 'cancelled'],
    default: 'pending'
  },
  
  // Blockchain
  blockchainBillId: { type: Number },
  transactionHash: { type: String },
  paidAt: { type: Date },
  
  // Auto-pay
  autoPayAttempted: { type: Boolean, default: false },
  autoPayEnabled: { type: Boolean, default: true },
  
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});

billSchema.index({ userId: 1, status: 1 });
billSchema.index({ dueDate: 1, status: 1 });

export const Bill = mongoose.model('Bill', billSchema);
