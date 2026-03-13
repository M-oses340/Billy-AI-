import { Router } from 'express';
import { Bill } from '../models/Bill';

const router = Router();

router.get('/', async (req, res) => {
  try {
    const bills = await Bill.find().sort({ createdAt: -1 });
    res.json({ bills });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/', async (req, res) => {
  try {
    const bill = new Bill(req.body);
    await bill.save();
    res.json({ message: 'Bill created', bill });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// Create standing order (recurring bill template)
router.post('/standing-order', async (req, res) => {
  try {
    const { userId, userAddress, biller, amount, currency, billType, recurringFrequency, recurringDayOfMonth } = req.body;
    
    // Calculate first due date
    const now = new Date();
    const firstDueDate = new Date(now);
    
    if (recurringFrequency === 'monthly' && recurringDayOfMonth) {
      firstDueDate.setDate(recurringDayOfMonth);
      if (firstDueDate <= now) {
        firstDueDate.setMonth(firstDueDate.getMonth() + 1);
      }
    } else if (recurringFrequency === 'weekly') {
      firstDueDate.setDate(firstDueDate.getDate() + 7);
    }
    
    const standingOrder = new Bill({
      userId,
      userAddress,
      biller,
      amount,
      currency: currency || 'KES',
      dueDate: firstDueDate,
      billType,
      isRecurring: true,
      recurringFrequency,
      recurringDayOfMonth,
      nextDueDate: firstDueDate,
      status: 'pending',
      autoPayEnabled: true,
    });
    
    await standingOrder.save();
    
    res.json({ 
      message: 'Standing order created', 
      standingOrder,
      nextDueDate: firstDueDate 
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/parse', async (req, res) => {
  // AI bill parsing endpoint
  res.json({ message: 'Bill parsing not yet implemented' });
});

export default router;
