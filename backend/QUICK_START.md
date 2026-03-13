# Billy Backend - Quick Start

## Fastest Way to Run (No Database)

```bash
cd backend
npm install
npm run dev
```

That's it! Backend runs without database.

## With Docker (Includes MongoDB)

```bash
cd backend
docker-compose up -d
```

This starts:
- MongoDB on port 27017
- Backend on port 3000

## With Local MongoDB

### 1. Start MongoDB
```bash
# Docker (easiest)
docker run -d --name billy-mongo -p 27017:27017 mongo

# Or install locally (see DATABASE_SETUP.md)
```

### 2. Update .env
```bash
MONGODB_URI=mongodb://localhost:27017/billy
```

### 3. Start Backend
```bash
npm run dev
```

## Environment Variables

Required:
```bash
GEMINI_API_KEY=your_key_here
CONTRACT_ADDRESS=0xaf15ff299F4795224E23D1b6Fd36805Fc32f114e
RPC_URL=https://rpc-amoy.polygon.technology
```

Optional:
```bash
MONGODB_URI=mongodb://localhost:27017/billy
PORT=3000
```

## Test It's Working

```bash
curl http://localhost:3000/health
```

Should return:
```json
{
  "status": "ok",
  "message": "Billy backend with SMS auto-pay is running",
  "features": {
    "smsAutoPay": true,
    "aiParsing": "Google Gemini",
    "blockchain": "Polygon Amoy",
    "contract": "0xaf15ff299F4795224E23D1b6Fd36805Fc32f114e"
  }
}
```

## Test SMS Processing

```bash
curl -X POST http://localhost:3000/api/sms/process \
  -H "Content-Type: application/json" \
  -d '{
    "from": "+1234567890",
    "message": "Your electricity bill is $150. Due: March 30. Ref: ELC-001",
    "userAddress": "0x738CAE8a861e9419a8e9f1f27691A8Da06eaD803",
    "userId": "user123"
  }'
```

## Troubleshooting

### Port 3000 already in use
```bash
# Change port in .env
PORT=3001
```

### MongoDB connection error
```bash
# Run without database (comment out in .env)
# MONGODB_URI=mongodb://localhost:27017/billy
```

### Gemini API error
Check your API key at: https://aistudio.google.com/

## Next Steps

1. ✅ Backend running
2. 📱 Set up mobile app
3. 🧪 Test SMS auto-pay
4. 🚀 Deploy to production
