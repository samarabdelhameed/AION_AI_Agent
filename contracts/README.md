### `contracts/README.md`

````markdown
# 📜 AION Contracts – On-Chain DeFi Vault (Foundry)

This directory contains the smart contracts powering the **AION** decentralized AI agent on **BNBChain**. The main contract is a lightweight vault (`AIONVault.sol`) that handles deposits, withdrawals, and balance tracking for users.

Contracts are written in **Solidity**, tested with **Foundry**, and optimized for performance and composability within the AION agent flow.

---

## 🧱 Tech Stack

- **Language:** Solidity `^0.8.20`
- **Framework:** Foundry (Forge + Cast)
- **Test Runner:** Forge
- **Utilities:** forge-std
- **Chain:** BNBChain (testnet/mainnet)

---

## 📂 Folder Structure

```bash
contracts/
├── src/                  # Core smart contracts
│   ├── AIONVault.sol     # Main user vault
│   └── Counter.sol       # Example/testing contract
├── test/                 # Forge test files (t.sol)
├── lib/                  # External libraries (forge-std)
├── script/               # Deployment scripts (optional)
├── foundry.toml          # Foundry configuration
└── README.md             # This file
```
````

---

## ⚙️ Setup

> Requires: [Foundry installed](https://book.getfoundry.sh/getting-started/installation)

```bash
cd contracts
forge install              # install dependencies (e.g., forge-std)
forge build                # compile contracts
```

---

## 🧪 Run Tests

```bash
forge test -vvvv
```

### ✅ Test Coverage

| Test Case                        | Status  |
| -------------------------------- | ------- |
| Deposit increases balance        | ✅ PASS |
| BalanceOf returns correct value  | ✅ PASS |
| Withdraw reduces balance         | ✅ PASS |
| Reverts on over-withdraw attempt | ✅ PASS |

Each test simulates a user interaction and ensures correct internal accounting. Custom errors and event logs are verified.

---

## 🔐 AIONVault.sol Overview

```solidity
function deposit() external payable;
function withdraw(uint256 amount) external;
function balanceOf(address user) external view returns (uint256);
```

- Emits `Deposited` and `Withdrawn` events
- Uses `msg.sender` and `msg.value` for native token handling
- Prevents over-withdrawal using a custom revert error

---

## 🧩 Planned Upgrades

- ERC-20 deposit/withdraw support
- ZK-based access controls
- Intent-aware callbacks from the MCP AI Agent
- LayerZero / cross-chain hooks

---

## 📄 License

MIT © 2025 – Samar Abdelhameed

```

---


```
