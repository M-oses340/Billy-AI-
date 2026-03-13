# Bridge Integration Guide

Billy now supports native ETH/MATIC! For users with assets on other chains, here's how to bridge:

## From Solana to Ethereum/Polygon

### Option 1: Wormhole Bridge
1. Visit [Wormhole Portal](https://portalbridge.com/)
2. Connect Solana wallet (Phantom, Solflare)
3. Select token (USDC, USDT, SOL)
4. Choose destination: Ethereum or Polygon
5. Bridge tokens (takes ~15 minutes)

### Option 2: Allbridge
1. Visit [Allbridge](https://app.allbridge.io/)
2. Connect wallets (Solana + Ethereum/Polygon)
3. Select tokens and amount
4. Confirm bridge transaction

## From Bitcoin to Ethereum/Polygon

### Option 1: Wrapped Bitcoin (WBTC)
1. Use [WBTC](https://wbtc.network/) to wrap BTC
2. Receive WBTC on Ethereum
3. Bridge to Polygon if needed via [Polygon Bridge](https://wallet.polygon.technology/bridge)

### Option 2: RenBridge
1. Visit [RenBridge](https://bridge.renproject.io/)
2. Send BTC to generated address
3. Receive renBTC on Ethereum/Polygon

## Ethereum to Polygon (Lower Fees)

### Polygon Bridge (Official)
1. Visit [Polygon Bridge](https://wallet.polygon.technology/bridge)
2. Connect MetaMask
3. Select token and amount
4. Confirm transaction (~7-8 minutes)

### Alternative Bridges
- [Hop Protocol](https://app.hop.exchange/) - Faster, small fee
- [Synapse Bridge](https://synapseprotocol.com/) - Multi-chain
- [Stargate](https://stargate.finance/) - LayerZero powered

## Recommended Flow for Billy Users

1. **For Solana users:**
   - Bridge USDC from Solana → Polygon (lowest fees)
   - Deposit into Billy wallet

2. **For Bitcoin users:**
   - Convert BTC → WBTC
   - Bridge to Polygon
   - Swap WBTC → USDC on Polygon (via Uniswap/QuickSwap)
   - Deposit into Billy wallet

3. **For Ethereum users:**
   - Bridge ETH/tokens to Polygon for lower fees
   - Or use directly on Ethereum mainnet

## Gas Fees Comparison

| Chain | Average Transaction Cost |
|-------|-------------------------|
| Ethereum | $5 - $50 |
| Polygon | $0.01 - $0.10 |
| Solana | $0.00025 |

**Recommendation:** Use Polygon for bill payments to minimize fees!
