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
  } else if (network === "mumbai") {
    // Mumbai Testnet
    uniswapRouter = "0x8954AfA98594b838bda56FE4C12a09D7739D179b"; // QuickSwap Mumbai
    stablecoin = "0x0FA8781a83E46826621b3BC094Ea2A0212e71B23"; // USDC Mumbai
  } else {
    console.error("Unsupported network. Use polygon or mumbai");
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
