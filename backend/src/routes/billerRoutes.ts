import { Router } from 'express';

const router = Router();

// Get trusted billers for a user
router.get('/trusted', async (req, res) => {
  // TODO: Get from database
  res.json({
    billers: [
      {
        id: '1',
        name: 'Electric Company',
        phoneNumber: '+1234567890',
        autoPayEnabled: true,
        maxAutoPayAmount: 200,
      },
    ],
  });
});

// Add trusted biller
router.post('/trusted', async (req, res) => {
  const { name, phoneNumber, maxAutoPayAmount } = req.body;
  // TODO: Save to database
  res.json({ message: 'Biller added', biller: { name, phoneNumber } });
});

// Update trusted biller
router.put('/trusted/:id', async (req, res) => {
  const { id } = req.params;
  // TODO: Update in database
  res.json({ message: 'Biller updated' });
});

// Delete trusted biller
router.delete('/trusted/:id', async (req, res) => {
  const { id } = req.params;
  // TODO: Delete from database
  res.json({ message: 'Biller removed' });
});

export default router;
