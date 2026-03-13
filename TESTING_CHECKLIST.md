# Billy Testing Checklist

## ✅ Backend Tests

### 1. Health Check
```bash
curl http://localhost:3000/health
```
**Expected**: `{"status":"ok",...}`

### 2. SMS Bill Parsing
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
**Expected**: Bill parsed with confidence > 0.9

### 3. List Bills
```bash
curl http://localhost:3000/api/bills
```
**Expected**: Array of bills

### 4. Add Trusted Biller
```bash
curl -X POST http://localhost:3000/api/billers/trust \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "+254712345678",
    "billerName": "Kenya Power",
    "billType": "electricity"
  }'
```
**Expected**: Biller added successfully

## ✅ Smart Contract Tests

### 1. Check Contract on Explorer
Visit: https://amoy.polygonscan.com/address/0xaf15ff299F4795224E23D1b6Fd36805Fc32f114e

**Expected**: Contract verified and visible

### 2. Check Wallet Balance
```bash
cd contracts
node check-balance.js
```
**Expected**: Shows MATIC balance

## ✅ Mobile App Tests

### 1. Install Dependencies
```bash
cd mobile
flutter pub get
```
**Expected**: All packages installed

### 2. Run App
```bash
flutter run
```
**Expected**: App launches successfully

### 3. Test Features
- [ ] App connects to backend
- [ ] SMS permissions requested
- [ ] Wallet screen loads
- [ ] Bills screen loads
- [ ] Can view bill history

## 🎯 Integration Tests

### 1. End-to-End SMS Flow
1. Send test SMS to backend
2. Verify bill saved in MongoDB
3. Check bill appears in mobile app
4. Verify notification sent

### 2. Payment Flow (with funded wallet)
1. Fund wallet with test USDC
2. Send SMS bill
3. Verify auto-payment triggered
4. Check transaction on blockchain
5. Verify bill status updated

## 📊 Test Results

| Test | Status | Notes |
|------|--------|-------|
| Backend Health | ✅ | Running on port 3000 |
| SMS Parsing | ✅ | Gemini AI working |
| MongoDB | ✅ | Connected and storing data |
| Smart Contract | ✅ | Deployed on Amoy |
| Mobile Config | ✅ | Contract address set |
| Mobile Build | ⏳ | Ready for testing |

## 🐛 Known Issues

1. **Ethers.js Warnings**: Filter not found errors (non-critical)
2. **Payment Execution**: TODO in smsRoutes.ts
3. **Mobile Testing**: Not yet tested on device

## 📝 Notes

- Backend must be running for mobile app to work
- Use `http://10.0.2.2:3000` for Android emulator
- Use your computer's IP for physical devices
- Ensure SMS permissions granted on mobile
