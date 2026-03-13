# SMS Auto-Pay Setup Guide

## What Was Implemented

Billy now has **automatic SMS bill detection and payment**! Here's what happens:

### 1. SMS Detection (Android Native)
- `SmsReceiver.kt` - Listens for incoming SMS messages
- Runs in background, even when app is closed
- Filters messages from trusted billers only

### 2. Flutter Integration
- Platform channel connects Android to Flutter
- `SmsService` processes incoming SMS automatically
- Sends bill data to backend API

### 3. Backend AI Processing
- Gemini AI parses SMS content
- Extracts: biller, amount, due date, reference
- Returns confidence score (0-1)

### 4. Auto-Payment Logic
```
IF confidence > 90% AND balance sufficient:
  → Pay immediately via smart contract
  → Update bill status to "paid"
  → Send confirmation notification

ELSE IF confidence > 90% BUT insufficient balance:
  → Queue bill for later
  → Notify user to top up wallet
  
ELSE IF confidence < 90%:
  → Ask user to review manually
```

## How to Enable SMS Auto-Pay

### Step 1: Add Trusted Billers

Edit `mobile/lib/main.dart` and add trusted phone numbers:

```dart
final smsService = SmsService(
  apiService,
  [
    '+254712345678',  // Kenya Power
    '+254718716796',  // WiFi Provider
    'MPESA',          // M-PESA
    // Add more trusted numbers
  ],
);
```

### Step 2: Initialize SMS Listener

In your app initialization (after user logs in):

```dart
await smsService.startListening(
  userAddress: '0x738CAE8a861e9419a8e9f1f27691A8Da06eaD803',
  userId: 'test-user-123',
);
```

### Step 3: Grant Permissions

When the app starts, it will request:
- READ_SMS
- RECEIVE_SMS
- READ_PHONE_STATE

User must grant these for auto-pay to work.

## Testing SMS Auto-Pay

### Method 1: Send Test SMS (Recommended)
Use another phone to send a test bill SMS:

```
Your electricity bill of KES 2,500 is due on 20th March. 
Account: 123456789. Pay via M-PESA Paybill 888000.
```

### Method 2: Use ADB (Android Debug Bridge)
```bash
# Send SMS to emulator/device
adb emu sms send +254712345678 "Your WiFi bill of KES 3000 is due on 12/03/26"
```

### Method 3: Manual Testing
```dart
await smsService.processSmsManually(
  from: '+254712345678',
  message: 'Your bill of KES 2500 is due...',
  userAddress: '0x...',
  userId: 'user-123',
);
```

## Monitoring SMS Processing

Check the Flutter console for logs:

```
📨 SMS received from: +254712345678
✅ Trusted sender detected, processing bill...
🤖 Sending to AI for parsing...
✅ Bill paid automatically!
💰 Amount: 2500 KES
```

## Security Features

1. **Trusted Numbers Only** - Only processes SMS from pre-approved billers
2. **AI Confidence Check** - Requires 90%+ confidence before auto-pay
3. **Balance Verification** - Checks wallet balance before payment
4. **User Notifications** - Alerts user of all auto-payments

## Troubleshooting

### SMS Not Being Detected
1. Check permissions are granted
2. Verify trusted numbers list includes sender
3. Check Android logs: `adb logcat | grep SmsReceiver`

### Bills Not Auto-Paying
1. Check wallet balance is sufficient
2. Verify AI confidence score (must be > 0.9)
3. Check backend logs for errors

### Permission Denied
1. Go to Settings → Apps → Billy → Permissions
2. Enable SMS permissions
3. Restart the app

## Architecture Flow

```
📱 SMS Arrives
    ↓
🔔 Android BroadcastReceiver catches it
    ↓
✅ Check if sender is trusted
    ↓
📤 Send to Flutter via MethodChannel
    ↓
🌐 Flutter sends to Backend API
    ↓
🤖 Gemini AI parses SMS
    ↓
💰 Check wallet balance
    ↓
⛓️  Execute smart contract payment
    ↓
✅ Update bill status & notify user
```

## Next Steps

1. **Add More Trusted Billers** - Expand the trusted numbers list
2. **Standing Orders** - Set up recurring bills (already implemented!)
3. **Payment History** - View all auto-payments
4. **Notification System** - Push notifications for payments
5. **Multi-Currency** - Support USD, EUR, etc.

## Files Modified

- `mobile/android/app/src/main/kotlin/com/example/billy/SmsReceiver.kt` (NEW)
- `mobile/android/app/src/main/kotlin/com/example/billy/MainActivity.kt`
- `mobile/android/app/src/main/AndroidManifest.xml`
- `mobile/lib/services/sms_service.dart`
- `backend/src/routes/smsRoutes.ts`
- `backend/src/services/geminiService.ts`

## Important Notes

- SMS monitoring only works on Android (iOS has restrictions)
- Requires active internet connection for backend API
- Backend must be running and accessible
- Gemini API key must be valid
- Smart contract must be deployed on Polygon Amoy testnet
