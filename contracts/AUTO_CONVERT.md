# Auto-Convert to Stablecoin Feature

Billy automatically converts deposited crypto (ETH, MATIC, WBTC, etc.) to USDC stablecoin to protect users from price volatility.

## How It Works

1. **User deposits any crypto** (ETH, MATIC, WBTC, etc.)
2. **Billy automatically swaps** to USDC via QuickSwap DEX
3. **USDC is stored** in user's Billy wallet
4. **Bills are paid** in stable USDC value

## Benefits

- **No volatility risk**: Your $100 deposit stays $100
- **Predictable payments**: Bills are paid with stable value
- **Automatic**: No manual swapping needed
- **Gas efficient**: Single transaction for deposit + swap

## Usage

### Auto-Convert on Deposit (Default)

```javascript
// Deposit 1 MATIC - automatically converts to USDC
await billyPayment.depositNative(true, { value: ethers.parseEther("1") });

// Deposit WBTC - automatically converts to USDC
await billyPayment.deposit(wbtcAddress, amount, true);
```

### Deposit Without Converting

```javascript
// Keep as native MATIC
await billyPayment.depositNative(false, { value: ethers.parseEther("1") });

// Keep as original token
await billyPayment.deposit(tokenAddress, amount, false);
```

### Manual Conversion

```javascript
// Convert existing balance to USDC
await billyPayment.convertToStablecoin(
  "0x0000000000000000000000000000000000000000", // address(0) for native
  ethers.parseEther("1")
);
```

## Supported Conversions

| From | To | Route |
|------|-----|-------|
| MATIC | USDC | MATIC → USDC |
| ETH | USDC | ETH → USDC |
| WBTC | USDC | WBTC → WMATIC → USDC |
| Any ERC20 | USDC | Token → WMATIC → USDC |

## DEX Integration

- **Polygon**: QuickSwap (Uniswap V2 fork)
- **Ethereum**: Uniswap V2
- **Slippage**: 0.5% default (configurable)

## Admin Functions

```javascript
// Enable/disable auto-convert
await billyPayment.setAutoConvert(true);

// Change target stablecoin
await billyPayment.setStablecoin(newStablecoinAddress);
```

## Gas Costs

| Operation | Estimated Gas (Polygon) |
|-----------|------------------------|
| Deposit + Auto-convert | ~0.02 MATIC ($0.01) |
| Manual conversion | ~0.015 MATIC ($0.008) |
| Regular deposit (no convert) | ~0.005 MATIC ($0.003) |

## Example Flow

```
User deposits 1 MATIC ($0.80)
    ↓
QuickSwap swaps to USDC
    ↓
User receives ~0.79 USDC (after 0.3% DEX fee)
    ↓
Bill payment uses stable 0.79 USDC
```

## Security Notes

- Slippage protection prevents sandwich attacks
- 5-minute deadline prevents stale transactions
- Only owner can change stablecoin target
- DEX router is immutable after deployment
