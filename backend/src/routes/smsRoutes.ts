import { Router } from 'express';
import { parseBillSMSGemini as parseBillSMS } from '../services/geminiService';
import { getWalletBalance, createBillOnChain, payBillOnChain } from '../services/web3Service';
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
      try {
        // Create bill on blockchain
        console.log('⛓️  Creating bill on blockchain...');
        const txHash = await createBillOnChain(
          userAddress, // payee (for now, same as payer)
          amountNeeded,
          USDC_ADDRESS,
          new Date(parsedBill.dueDate)
        );

        console.log('✅ Bill created on chain:', txHash);
        const blockchainBillId = Date.now(); // Temporary

        // Pay the bill immediately
        console.log('💸 Executing payment...');
        const paymentTxHash = await payBillOnChain(blockchainBillId);

        // Update bill status
        bill.status = 'paid';
        bill.autoPayAttempted = true;
        bill.blockchainBillId = blockchainBillId;
        bill.transactionHash = paymentTxHash;
        bill.paidAt = new Date();
        await bill.save();

        await sendBillPaidNotification(userId, parsedBill.biller, parsedBill.amount, paymentTxHash);

        return res.json({
          status: 'paid',
          message: 'Bill paid automatically via blockchain',
          parsedBill,
          billId: bill._id,
          transactionHash: paymentTxHash,
          blockchainBillId,
        });
      } catch (blockchainError: any) {
        console.error('❌ Blockchain payment failed:', blockchainError.message);
        bill.status = 'failed';
        bill.autoPayAttempted = true;
        await bill.save();

        return res.status(500).json({
          status: 'payment_failed',
          message: 'Blockchain payment failed',
          error: blockchainError.message,
          billId: bill._id,
        });
      }
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
