# Supported Token Addresses

## Native Currencies

| Chain | Symbol | Address in Contract |
|-------|--------|---------------------|
| Ethereum | ETH | `0x0000000000000000000000000000000000000000` (address(0)) |
| Polygon | MATIC | `0x0000000000000000000000000000000000000000` (address(0)) |

**Note:** Use `address(0)` or `0x0000000000000000000000000000000000000000` for native ETH/MATIC

## Polygon Mainnet

| Token | Symbol | Address |
|-------|--------|---------|
| USD Coin | USDC | `0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174` |
| Tether USD | USDT | `0xc2132D05D31c914a87C6611C10748AEb04B58e8F` |
| Dai Stablecoin | DAI | `0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063` |
| Wrapped Matic | WMATIC | `0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270` |
| Wrapped BTC | WBTC | `0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6` |
| Wrapped ETH | WETH | `0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619` |

## Mumbai Testnet (for testing)

| Token | Symbol | Address |
|-------|--------|---------|
| USD Coin | USDC | `0x0FA8781a83E46826621b3BC094Ea2A0212e71B23` |
| Tether USD | USDT | `0xA02f6adc7926efeBBd59Fd43A84f4E0c0c91e832` |
| Dai Stablecoin | DAI | `0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F` |
| Wrapped Matic | WMATIC | `0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889` |

## How to Use

### Deposit Native ETH/MATIC

```javascript
// Deposit 1 ETH/MATIC
await billyPayment.depositNative({ value: ethers.parseEther("1") });

// Or send directly to contract
await signer.sendTransaction({
  to: billyPaymentAddress,
  value: ethers.parseEther("1")
});
```

### Deposit ERC20 Tokens

```javascript
// Example: Deposit 100 USDC
await billyPayment.deposit(
  "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174", // USDC address
  ethers.parseUnits("100", 6) // USDC has 6 decimals
);
```

### Create Bill with Native Currency

```javascript
// Bill payable in ETH/MATIC
await billyPayment.createBill(
  payeeAddress,
  ethers.parseEther("0.5"), // 0.5 ETH/MATIC
  "0x0000000000000000000000000000000000000000", // address(0) for native
  dueDate
);
```

## Token Decimals

- USDC: 6 decimals
- USDT: 6 decimals  
- DAI: 18 decimals
- WMATIC: 18 decimals
