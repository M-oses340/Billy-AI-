const { ethers } = require("ethers");

console.log("Creating new test wallet...\n");

const wallet = ethers.Wallet.createRandom();

console.log("✅ Wallet Created!");
console.log("==========================================");
console.log("Address:", wallet.address);
console.log("Private Key:", wallet.privateKey);
console.log("==========================================\n");

console.log("⚠️  SAVE THIS INFORMATION SECURELY!");
console.log("⚠️  This is for TESTING ONLY - Never use for real funds!\n");

console.log("Next steps:");
console.log("1. Copy the private key (without 0x prefix)");
console.log("2. Create contracts/.env file");
console.log("3. Add: PRIVATE_KEY=your_private_key_here");
console.log("4. Get free test MATIC from:");
console.log("   - https://faucet.polygon.technology/");
console.log("   - https://mumbaifaucet.com/");
console.log("\n5. Then run: npx hardhat run scripts/deploy.js --network mumbai");
