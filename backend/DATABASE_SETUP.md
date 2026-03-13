# Database Setup Guide

Billy supports two database options:

## Option 1: No Database (Default)

Billy works without a database! Just comment out MongoDB in `.env`:

```bash
# MONGODB_URI=mongodb://localhost:27017/billy
```

The backend will work fine, storing data in memory and on blockchain.

## Option 2: MongoDB (Recommended)

### Quick Setup with Docker (Easiest)

```bash
# Start MongoDB in Docker
docker run -d \
  --name billy-mongo \
  -p 27017:27017 \
  -e MONGO_INITDB_DATABASE=billy \
  mongo:latest

# Add to .env
MONGODB_URI=mongodb://localhost:27017/billy
```

### Install MongoDB Locally

#### Ubuntu/Debian:
```bash
# Import MongoDB public key
wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add -

# Add MongoDB repository
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Install
sudo apt-get update
sudo apt-get install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod

# Add to .env
MONGODB_URI=mongodb://localhost:27017/billy
```

#### macOS:
```bash
# Install with Homebrew
brew tap mongodb/brew
brew install mongodb-community

# Start MongoDB
brew services start mongodb-community

# Add to .env
MONGODB_URI=mongodb://localhost:27017/billy
```

#### Windows:
1. Download from: https://www.mongodb.com/try/download/community
2. Run installer
3. Start MongoDB service
4. Add to .env: `MONGODB_URI=mongodb://localhost:27017/billy`

### Cloud MongoDB (Free Tier)

#### MongoDB Atlas (Recommended - FREE)

1. **Sign up**: https://www.mongodb.com/cloud/atlas/register
2. **Create free cluster** (M0 - 512MB free)
3. **Get connection string**:
   - Click "Connect"
   - Choose "Connect your application"
   - Copy connection string
4. **Add to .env**:
```bash
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/billy?retryWrites=true&w=majority
```

**Free Tier Limits:**
- 512 MB storage
- Shared RAM
- Perfect for Billy!

## Verify Connection

Start the backend:
```bash
cd backend
npm run dev
```

Look for:
```
✅ MongoDB connected
```

Or if no database:
```
⚠️  MongoDB not connected: (this is fine!)
```

## What Gets Stored in Database?

### Bills Collection
- SMS content and parsed data
- Payment status and history
- AI confidence scores
- Blockchain transaction hashes

### TrustedBillers Collection
- Biller names and phone numbers
- Auto-pay settings
- Payment statistics
- Average amounts

### Benefits of Using Database

✅ Bill history across restarts
✅ SMS parsing analytics
✅ Payment statistics
✅ Faster queries than blockchain
✅ Backup and recovery

## Database Schema

```javascript
// Bill
{
  userId: "user123",
  userAddress: "0x...",
  biller: "Electric Company",
  amount: 150,
  dueDate: "2024-03-30",
  status: "paid",
  transactionHash: "0x...",
  smsContent: "Your bill is $150...",
  aiConfidence: 0.95
}

// TrustedBiller
{
  userId: "user123",
  name: "Electric Company",
  phoneNumber: "+1234567890",
  autoPayEnabled: true,
  maxAutoPayAmount: 200,
  totalBills: 12,
  totalPaid: 1800
}
```

## Troubleshooting

### Connection Failed
```bash
# Check if MongoDB is running
sudo systemctl status mongod  # Linux
brew services list            # macOS

# Check port
netstat -an | grep 27017
```

### Authentication Error
Make sure username/password are correct in connection string.

### Network Error (Atlas)
Whitelist your IP in MongoDB Atlas:
- Go to Network Access
- Add IP Address
- Add current IP or 0.0.0.0/0 (allow all)

## Recommendation

**For Development:** Use Docker or local MongoDB
**For Production:** Use MongoDB Atlas (free tier)
**For Quick Testing:** No database needed!
