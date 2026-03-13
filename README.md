# Billy - AI-Powered Crypto Bill Payment Assistant 🤖💰

An intelligent assistant that automatically detects bills from SMS, converts crypto to stablecoins, and pays bills before they're overdue.

![Billy Banner](https://img.shields.io/badge/Billy-AI%20Bill%20Pay-blue)
![Blockchain](https://img.shields.io/badge/Blockchain-Polygon-purple)
![AI](https://img.shields.io/badge/AI-Google%20Gemini-green)
![Status](https://img.shields.io/badge/Status-Beta-yellow)

## 🎯 Key Features

### 📱 SMS Bill Detection
- Monitors incoming SMS from trusted billers
- AI-powered bill parsing (Google Gemini)
- Extracts: amount, due date, biller, reference

### 💸 Auto-Payment
- Pays bills automatically when balance is sufficient
- Sends notifications when balance is low
- Configurable auto-pay limits per biller

### 🔄 Auto-Convert to Stablecoin
- Deposits any crypto (ETH, MATIC, BTC)
- Automatically swaps to USDC via DEX
- Protects from volatility

### 🔐 Security Features
- Whitelist trusted biller numbers
- Set max auto-pay amounts
- Daily spending limits
- Fraud detection

## 🏗️ Architecture

```
┌─────────────┐         ┌─────────────┐         ┌──────────────┐
│   Mobile    │ ◄─────► │   Backend   │ ◄─────► │  Blockchain  │
│  (Flutter)  │  HTTP   │  (Node.js)  │  Web3   │   (Polygon)  │
└─────────────┘         └─────────────┘         └──────────────┘
                              │
                              ▼
                        ┌──────────┐
                        │ Gemini AI│
                        │  (FREE)  │
                        └──────────┘
```

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- Flutter 3.0+
- MongoDB (optional)

### 1. Clone Repository
```bash
git clone https://github.com/M-oses340/Billy-AI-.git
cd Billy-AI-
```

### 2. Deploy Smart Contract (Already Done!)
```
Contract Address: 0xaf15ff299F4795224E23D1b6Fd36805Fc32f114e
Network: Polygon Amoy Testnet
```

### 3. Setup Backend
```bash
cd backend
npm install

# Create .env file
cp .env.example .env

# Add your Gemini API key (FREE at https://aistudio.google.com/)
# GEMINI_API_KEY=your_key_here

# Start server
npm run dev
```

### 4. Setup Mobile App
```bash
cd mobile
flutter pub get

# Update contract address in lib/services/web3_service.dart
# contractAddress = "0xaf15ff299F4795224E23D1b6Fd36805Fc32f114e"

# Run app
flutter run
```

## 📦 Project Structure

```
billy/
├── contracts/          # Smart contracts (Solidity)
│   ├── BillyPayment.sol
│   └── scripts/deploy.js
├── backend/           # API server (Node.js/TypeScript)
│   ├── src/
│   │   ├── routes/
│   │   │   ├── smsRoutes.ts
│   │   │   ├── billRoutes.ts
│   │   │   └── walletRoutes.ts
│   │   └── services/
│   │       └── geminiService.ts
│   └── package.json
└── mobile/            # Flutter app
    ├── lib/
    │   ├── blocs/     # BLoC state management
    │   ├── models/
    │   ├── services/
    │   │   ├── sms_service.dart
    │   │   └── web3_service.dart
    │   └── screens/
    └── pubspec.yaml
```

## 🔧 Configuration

### Trusted Billers
Add trusted biller numbers in the mobile app:
```dart
trustedBillers = [
  { name: "Electric Co", number: "+1234567890", maxAmount: 200 },
  { name: "Water Utility", number: "+0987654321", maxAmount: 100 },
];
```

### Auto-Pay Rules
```typescript
{
  maxAmount: 500,           // Don't auto-pay over $500
  requireConfirmation: true, // Ask for amounts > $200
  minConfidence: 0.9,       // AI confidence threshold
  dailyLimit: 1000,         // Max $1000/day
}
```

## 💰 Supported Tokens

### Native Currencies
- ETH (Ethereum)
- MATIC (Polygon)

### Stablecoins
- USDC (recommended)
- USDT
- DAI

### Other Tokens
- WBTC (Wrapped Bitcoin)
- Any ERC20 token

## 🤖 AI Options

Billy supports multiple FREE AI providers:

| Provider | Free Tier | Speed | Setup |
|----------|-----------|-------|-------|
| **Gemini** (current) | 1,500/day | ⚡⚡⚡ | 2 min |
| Groq | 14,400/day | ⚡⚡⚡ | 2 min |
| Ollama | Unlimited | ⚡⚡ | 5 min |

See [AI_COMPARISON.md](backend/AI_COMPARISON.md) for details.

## 📱 Example SMS Formats

Billy can parse various bill formats:

```
"Your KPLC bill for March is KES 3,500. Pay by 30/03/2024. Ref: 1234567890"

"Nairobi Water: Your bill is KES 1,200. Due: 25th March. Account: 9876543"

"Safaricom Home Fiber: KES 2,999 due on 28/03/2024. Ref: SF-2024-001"
```

## 🔐 Security

- Private keys never leave mobile device
- SMS data encrypted in transit
- Trusted biller whitelist
- Spending limits and fraud detection
- Open source and auditable

## 🌐 Networks

### Testnet (Current)
- Network: Polygon Amoy
- Contract: `0xaf15ff299F4795224E23D1b6Fd36805Fc32f114e`
- Faucet: https://faucet.polygon.technology/

### Mainnet (Coming Soon)
- Network: Polygon
- Lower fees than Ethereum
- Fast transactions

## 📚 Documentation

- [SMS Auto-Pay Architecture](backend/SMS_AUTOPAY_ARCHITECTURE.md)
- [Free AI Setup Guide](backend/SETUP_FREE_AI.md)
- [Bridge Integration](contracts/BRIDGE_INTEGRATION.md)
- [Token Addresses](contracts/TOKEN_ADDRESSES.md)
- [Testnet Setup](contracts/TESTNET_SETUP.md)

## 🛣️ Roadmap

- [x] Smart contract deployment
- [x] SMS bill detection
- [x] Auto-convert to stablecoin
- [x] Auto-payment system
- [ ] Email bill monitoring
- [ ] Bill prediction AI
- [ ] Multi-currency support
- [ ] Bill splitting
- [ ] Mainnet deployment

## 🤝 Contributing

Contributions welcome! Please read our contributing guidelines.

## 📄 License

MIT License - see LICENSE file

## 🙏 Acknowledgments

- OpenZeppelin for smart contract libraries
- Google Gemini for AI bill parsing
- Polygon for low-cost blockchain
- QuickSwap for DEX integration

## 📞 Support

- GitHub Issues: [Report bugs](https://github.com/M-oses340/Billy-AI-/issues)
- Email: support@billy.app (coming soon)

---

Built with ❤️ by [M-oses340](https://github.com/M-oses340)

**⚠️ Disclaimer:** Billy is in beta. Use at your own risk. Always verify transactions before approval.
