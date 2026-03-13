import { Router } from 'express';

const router = Router();

router.get('/', async (req, res) => {
  res.json({ bills: [] });
});

router.post('/', async (req, res) => {
  const { payee, amount, dueDate, currency } = req.body;
  res.json({ message: 'Bill created', bill: { payee, amount, dueDate, currency } });
});

router.post('/parse', async (req, res) => {
  // AI bill parsing endpoint
  res.json({ message: 'Bill parsing not yet implemented' });
});

export default router;
