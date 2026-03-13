const hre = require("hardhat");

async function main() {
  console.log("Deploying BillyPayment contract...");

  // Network-specific addresses
  const network = hre.network.name;
  let uniswapRouter, stablecoin;

  if (network === "polygon") {
    // Polygon Mainnet
    uniswapRouter = "0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff"; // QuickSwap
    stablecoin = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"; // USDC
  } else if (network === "amoy") {
    // Amoy Testnet (replaced Mumbai)
    uniswapRouter = "0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008"; // QuickSwap Amoy
    stablecoin = "0x41E94Eb019C0762f9Bfcf9Fb1E58725BfB0e7582"; // USDC Amoy
  } else {
    console.error("Unsupported network. Use polygon or amoy");
    process.exit(1);
  }

  console.log(`Network: ${network}`);
  console.log(`Uniswap Router: ${uniswapRouter}`);
  console.log(`Stablecoin (USDC): ${stablecoin}`);

  const BillyPayment = await hre.ethers.getContractFactory("BillyPayment");
  const billyPayment = await BillyPayment.deploy(uniswapRouter, stablecoin);

  await billyPayment.waitForDeployment();

  const address = await billyPayment.getAddress();
  console.log("\n✅ BillyPayment deployed to:", address);
  
  console.log("\n📝 Save this address to:");
  console.log("- backend/.env as CONTRACT_ADDRESS");
  console.log("- mobile/lib/services/web3_service.dart as contractAddress");
  
  console.log("\n⚙️ Contract Configuration:");
  console.log("- Auto-convert enabled: true");
  console.log("- Target stablecoin: USDC");
  console.log("- DEX: QuickSwap (Uniswap V2 fork)");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
