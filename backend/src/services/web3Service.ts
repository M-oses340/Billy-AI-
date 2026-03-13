import { ethers } from 'ethers';
import dotenv from 'dotenv';

dotenv.config();

const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const contractAddress = process.env.CONTRACT_ADDRESS || '';

// ABI for Billy contract (minimal for now)
const contractABI = [
  'function getWalletBalance(address user, address token) view returns (uint256)',
  'function deposit(address token, uint256 amount, bool convertToStable)',
  'function payBillFromWallet(uint256 billId)',
  'function createBill(address payee, uint256 amount, address token, uint256 dueDate) returns (uint256)',
  'event BillPaid(uint256 indexed billId, address indexed payer, uint256 amount)',
];

export async function getWalletBalance(userAddress: string, tokenAddress: string): Promise<number> {
  try {
    const contract = new ethers.Contract(contractAddress, contractABI, provider);
    const balance = await contract.getWalletBalance(userAddress, tokenAddress);
    return parseFloat(ethers.formatUnits(balance, 6)); // USDC has 6 decimals
  } catch (error) {
    console.error('Error getting wallet balance:', error);
    return 0;
  }
}

export async function createBillOnChain(
  payeeAddress: string,
  amount: number,
  tokenAddress: string,
  dueDate: Date
): Promise<string> {
  try {
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY || '', provider);
    const contract = new ethers.Contract(contractAddress, contractABI, wallet);
    
    const amountWei = ethers.parseUnits(amount.toString(), 6);
    const dueDateTimestamp = Math.floor(dueDate.getTime() / 1000);
    
    const tx = await contract.createBill(payeeAddress, amountWei, tokenAddress, dueDateTimestamp);
    const receipt = await tx.wait();
    
    return receipt.hash;
  } catch (error) {
    console.error('Error creating bill on chain:', error);
    throw error;
  }
}

export async function payBillOnChain(billId: number): Promise<string> {
  try {
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY || '', provider);
    const contract = new ethers.Contract(contractAddress, contractABI, wallet);
    
    const tx = await contract.payBillFromWallet(billId);
    const receipt = await tx.wait();
    
    return receipt.hash;
  } catch (error) {
    console.error('Error paying bill:', error);
    throw error;
  }
}

// Listen for BillPaid events
export function listenForPayments(callback: (billId: number, payer: string, amount: string) => void) {
  const contract = new ethers.Contract(contractAddress, contractABI, provider);
  
  contract.on('BillPaid', (billId, payer, amount) => {
    callback(Number(billId), payer, ethers.formatUnits(amount, 6));
  });
}
