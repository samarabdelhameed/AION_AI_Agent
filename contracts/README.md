# AION AI Agent - Smart Contract Strategies

## Overview

This repository contains a comprehensive suite of DeFi yield farming strategies implemented as smart contracts. The system uses a **Strategy Adapter Pattern** to manage multiple strategies and provide users with diversified yield farming options.

## 🏗️ Architecture

### Strategy Adapter Pattern

- **StrategyAdapter**: Central contract that manages all strategies
- **IStrategy Interface**: Standard interface for all strategies
- **Multiple Strategies**: Each targeting different DeFi protocols

## 📊 Available Strategies

### 1. StrategyVenus (Venus Lending)

- **Protocol**: Venus Protocol (BSC)
- **Risk Level**: 2/5 (Low Risk)
- **APY**: 5%
- **Type**: Lending & Borrowing
- **Features**:
  - Supply assets to earn interest
  - Automatic compounding
  - Low risk, stable returns

### 2. StrategyBeefy (Beefy Finance)

- **Protocol**: Beefy Finance
- **Risk Level**: 3/5 (Medium Risk)
- **APY**: 8%
- **Type**: Yield Farming
- **Features**:
  - Multi-protocol yield farming
  - Auto-compounding vaults
  - Higher yields with moderate risk

### 3. StrategyPancake (PancakeSwap LP)

- **Protocol**: PancakeSwap
- **Risk Level**: 4/5 (High Risk)
- **APY**: 12%
- **Type**: Liquidity Provision
- **Features**:
  - LP token farming
  - CAKE rewards
  - Impermanent loss risk

### 4. StrategyMorpho (Morpho Lending)

- **Protocol**: Morpho Protocol
- **Risk Level**: 2/5 (Low Risk)
- **APY**: 6%
- **Type**: Optimized Lending
- **Features**:
  - Peer-to-peer lending
  - Optimized capital efficiency
  - Lower risk than traditional lending

### 5. StrategyWombat (Wombat Exchange)

- **Protocol**: Wombat Exchange
- **Risk Level**: 3/5 (Medium Risk)
- **APY**: 10%
- **Type**: Stablecoin Farming
- **Features**:
  - Stablecoin yield farming
  - Concentrated liquidity
  - Stable returns

### 6. UniswapStrategy (Uniswap V3)

- **Protocol**: Uniswap V3
- **Risk Level**: 5/5 (Highest Risk)
- **APY**: 15%
- **Type**: Concentrated Liquidity
- **Features**:
  - Concentrated liquidity positions
  - Higher fees in active ranges
  - Maximum impermanent loss risk

## 🎯 Strategy Comparison

| Strategy | Risk Level | APY | Type            | Best For                   |
| -------- | ---------- | --- | --------------- | -------------------------- |
| Venus    | 2/5        | 5%  | Lending         | Conservative investors     |
| Morpho   | 2/5        | 6%  | Lending         | Capital efficiency seekers |
| Beefy    | 3/5        | 8%  | Yield Farming   | Balanced risk/reward       |
| Wombat   | 3/5        | 10% | Stablecoin      | Stable yield seekers       |
| Pancake  | 4/5        | 12% | LP Farming      | Higher risk tolerance      |
| Uniswap  | 5/5        | 15% | Concentrated LP | Maximum yield seekers      |

## 🚀 Key Features

### Strategy Adapter

- **Multi-Strategy Management**: Single interface for all strategies
- **Risk-Based Recommendations**: AI-powered strategy suggestions
- **Unified Deposits/Withdrawals**: One contract for all operations
- **Fee Management**: Centralized fee collection and distribution
- **Emergency Controls**: Pause/unpause all strategies

### Individual Strategies

- **Standardized Interface**: All implement `IStrategy`
- **Fee Structure**: Performance + Management fees
- **Emergency Withdrawals**: Safety mechanisms
- **Pause Functionality**: Risk management
- **TVL Tracking**: Real-time value locked

## 📁 Contract Structure

```
contracts/
├── src/
│   ├── interfaces/
│   │   └── IStrategy.sol
│   ├── strategies/
│   │   ├── StrategyVenus.sol
│   │   ├── StrategyBeefy.sol
│   │   ├── StrategyPancake.sol
│   │   ├── StrategyMorpho.sol
│   │   ├── StrategyWombat.sol
│   │   └── UniswapStrategy.sol
│   └── StrategyAdapter.sol
├── script/
│   └── DeployStrategies.s.sol
└── test/
    └── AllStrategies.t.sol
```

## 🔧 Usage

### Deploying Strategies

```bash
# Deploy all strategies
forge script script/DeployStrategies.s.sol --rpc-url <RPC_URL> --broadcast
```

### Testing

```bash
# Run all tests
forge test

# Run specific test
forge test --match-test testStrategyAdapter
```

### Key Functions

#### Strategy Adapter

```solidity
// Add a new strategy
strategyAdapter.addStrategy(strategyAddress, "Strategy Name", riskLevel);

// Deposit into strategy
strategyAdapter.deposit(strategyId, amount);

// Withdraw from strategy
strategyAdapter.withdraw(strategyId, shares);

// Get strategy recommendation
uint256 recommendedStrategy = strategyAdapter.getStrategyRecommendation(user, riskTolerance);

// Harvest all strategies
strategyAdapter.harvestAll();
```

#### Individual Strategies

```solidity
// Deposit
strategy.deposit(amount);

// Withdraw
strategy.withdraw(shares);

// Harvest rewards
strategy.harvest();

// Get info
(string memory name, string memory symbol, uint8 decimals) = strategy.getStrategyInfo();
uint8 riskLevel = strategy.getRiskLevel();
uint256 apy = strategy.getAPY();
```

## 🛡️ Security Features

### Risk Management

- **Pause Mechanism**: Emergency pause for all strategies
- **Fee Limits**: Maximum performance fee (5%) and management fee (2%)
- **Emergency Withdrawals**: Immediate fund recovery
- **Reentrancy Protection**: All external calls protected

### Access Control

- **Ownable**: Admin functions restricted to owner
- **Fee Management**: Only owner can update fees
- **Strategy Management**: Only owner can add/remove strategies

## 📈 Performance Metrics

### Fee Structure

- **Performance Fee**: 2% of harvested rewards
- **Management Fee**: 0.5% annually
- **Fee Collection**: Daily intervals

### Risk Levels

- **Level 1-2**: Low risk (Lending protocols)
- **Level 3**: Medium risk (Yield farming)
- **Level 4**: High risk (LP farming)
- **Level 5**: Highest risk (Concentrated liquidity)

## 🔮 Future Enhancements

### Planned Features

- **Dynamic APY**: Real-time APY calculation
- **Strategy Rebalancing**: Automatic portfolio rebalancing
- **Cross-Chain Support**: Multi-chain strategy deployment
- **Advanced Analytics**: Detailed performance metrics
- **Governance**: DAO-based strategy management

### Integration Opportunities

- **More Protocols**: Aave, Compound, Curve
- **Cross-Chain**: Ethereum, Polygon, Arbitrum
- **Advanced Strategies**: Options, Futures, Derivatives

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Implement your strategy following the `IStrategy` interface
4. Add comprehensive tests
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details

## 🆘 Support

For questions or support:

- Create an issue in the repository
- Check the documentation
- Review the test files for usage examples

---

**Note**: This is a demonstration project. All strategies are simplified implementations and should not be used in production without thorough auditing and testing.
