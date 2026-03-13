# Mumbai Testnet Setup Guide

## Step 1: Install Dependencies

```bash
cd contracts
npm install
```

## Step 2: Create Wallet & Get Private Key

### Option A: Use Existing MetaMask Wallet
1. Open MetaMask
2. Click account icon → Account Details → Show Private Key
3. Enter password and copy private key

### Option B: Create New Test Wallet (Recommended)
```bash
npx hardhat console
```
Then in console:
```javascript
const wallet = ethers.Wallet.createRandom();
console.log("Address:", wallet.address);
console.log("Private Key:", wallet.privateKey);
```

**⚠️ IMPORTANT: This is for TESTING ONLY. Never use this wallet for real funds!**

## Step 3: Get Free Test MATIC

Visit these faucets and paste your wallet address:

1. **Polygon Faucet** (Official)
   - https://faucet.polygon.technology/
   - Requires Twitter/GitHub login
   - Gives 0.5 MATIC

2. **Alchemy Faucet**
   - https://mumbaifaucet.com/
   - No login required
   - Gives 0.5 MATIC

3. **QuickNode Faucet**
   - https://faucet.quicknode.com/polygon/mumbai
   - Gives 0.1 MATIC

**You need at least 0.1 MATIC to deploy (~$0 in test tokens)**

## Step 4: Configure Environment

Create `.env` file in contracts folder:

```bash
cp .env.example .env
```

Edit `.env`:
```
PRIVATE_KEY=your_private_key_here_without_0x_prefix
MUMBAI_RPC_URL=https://rpc-mumbai.maticvigil.com
```

## Step 5: Add Mumbai to MetaMask (Optional)

- Network Name: Mumbai Testnet
- RPC URL: https://rpc-mumbai.maticvigil.com
- Chain ID: 80001
- Currency Symbol: MATIC
- Block Explorer: https://mumbai.polygonscan.com/

## Step 6: Deploy Contract

```bash
npx hardhat run scripts/deploy.js --network mumbai
```

Expected output:
```
Deploying BillyPayment contract...
Network: mumbai
Uniswap Router: 0x8954AfA98594b838bda56FE4C12a09D7739D179b
Stablecoin (USDC): 0x0FA8781a83E46826621b3BC094Ea2A0212e71B23

✅ BillyPayment deployed to: 0x...

📝 Save this address to:
- backend/.env as CONTRACT_ADDRESS
- mobile/lib/services/web3_service.dart as contractAddress
```

## Step 7: Verify Deployment

Check your contract on Mumbai PolygonScan:
```
https://mumbai.polygonscan.com/address/YOUR_CONTRACT_ADDRESS
```

## Step 8: Get Test USDC (Optional)

To test the full flow, get test USDC:
1. Visit https://faucet.circle.com/
2. Select "Mumbai Testnet"
3. Paste your address
4. Receive 10 test USDC

## Troubleshooting

**Error: insufficient funds**
- Get more test MATIC from faucets

**Error: nonce too high**
- Reset MetaMask: Settings → Advanced → Reset Account

**Error: network not found**
- Check MUMBAI_RPC_URL in .env

## Next Steps

After deployment:
1. Copy contract address
2. Update backend/.env
3. Update mobile app configuration
4. Test deposits and bill payments!
