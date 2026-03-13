# Testing SMS Auto-Pay

## Backend is Running ✅

The backend is successfully running with:
- ✅ Google Gemini AI for SMS parsing
- ✅ MongoDB for bill storage
- ✅ Polygon Amoy testnet connection
- ✅ Smart contract integration

## Test SMS Processing

```bash
curl -X POST http://localhost:3000/api/sms/process \
  -H "Content-Type: application/json" \
  -d '{
    "from": "+254712345678",
    "message": "Your electricity bill of KES 2,500 is due on 20th March. Account: 123456789.",
    "userId": "test-user-123",
    "userAddress": "0x738CAE8a861e9419a8e9f1f27691A8Da06eaD803"
  }'
```

## Expected Response

```json
{
  "status": "insufficient_balance",
  "message": "Need $2500 more to pay this bill",
  "parsedBill": {
    "biller": "Electricity Provider",
    "amount": 2500,
    "currency": "KES",
    "dueDate": "2024-03-20",
    "reference": "123456789",
    "billType": "electricity",
    "confidence": 0.95
  },
  "billId": "...",
  "balance": 0,
  "shortfall": 2500
}
```

## Test Different Bill Types

### Water Bill
```bash
curl -X POST http://localhost:3000/api/sms/process \
  -H "Content-Type: application/json" \
  -d '{
    "from": "+254700000000",
    "message": "Water bill KES 850 due 25th March. Ref: WTR-9876",
    "userId": "test-user-123",
    "userAddress": "0x738CAE8a861e9419a8e9f1f27691A8Da06eaD803"
  }'
```

### Internet Bill
```bash
curl -X POST http://localhost:3000/api/sms/process \
  -H "Content-Type: application/json" \
  -d '{
    "from": "+254711111111",
    "message": "Your Safaricom internet bill of KES 3,999 is due on 30th March. Account: 0712345678",
    "userId": "test-user-123",
    "userAddress": "0x738CAE8a861e9419a8e9f1f27691A8Da06eaD803"
  }'
```

## Next Steps

1. Fund the wallet with USDC on Polygon Amoy testnet
2. Test auto-payment when balance is sufficient
3. Integrate with Flutter mobile app
4. Set up trusted biller numbers
