import { Router } from 'express';
import { parseBillSMSGemini as parseBillSMS } from '../services/geminiService';
import { getWalletBalance } from '../services/web3Service';
import { sendBillPaidNotification, sendLowBalanceNotification } from '../services/notificationService';
import { Bill } from '../models/Bill';

const router = Router();

// USDC token address on Amoy testnet
const USDC_ADDRESS = '0x41E94Eb019C0762f9Bfcf9Fb1E58725BfB0e7582';

router.post('/process', async (req, res) => {
  try {
    const { from, message, userAddress, userId } = req.body;

    // Parse SMS with Gemini AI
    const parsedBill = await parseBillSMS(message, from);

    // Check if confidence is high enough
    if (parsedBill.confidence < 0.9) {
      return res.json({
        status: 'review_required',
        message: 'Low confidence. Please review manually.',
        parsedBill,
      });
    }

    // Save bill to database
    const bill = new Bill({
      userId,
      userAddress,
      biller: parsedBill.biller,
      amount: parsedBill.amount,
      currency: parsedBill.currency,
      dueDate: new Date(parsedBill.dueDate),
      reference: parsedBill.reference,
      billType: parsedBill.billType,
      smsContent: message,
      fromNumber: from,
      aiConfidence: parsedBill.confidence,
      status: 'pending',
    });

    await bill.save();

    // Check wallet balance
    const balance = await getWalletBalance(userAddress, USDC_ADDRESS);
    const amountNeeded = parsedBill.amount;

    if (balance >= amountNeeded) {
      // Sufficient balance - auto-pay
      // TODO: Implement actual payment
      bill.status = 'paid';
      bill.autoPayAttempted = true;
      await bill.save();

      await sendBillPaidNotification(userId, parsedBill.biller, parsedBill.amount, '0x...');

      return res.json({
        status: 'paid',
        message: 'Bill paid automatically',
        parsedBill,
        billId: bill._id,
        transactionHash: '0x...',
      });
    } else {
      // Insufficient balance - queue and notify
      const shortfall = amountNeeded - balance;
      bill.status = 'queued';
      await bill.save();

      await sendLowBalanceNotification(userId, parsedBill.biller, shortfall, balance);

      return res.json({
        status: 'insufficient_balance',
        message: `Need $${shortfall} more to pay this bill`,
        parsedBill,
        billId: bill._id,
        balance,
        shortfall,
      });
    }
  } catch (error: any) {
    console.error('SMS processing error:', error);
    res.status(500).json({ error: error.message });
  }
});

export default router;
