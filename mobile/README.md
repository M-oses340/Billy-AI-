# Billy Mobile App

Flutter application for AI-powered crypto bill payment with SMS auto-pay.

## Prerequisites

- Flutter SDK 3.0.0 or higher
- Android Studio / Xcode
- Android device/emulator or iOS device/simulator
- Backend API running (see `../backend/README.md`)

## Setup

### 1. Install Dependencies

```bash
cd mobile
flutter pub get
```

### 2. Configuration

The app is pre-configured to connect to:
- **Backend API**: `http://localhost:3000/api` (for local testing)
- **Smart Contract**: `0xaf15ff299F4795224E23D1b6Fd36805Fc32f114e`
- **Network**: Polygon Amoy Testnet
- **RPC**: `https://rpc-amoy.polygon.technology`

To change these settings, edit `lib/config/app_config.dart`.

### 3. Android Permissions

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_SMS" />
<uses-permission android:name="android.permission.RECEIVE_SMS" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

### 4. Run the App

```bash
# Check connected devices
flutter devices

# Run on connected device
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

## Features

- ✅ SMS bill monitoring and auto-parsing
- ✅ AI-powered bill extraction (Google Gemini)
- ✅ Crypto wallet integration (Web3)
- ✅ Auto-payment for trusted billers
- ✅ Multi-token support (USDC, USDT, MATIC)
- ✅ Auto-convert to stablecoin (USDC)
- ✅ Payment history tracking
- ✅ Bill management dashboard

## Architecture

### State Management
- **BLoC pattern** for predictable state management
- Separate blocs for bills, payments, and wallet

### Data Layer
- **Repository pattern** for data abstraction
- API service for backend communication
- Web3 service for blockchain interaction

### Services
- **API Service**: REST API communication with backend
- **Web3 Service**: Smart contract interaction
- **SMS Service**: SMS monitoring and parsing

## Project Structure

```
mobile/
├── lib/
│   ├── blocs/           # BLoC state management
│   │   ├── bill/
│   │   ├── payment/
│   │   └── wallet/
│   ├── models/          # Data models
│   ├── repositories/    # Data repositories
│   ├── screens/         # UI screens
│   ├── services/        # External services
│   ├── config/          # App configuration
│   └── main.dart        # App entry point
└── pubspec.yaml         # Dependencies
```

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test
```

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Troubleshooting

### Backend Connection Issues
- Ensure backend is running on `http://localhost:3000`
- For Android emulator, use `http://10.0.2.2:3000` instead
- For physical device, use your computer's IP address

### SMS Permissions
- Grant SMS permissions when prompted
- Check app settings if permissions were denied

### Web3 Connection Issues
- Verify RPC URL is accessible
- Check network connectivity
- Ensure contract address is correct

## Next Steps

1. Test SMS monitoring functionality
2. Connect wallet (MetaMask, WalletConnect)
3. Fund wallet with test USDC
4. Test auto-payment flow
5. Add trusted biller numbers

## Documentation

- [Backend API](../backend/README.md)
- [Smart Contract](../contracts/README.md)
- [Project Status](../STATUS.md)

