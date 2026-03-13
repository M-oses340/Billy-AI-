# Billy Quick Start Guide

## Prerequisites
- Node.js 16+ and npm
- Docker (for MongoDB)
- Flutter SDK 3.0+ (for mobile app)
- Git

## 1. Clone and Setup

```bash
git clone https://github.com/M-oses340/Billy-AI-.git
cd Billy-AI-
```

## 2. Start Backend

```bash
# Start MongoDB
docker run --name billy-mongo -d -p 27017:27017 -e MONGO_INITDB_DATABASE=billy mongo:latest

# Install backend dependencies
cd backend
npm install

# Start backend server
npm run dev
```

Backend will start on `http://localhost:3000`

## 3. Test SMS Processing

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

Expected: Bill parsed successfully with Gemini AI

## 4. Setup Mobile App (Optional)

```bash
cd mobile
flutter pub get
flutter run
```

## Key Information

- **Contract**: `0xaf15ff299F4795224E23D1b6Fd36805Fc32f114e`
- **Network**: Polygon Amoy Testnet
- **Test Wallet**: `0x738CAE8a861e9419a8e9f1f27691A8Da06eaD803`

See `STATUS.md` for complete project status.
