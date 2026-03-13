# Billy Mobile App Testing Guide

## ✅ App Successfully Installed!

The Billy app is now running on your Android device.

## Current Features

### Home Screen
- Shows list of bills (currently empty)
- Floating action button (+) to add bills manually
- Pull to refresh

### What Works
- ✅ App launches successfully
- ✅ UI renders correctly
- ✅ Navigation structure in place
- ✅ BLoC state management configured

## Testing the Full Flow

### 1. Test Backend SMS Processing

From your computer terminal:

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

This will:
- Parse the SMS with Gemini AI
- Save bill to MongoDB
- Return parsed bill data

### 2. View Bills in App

The app needs to connect to your backend API. Since you're testing on a physical device:

**Update API URL for physical device:**
1. Find your computer's IP address: `ip addr show` or `ifconfig`
2. Update `mobile/lib/config/app_config.dart`:
   ```dart
   static const String apiBaseUrl = 'http://YOUR_COMPUTER_IP:3000/api';
   ```
3. Rebuild the app: `flutter run -d fbb5754e`

### 3. Test Wallet Features

- Tap the wallet icon/menu
- View wallet balance
- See supported tokens (USDC)

## Next Steps

### To Enable Real SMS Monitoring

SMS monitoring requires native Android code (platform channels). For now, you can:

1. **Manual Testing**: Use the backend API directly
2. **Future Enhancement**: Implement native Android BroadcastReceiver for SMS

### To Test Auto-Payment

1. Fund your test wallet with USDC on Polygon Amoy:
   - Get test MATIC from faucet: https://faucet.polygon.technology/
   - Swap to USDC on testnet DEX

2. Send SMS bill via API with sufficient balance

3. Backend will automatically pay the bill

## Troubleshooting

### App Can't Connect to Backend

**For Android Emulator:**
- Use `http://10.0.2.2:3000/api`

**For Physical Device:**
- Use your computer's local IP: `http://192.168.x.x:3000/api`
- Ensure both devices are on same WiFi network
- Check firewall allows port 3000

### No Bills Showing

- Check backend is running: `curl http://localhost:3000/health`
- Verify MongoDB has bills: Use MongoDB Compass or CLI
- Check app logs in Flutter console

## Features to Implement

- [ ] Real-time SMS monitoring (native Android)
- [ ] Wallet connection (MetaMask/WalletConnect)
- [ ] Push notifications
- [ ] Bill payment execution
- [ ] Transaction history
- [ ] Settings screen

## Success! 🎉

Your Billy app is running and ready for testing. The core infrastructure is complete:
- Smart contract deployed ✅
- Backend API with AI parsing ✅
- Mobile app installed ✅
- Database configured ✅
