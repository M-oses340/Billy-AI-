# Billy Backend

## Setup

```bash
npm install
cp .env.example .env
# Edit .env with your configuration
npm run dev
```

## API Endpoints

- `GET /health` - Health check
- `GET /api/bills` - Get all bills
- `POST /api/bills` - Create new bill
- `POST /api/bills/parse` - Parse bill from image/PDF
- `POST /api/payments/initiate` - Initiate crypto payment
- `GET /api/payments/history` - Get payment history
