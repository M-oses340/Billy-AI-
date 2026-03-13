# Billy SMS Auto-Pay Architecture

## Overview

Billy monitors incoming SMS messages from trusted billers, uses Claude AI to parse bill details, and automatically pays bills if balance is sufficient.

## Flow Diagram

```
┌─────────────┐
│   SMS from  │
│   Biller    │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────┐
│  Mobile App (Background Service)   │
│  - Listens for SMS                  │
│  - Filters by trusted numbers       │
│  - Forwards to Backend              │
└──────┬──────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────┐
│  Backend API                        │
│  POST /api/sms/process              │
└──────┬──────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────┐
│  Claude AI (Anthropic)              │
│  - Parse SMS content                │
│  - Extract: amount, due date, ref   │
│  - Identify biller                  │
└──────┬──────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────┐
│  Validation & Balance Check         │
│  - Verify parsed data               │
│  - Check wallet balance             │
│  - Apply payment rules              │
└──────┬──────────────────────────────┘
       │
       ├─── Sufficient Balance ────────┐
       │                               │
       │                               ▼
       │                    ┌──────────────────┐
       │                    │  Auto-Pay        │
       │                    │  - Create bill   │
       │                    │  - Execute txn   │
       │                    │  - Send success  │
       │                    └──────────────────┘
       │
       └─── Insufficient Balance ──────┐
                                       │
                                       ▼
                            ┌──────────────────┐
                            │  Notification    │
                            │  "Fund account"  │
                            │  - Show amount   │
                            │  - Add to queue  │
                            └──────────────────┘
```

## Components

### 1. Mobile App - SMS Listener (Flutter)

```dart
// Background service that monitors SMS
class SmsListener {
  - Listen for incoming SMS
  - Filter by trusted biller numbers
  - Forward to backend API
  - Handle responses
}
```

**Trusted Biller Numbers:**
- Electricity company
- Water utility
- Internet provider
- Phone company
- Custom numbers added by user

### 2. Backend - SMS Processing Endpoint

```typescript
POST /api/sms/process
{
  "from": "+1234567890",
  "message": "Your electricity bill is $150. Due: March 30. Ref: ELC-2024-001",
  "timestamp": "2024-03-20T10:30:00Z",
  "userAddress": "0x..."
}
```

### 3. Claude AI Integration

**Prompt Template:**
```
Parse this bill SMS and extract structured data:

SMS: "{message}"
From: {phoneNumber}

Extract:
1. Biller name
2. Amount (in USD)
3. Due date
4. Reference number
5. Bill type (electricity, water, internet, etc.)

Return JSON format only.
```

**Claude Response:**
```json
{
  "biller": "Electric Company",
  "amount": 150.00,
  "currency": "USD",
  "dueDate": "2024-03-30",
  "reference": "ELC-2024-001",
  "billType": "electricity",
  "confidence": 0.95
}
```

### 4. Auto-Pay Logic

```typescript
if (confidence > 0.9) {
  // Check wallet balance
  const balance = await getWalletBalance(userAddress, USDC);
  
  if (balance >= amount) {
    // AUTO-PAY
    await createBill(billData);
    await initiatePayment(billId);
    await sendNotification("Bill paid: $150 to Electric Company");
  } else {
    // INSUFFICIENT FUNDS
    const needed = amount - balance;
    await queueBill(billData);
    await sendNotification(
      `⚠️ Low Balance: Need $${needed} more to pay Electric Company bill`
    );
  }
} else {
  // LOW CONFIDENCE - Ask user to confirm
  await sendNotification("New bill detected. Please review and confirm.");
}
```

## Security Features

### Trusted Numbers Whitelist
```typescript
// User configures trusted biller numbers
const trustedBillers = [
  { name: "Electric Co", number: "+1234567890", autoPayLimit: 200 },
  { name: "Water Utility", number: "+0987654321", autoPayLimit: 100 },
];
```

