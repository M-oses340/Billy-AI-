import { Router } from 'express';
import { parseBillSMSGemini as parseBillSMS } from '../services/geminiService'; // Using Gemini

const router = Router();

router.post('/process', async (req, res) => {
  try {
    const { from, message, userAddress } = req.body;

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

    // Check wallet balance (placeholder)
    const balance = 1000; // TODO: Get from blockchain
    const amountNeeded = parsedBill.amount;

    if (balance >= amountNeeded) {
      // Sufficient balance - auto-pay
      // TODO: Create bill and initiate payment
      return res.json({
        status: 'paid',
        message: 'Bill paid automatically',
        parsedBill,
        transactionHash: '0x...',
      });
    } else {
      // Insufficient balance - queue and notify
      const shortfall = amountNeeded - balance;
      return res.json({
        status: 'insufficient_balance',
        message: `Need $${shortfall} more to pay this bill`,
        parsedBill,
        balance,
        shortfall,
      });
    }
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

export default router;
