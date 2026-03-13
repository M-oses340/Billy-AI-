import mongoose from 'mongoose';

const trustedBillerSchema = new mongoose.Schema({
  userId: { type: String, required: true, index: true },
  
  name: { type: String, required: true },
  phoneNumber: { type: String, required: true },
  
  autoPayEnabled: { type: Boolean, default: true },
  maxAutoPayAmount: { type: Number, default: 500 },
  
  // Statistics
  totalBills: { type: Number, default: 0 },
  totalPaid: { type: Number, default: 0 },
  averageAmount: { type: Number, default: 0 },
  lastBillDate: { type: Date },
  
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});

trustedBillerSchema.index({ userId: 1, phoneNumber: 1 }, { unique: true });

export const TrustedBiller = mongoose.model('TrustedBiller', trustedBillerSchema);