### Auto-Pay Rules
```typescript
{
  "maxAmount": 500,           // Don't auto-pay bills over $500
  "requireConfirmation": true, // Ask for amounts > $200
  "minConfidence": 0.9,       // Claude confidence threshold
  "dailyLimit": 1000,         // Max auto-pay per day
  "enabledBillTypes": ["electricity", "water", "internet"]
}
```

### Fraud Prevention
- Verify sender number matches known biller
- Check amount is within expected range
- Detect duplicate bills (same ref number)
- Rate limiting (max 5 bills per day)
- Anomaly detection (unusual amounts)

## Database Schema

```typescript
// Trusted Billers
{
  userId: string,
  billerName: string,
  phoneNumber: string,
  autoPayEnabled: boolean,
  maxAutoPayAmount: number,
  lastBillDate: Date,
  averageAmount: number
}

// SMS Bills
{
  userId: string,
  smsContent: string,
  fromNumber: string,
  parsedData: {
    biller: string,
    amount: number,
    dueDate: Date,
    reference: string
  },
  confidence: number,
  status: "pending" | "paid" | "queued" | "failed",
  autoPayAttempted: boolean,
  paidAt: Date
}

// Payment Queue (insufficient balance)
{
  userId: string,
  billId: string,
  amountNeeded: number,
  queuedAt: Date,
  notificationsSent: number
}
```

## Example SMS Patterns

### Electricity Bill
```
"Your KPLC bill for March is KES 3,500. Pay by 30/03/2024. Ref: 1234567890"
```

### Water Bill
```
"Nairobi Water: Your bill is KES 1,200. Due: 25th March. Account: 9876543"
```

### Internet Bill
```
"Safaricom Home Fiber: KES 2,999 due on 28/03/2024. Ref: SF-2024-001"
```

### Phone Bill
```
"Your Airtel postpaid bill: KES 1,500. Pay before 31/03 to avoid disconnection."
```

## Notifications

### Success
```
✅ Bill Paid Automatically
Electric Company: $150
Balance: $850 → $700
Ref: ELC-2024-001
```

### Insufficient Balance
```
⚠️ Unable to Pay Bill
Electric Company: $150
Your balance: $50
Need: $100 more
Tap to fund account
```

### Confirmation Required
```
📋 New Bill Detected
Electric Company: $250
Due: March 30
Amount exceeds auto-pay limit ($200)
Tap to review and pay
```

## API Endpoints

```typescript
// SMS Processing
POST /api/sms/process
POST /api/sms/retry/:billId

// Trusted Billers
GET /api/billers/trusted
POST /api/billers/trusted
PUT /api/billers/trusted/:id
DELETE /api/billers/trusted/:id

// Auto-Pay Settings
GET /api/settings/autopay
PUT /api/settings/autopay

// Payment Queue
GET /api/queue/pending
POST /api/queue/process/:billId
DELETE /api/queue/:billId
```

## Cost Estimation

| Service | Cost per SMS |
|---------|--------------|
| Claude API (Haiku) | $0.00025 |
| SMS forwarding | $0.001 |
| Blockchain txn | $0.01 |
| **Total** | **~$0.01** |

For 100 bills/month: **$1.00**

## Privacy & Permissions

**Mobile App Permissions:**
- READ_SMS (to monitor incoming messages)
- RECEIVE_SMS (to intercept in real-time)
- INTERNET (to send to backend)

**User Control:**
- Enable/disable SMS monitoring
- Choose which numbers to trust
- Set auto-pay limits
- Review all auto-payments
- Revoke permissions anytime

## Future Enhancements

1. **Email Bill Monitoring** - Parse bills from email
2. **Bill Prediction** - Predict upcoming bills based on history
3. **Smart Scheduling** - Pay bills on optimal days for cashback
4. **Multi-Currency** - Handle bills in different currencies
5. **Bill Splitting** - Split bills with roommates
