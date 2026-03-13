import { Router } from 'express';

const router = Router();

router.post('/initiate', async (req, res) => {
  const { billId, walletAddress, amount, token } = req.body;
  res.json({ message: 'Payment initiated', transactionHash: '0x...' });
});

router.get('/history', async (req, res) => {
  res.json({ payments: [] });
});

export default router;
