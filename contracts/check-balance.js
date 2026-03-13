const { ethers } = require("ethers");

const address = "0x738CAE8a861e9419a8e9f1f27691A8Da06eaD803";

console.log("Checking balance for:", address);
console.log("Network: Polygon Amoy Testnet\n");

const provider = new ethers.JsonRpcProvider("https://rpc-amoy.polygon.technology");

async function checkBalance() {
  try {
    const balance = await provider.getBalance(address);
    const balanceInMatic = ethers.formatEther(balance);
    
    console.log("✅ Balance:", balanceInMatic, "MATIC");
    
    if (parseFloat(balanceInMatic) > 0) {
      console.log("\n🎉 You have test MATIC! Ready to deploy!");
      console.log("\nRun: npx hardhat run scripts/deploy.js --network amoy");
    } else {
      console.log("\n❌ No MATIC found. Get free test MATIC from:");
      console.log("   https://faucet.polygon.technology/ (select Amoy)");
    }
  } catch (error) {
    console.error("Error:", error.message);
  }
}

checkBalance();
