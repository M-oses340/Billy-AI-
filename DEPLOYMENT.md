# Billy Deployment Guide

Complete guide to deploy Billy in different environments.

## 🚀 Quick Deploy (Development)

### 1. Backend (No Database)
```bash
cd backend
npm install
npm run dev
```
✅ Runs on http://localhost:3000

### 2. Mobile App
```bash
cd mobile
flutter pub get
flutter run
```
✅ Runs on connected device/emulator

---

## 🐳 Docker Deploy (Recommended)

### Full Stack with Docker Compose
```bash
cd backend
docker-compose up -d
```

This starts:
- MongoDB (port 27017)
- Backend API (port 3000)

---

## ☁️ Cloud Deployment Options

### Option 1: Heroku (Backend)

```bash
# Install Heroku CLI
curl https://cli-assets.heroku.com/install.sh | sh

# Login
heroku login

# Create app
cd backend
heroku create billy-backend

# Add MongoDB addon (free tier)
heroku addons:create mongolab:sandbox

# Set environment variables
heroku config:set GEMINI_API_KEY=your_key
heroku config:set CONTRACT_ADDRESS=0xaf15ff299F4795224E23D1b6Fd36805Fc32f114e
heroku config:set RPC_URL=https://rpc-amoy.polygon.technology

# Deploy
git push heroku main
```

### Option 2: Railway (Backend)

1. Visit: https://railway.app/
2. Connect GitHub repo
3. Select `backend` folder
4. Add environment variables
5. Deploy automatically

### Option 3: Vercel (Backend)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
cd backend
vercel
```

### Option 4: AWS/GCP/Azure

See detailed guides in `docs/cloud-deployment/`

---

## 📱 Mobile App Deployment

### Android

```bash
cd mobile

# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
cd mobile

# Build for iOS
flutter build ios --release
```

Then open in Xcode and submit to App Store.

---

## 🔐 Production Checklist

### Backend
- [ ] Set strong MongoDB password
- [ ] Use environment variables (never commit .env)
- [ ] Enable HTTPS/SSL
- [ ] Set up monitoring (Sentry, LogRocket)
- [ ] Configure CORS properly
- [ ] Set up rate limiting
- [ ] Enable API authentication
- [ ] Set up backup strategy

### Smart Contract
- [ ] Audit contract code
- [ ] Deploy to mainnet
- [ ] Verify on PolygonScan
- [ ] Set up multisig for admin functions
- [ ] Monitor contract events
- [ ] Set up emergency pause mechanism

### Mobile App
- [ ] Update API endpoints to production
- [ ] Update contract address to mainnet
- [ ] Enable ProGuard (Android)
- [ ] Set up crash reporting
- [ ] Configure push notifications
- [ ] Test on multiple devices
- [ ] Submit to app stores

---

## 🌐 Environment Variables

### Backend (.env)
```bash
# Required
GEMINI_API_KEY=your_gemini_key
CONTRACT_ADDRESS=0xaf15ff299F4795224E23D1b6Fd36805Fc32f114e
RPC_URL=https://rpc-amoy.polygon.technology
PRIVATE_KEY=your_private_key

# Optional
MONGODB_URI=mongodb://localhost:27017/billy
PORT=3000
NODE_ENV=production
```

### Mobile (lib/config/config.dart)
```dart
class Config {
  static const String apiUrl = 'https://api.billy.app';
  static const String contractAddress = '0xaf15ff...';
  static const String rpcUrl = 'https://polygon-rpc.com';
}
```

---

## 📊 Monitoring & Analytics

### Backend Monitoring
- **Uptime:** UptimeRobot, Pingdom
- **Errors:** Sentry
- **Logs:** Papertrail, Loggly
- **Performance:** New Relic, DataDog

### Blockchain Monitoring
- **Events:** The Graph, Moralis
- **Transactions:** PolygonScan API
- **Gas:** Blocknative

### Mobile Analytics
- **Crashes:** Firebase Crashlytics
- **Analytics:** Google Analytics, Mixpanel
- **Performance:** Firebase Performance

---

## 🔄 CI/CD Pipeline

### GitHub Actions Example

```yaml
name: Deploy Backend

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy to Heroku
        uses: akhileshns/heroku-deploy@v3.12.12
        with:
          heroku_api_key: ${{secrets.HEROKU_API_KEY}}
          heroku_app_name: "billy-backend"
          heroku_email: "your@email.com"
```

---

## 💰 Cost Estimates

### Development (Free)
- Backend: $0 (local)
- Database: $0 (local MongoDB)
- Blockchain: $0 (testnet)
- AI: $0 (Gemini free tier)
**Total: $0/month**

### Production (Small Scale)
- Backend: $7/month (Heroku Hobby)
- Database: $0 (MongoDB Atlas free tier)
- Blockchain: ~$10/month (gas fees)
- AI: $0 (within free tier)
- Domain: $12/year
**Total: ~$17/month**

### Production (Medium Scale)
- Backend: $25/month (Railway Pro)
- Database: $9/month (MongoDB Atlas M10)
- Blockchain: ~$50/month (gas fees)
- AI: $0-20/month (depends on usage)
- CDN: $0 (Cloudflare free)
**Total: ~$84-104/month**

---

## 🆘 Troubleshooting

### Backend won't start
```bash
# Check logs
npm run dev

# Common issues:
# - Port 3000 in use: Change PORT in .env
# - MongoDB error: Comment out MONGODB_URI
# - Missing env vars: Check .env file
```

### Mobile app can't connect
```bash
# Check API URL
# Android emulator: use 10.0.2.2:3000
# iOS simulator: use localhost:3000
# Real device: use your computer's IP
```

### Blockchain transactions failing
```bash
# Check:
# - Wallet has MATIC for gas
# - Contract address is correct
# - RPC URL is working
# - Network is correct (Amoy testnet)
```

---

## 📚 Additional Resources

- [Backend API Docs](backend/API.md)
- [Smart Contract Docs](contracts/README.md)
- [Mobile App Guide](mobile/README.md)
- [Security Best Practices](SECURITY.md)

---

## 🎯 Next Steps After Deployment

1. ✅ Test all features end-to-end
2. 📊 Set up monitoring and alerts
3. 🔐 Security audit
4. 📱 Beta testing with users
5. 🚀 Launch!

---

**Need help?** Open an issue on GitHub or contact support.
