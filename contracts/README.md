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
├── script/               # Deployment & interaction scripts
├── lib/                  # External libraries (forge-std)
├── foundry.toml          # Foundry configuration
└── README.md             # This file
```

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

## 🚀 Deployed to BNB Testnet

| Item                 | Value                                                                                                                          |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| **Network**          | BNBChain Testnet (Chain ID: 97)                                                                                                |
| **Contract Name**    | AIONVault                                                                                                                      |
| **Deployed Address** | [`0x048AC9bE9365053c5569daa9860cBD5671869188`](https://testnet.bscscan.com/address/0x048AC9bE9365053c5569daa9860cBD5671869188) |
| **Deployment TX**    | [`0x601c86ad...`](https://testnet.bscscan.com/tx/0x601c86ad950e92c5d2314c3d683f15b029a6a5e771226060a517e0688f261480)           |
| **Gas Used**         | 528,492 @ 5 gwei                                                                                                               |
| **Broadcast Method** | `forge script script/Deploy.s.sol --rpc-url bnbTestnet --private-key $PRIVATE_KEY --broadcast`                                 |

---

## 📤 Interaction via Script

Using `InteractScript` in `Foundry`, we successfully executed deposit and withdraw operations:

| Action     | Amount (BNB) | TX Hash                                                                                                            |
| ---------- | ------------ | ------------------------------------------------------------------------------------------------------------------ |
| Deposit    | 0.005        | [`0xeb1499...`](https://testnet.bscscan.com/tx/0xeb149918db1d4610504bdfcd8bb0359e1f5f8388d007caf275d729824019b946) |
| Withdrawal | 0.002        | [`0xbfd43f...`](https://testnet.bscscan.com/tx/0xbfd43fc788f1da204ba5625005eec5def2ea6e2fee100fff71b3beb00cee2196) |

**Script Summary**:

```bash
forge script script/Interact.s.sol:InteractScript --rpc-url bnbTestnet --private-key $PRIVATE_KEY --broadcast -vvvv
```

✅ Result:

- `Deposit of 5000000000000000 BNB successful`
- `Withdrawal of 2000000000000000 BNB successful`

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

```
