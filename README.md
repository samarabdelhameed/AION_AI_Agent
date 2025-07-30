# 🧠 AION – The Immortal AI DeFi Agent on BNBChain

> **🚀 Professional AI Agent for DeFi Strategy Optimization**
>
> **Built with:** Solidity, Foundry, Node.js, Astro, MCP Protocol, Membase
>
> **Live Demo:** [Testnet Contracts](https://testnet.bscscan.com/address/0x4625bB7f14D4e34F9D11a5Df7566cd7Ec1994849)

## 🔍 Overview

**AION** is an on-chain, autonomous, and self-evolving AI agent that optimizes decentralized finance (DeFi) strategies on **BNBChain**. It leverages **Membase** for sovereign AI memory, **BitAgent** for cross-agent interoperability, and integrates with the **Model Context Protocol (MCP)** to provide intelligent recommendations, strategy execution, and memory synchronization — all on-chain.

---

## 🎥 Video & Presentation

- 📹 [Demo Video - Test Scenarios](https://www.youtube.com/watch?v=V4Mc4OpblnY)
- 📹 [Demo Video - Frontend integration](https://youtu.be/JL1IHw7m5PY)
- 🎤 [Pitch Presentation](https://www.youtube.com/watch?v=h3Lq5KR6SMo)
- [x twitter](https://x.com/AION_Agent)
- 🧪 **Test Scenarios:** located in `test_scenarios/` with sample interaction JSON files

---

## 🎯 Problem Statement

> **Challenge:** Traditional DeFi bots are stateless, lack learning capabilities, and operate with no memory or coordination.

### 🔧 Key Limitations in Current Systems:

- Stateless operation (no memory of past behavior)
- No learning from user actions or market changes
- No interoperability between agents or systems
- Centralized memory and reliance on off-chain analytics

### ✅ Our Solution:

AION introduces a **decentralized, immortal AI agent** that:

- Learns and evolves using sovereign memory (via Membase)
- Makes autonomous DeFi decisions (via MCP & BitAgent)
- Shares knowledge across agents (cross-agent protocol)
- Interacts directly with DeFi contracts on-chain

---

## 🧩 Tech Stack

| Layer           | Tools/Protocols                                 |
| --------------- | ----------------------------------------------- |
| Blockchain      | BNBChain (Testnet)                              |
| AI & Logic      | MCP Agent (Node.js + Express)                   |
| Memory Layer    | Membase + memory.json (simulated sovereign mem) |
| Knowledge Base  | Chroma + MultiMemory                            |
| Agent Interop   | BitAgent + AIP Protocol                         |
| Frontend        | Astro + Bun + TailwindCSS (structure ready)     |
| Smart Contracts | Solidity + Foundry                              |

---

## 🧠 Architecture

### ⚙️ System Components:

```mermaid
flowchart TD
    U[User] -->|Connect Wallet| UI[Frontend Astro UI]
    UI --> API[Node.js MCP API Server]
    API --> MEM[Memory Layer: memory.json / Membase]
    API --> AIStrategy[AI Strategy Layer - MCP & BitAgent]
    API --> SC[AIONVault Smart Contract]
    SC --> BNB[BNBChain Testnet]
    API --> Share[BitAgent Sync / AIP Protocol]
```

### 🧠 Memory Interaction:

```mermaid
sequenceDiagram
    participant User
    participant UI
    participant MCP_Agent
    participant Membase
    participant Contract

    User->>UI: Connect Wallet + Action
    UI->>MCP_Agent: /memory/write
    MCP_Agent->>Membase: Store action in memory.json
    MCP_Agent->>Contract: Interact (Deposit/Withdraw)
    MCP_Agent-->>Membase: Update memory with result
```

### 🔄 Cross-Agent Communication:

```mermaid
sequenceDiagram
    participant MCP_Agent
    participant BitAgent

    MCP_Agent->>BitAgent: POST memory via /share/:wallet
    BitAgent-->>MCP_Agent: ACK + Processed
```

---

## 🚀 Setup & Installation

### 🖥️ Frontend (Astro + Tailwind)

```bash
cd frontend
bun install
bun dev
```

> ✅ Note: Folder structure and UI components are scaffolded and ready. Integration in progress.

### ⛓️ Smart Contracts (Foundry)

```bash
cd contracts
forge install
forge build
forge test -vvvv
```

### 🤖 MCP Agent (Node.js)

```bash
cd mcp_agent
npm install
node index.js
```

Create `.env`:

```env
RPC_URL=https://data-seed-prebsc-1-s1.binance.org:8545
PRIVATE_KEY=YOUR_PRIVATE_KEY
CONTRACT_ADDRESS=DEPLOYED_VAULT_ADDRESS
```

---

## 📦 Folder Structure

```bash
AION_Agent/
├── contracts/       # Foundry smart contracts
├── frontend/        # Astro frontend dApp (structure ready)
├── mcp_agent/       # Node.js + Python (AIP Agent)
├── docs/            # Flowcharts & documentation
├── videos/          # Demos, walkthroughs, and presentations
│   ├── demo.mp4
│   └── pitch.mp4
├── test_scenarios/  # Example user scenarios or test cases
│   └── scenario_1.json
```

---

## ✅ Features

| Category          | Description                                                             |
| ----------------- | ----------------------------------------------------------------------- |
| 🧠 AI Agent       | Autonomous DeFi decision-making using strategy analysis                 |
| 🧾 Memory Layer   | Sovereign memory via Membase + memory.json                              |
| 🤝 Interop        | /share/\:wallet + AIP sync to BitAgent                                  |
| 🔐 Smart Contract | Native BNBVault contract with deposit/withdraw support                  |
| 📊 Dashboard      | Astro-powered frontend UI with wallet, memory, vault, strategy analysis |

---

## 🚀 Deployment Status (Testnet)

The **AIONVault** and **StrategyVenus** smart contracts have been successfully deployed to the **BNB Testnet**:

| Item                       | Value                                                                                                                                                                     |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Network**                | BNB Testnet (Chain ID: 97)                                                                                                                                                |
| **AIONVault Contract**     | [`0x4625bB7f14D4e34F9D11a5Df7566cd7Ec1994849`](https://testnet.bscscan.com/address/0x4625bB7f14D4e34F9D11a5Df7566cd7Ec1994849)                                            |
| **StrategyVenus Contract** | [`0x20F3880756be1BeA1aD4235692aCfbC97fAdfDa5`](https://testnet.bscscan.com/address/0x20F3880756be1BeA1aD4235692aCfbC97fAdfDa5)                                            |
| **Deployment TX**          | [`0xfe17c7ff615e7b8dd9a4f730745958767b2668f106b91237a14756a0415f1f8b`](https://testnet.bscscan.com/tx/0xfe17c7ff615e7b8dd9a4f730745958767b2668f106b91237a14756a0415f1f8b) |
| **Block**                  | `60028117`                                                                                                                                                                |
| **Gas Used**               | `4988959` gas @ `0.1 gwei`                                                                                                                                                |
| **Total Cost**             | `0.0004988959 BNB`                                                                                                                                                        |
| **Deployer Wallet**        | `0x14D7795A2566Cd16eaA1419A26ddB643CE523655` ✅                                                                                                                           |

**Deployment Successful ✅ — Onchain Execution Complete**

---

## ✅ Contract Verification

After deploying the **AIONVault** and **StrategyVenus** contracts to the **BNB Testnet**, both contracts were fully verified on:

- ✅ **Sourcify**
- ✅ **BscScan** (official BNB Testnet explorer)

---

### 🔍 Verification Process

#### Step 1 — Verify via Sourcify

```bash
forge verify-contract --chain-id 97 \
0x4625bB7f14D4e34F9D11a5Df7566cd7Ec1994849 \
src/AIONVault.sol:AIONVault \
--watch
```

**Result:**

```
Contract successfully verified on Sourcify.
```

---

#### Step 2 — Verify via BscScan

```bash
forge verify-contract --verifier etherscan \
--etherscan-api-key $BSCSCAN_API_KEY \
--chain-id 97 \
0x4625bB7f14D4e34F9D11a5Df7566cd7Ec1994849 \
src/AIONVault.sol:AIONVault \
--watch
```

**Result:**

```
Contract verification status:
Response: `OK`
Details: `Pass - Verified`
Contract successfully verified on BscScan.
```

---

### 🔗 Live Verified Contracts

- [✅ AIONVault on BscScan (Verified)](https://testnet.bscscan.com/address/0x4625bB7f14D4e34F9D11a5Df7566cd7Ec1994849#code)
- [✅ StrategyVenus on BscScan (Verified)](https://testnet.bscscan.com/address/0x20F3880756be1BeA1aD4235692aCfbC97fAdfDa5#code)

---

### 🎯 Summary

✅ The **AIONVault.sol** and **StrategyVenus.sol** smart contracts are now:

- ✅ Verified on **Sourcify** → ensures transparency and open source compliance.
- ✅ Verified on **BscScan** → fully visible on-chain to hackathon judges and users.

---

## ✅ Live Testnet Testing

A full E2E testing of the MCP Agent → AIONVault Testnet → Unibase Memory → AI Timeline flow was conducted successfully.

### 🔍 Test Scenario:

| Step | Action                | Wallet Used                                              | Result                                                                                                                                                                                     |
| ---- | --------------------- | -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1️⃣   | Deposit 0.01 BNB      | `0x14D7795A2566Cd16eaA1419A26ddB643CE523655`             | ✅ Success → TX: [`0xfe17c7ff615e7b8dd9a4f730745958767b2668f106b91237a14756a0415f1f8b`](https://testnet.bscscan.com/tx/0xfe17c7ff615e7b8dd9a4f730745958767b2668f106b91237a14756a0415f1f8b) |
| 2️⃣   | Strategy Integration  | `0x20F3880756be1BeA1aD4235692aCfbC97fAdfDa5`             | ✅ Success → Strategy properly initialized and linked to vault                                                                                                                             |
| 3️⃣   | Check Memory Timeline | API `/memory/0x14D7795A2566Cd16eaA1419A26ddB643CE523655` | ✅ Returned full Timeline-ready Memory                                                                                                                                                     |

---

### 🧠 Timeline Memory Example (API Result)

```json
[
  {
    "content": "User performed deposit of 0.01 BNB with strategy venus_lending",
    "role": "assistant",
    "metadata": {
      "wallet": "0x14D7795A2566Cd16eaA1419A26ddB643CE523655",
      "strategy": "venus_lending",
      "amount": 0.01,
      "last_action": "Deposit"
    },
    "created_at": "2025-01-09T05:10:20.663Z"
  }
]
```

---

## 🔐 Smart Contract – AIONVault.sol

```solidity
function deposit() external payable;
function withdraw(uint256 amount) external;
function balanceOf(address user) external view returns (uint256);
```

- ✅ Emits `Deposited` and `Withdrawn`
- ✅ Prevents over-withdrawals
- ✅ Tracks vault balances
- ✅ Integrates with StrategyVenus for yield generation

**Deployed Contracts:**

| Contract          | Address                                      | BscScan Link                                                                                      |
| ----------------- | -------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| **AIONVault**     | `0x4625bB7f14D4e34F9D11a5Df7566cd7Ec1994849` | [View on BscScan](https://testnet.bscscan.com/address/0x4625bB7f14D4e34F9D11a5Df7566cd7Ec1994849) |
| **StrategyVenus** | `0x20F3880756be1BeA1aD4235692aCfbC97fAdfDa5` | [View on BscScan](https://testnet.bscscan.com/address/0x20F3880756be1BeA1aD4235692aCfbC97fAdfDa5) |

---

## 🌍 API Endpoints

| Route              | Method | Description                                   |
| ------------------ | ------ | --------------------------------------------- |
| `/ping`            | GET    | MCP Health Check                              |
| `/memory/:wallet`  | GET    | Fetch user memory                             |
| `/memory`          | POST   | Update/add memory                             |
| `/vault/deposit`   | POST   | Deposit to vault                              |
| `/vault/withdraw`  | POST   | Withdraw from vault                           |
| `/wallet/:address` | GET    | Get native BNB balance                        |
| `/analyze/:wallet` | GET    | Recommend strategy based on memory            |
| `/share/:wallet`   | GET    | Share user memory with BitAgent (cross-agent) |

---

## 🌐 Integration Map

```mermaid
graph LR
    AIONVault --> MCPAgent --> Membase --> Chroma
    MCPAgent --> AIP[BitAgent Sync]
    MCPAgent --> UI[Astro Dashboard]
```

### 🔗 Unibase SDK Integration

This project uses [`unibase-sdk-go`](https://github.com/unibaseio/unibase-sdk-go) as a submodule to interact with the decentralized AI memory layer (Membase). Make sure to run:

```bash
git submodule update --init --recursive
```

---

## 📈 Live Testing Examples

```bash
# Health check
curl http://localhost:3001/ping

# Deposit
curl -X POST http://localhost:3001/vault/deposit \
  -H "Content-Type: application/json" \
  -d '{"wallet": "0x...", "amount": "0.01"}'

# Share memory
curl http://localhost:3001/share/0x...
```

---

## 🔮 Future Enhancements

| Feature                | Description                                           |
| ---------------------- | ----------------------------------------------------- |
| 💬 NLP Queries         | Ask: "What should I do next with 0.5 BNB?"            |
| 🔏 ZK Memory Storage   | Private memory snapshots with ZK-Proof + Unibase Blob |
| 🌉 Cross-Chain Vaults  | Support for Base, Arbitrum, zkSync                    |
| 📲 Wallet Auth         | Add WebAuthn / Passkey login                          |
| 🧠 AI Agent DAO        | Agent registry, governance, and upgradable behavior   |
| 🎨 Frontend Completion | Add interactive Astro UI for live demo                |

---

## 👩‍💻 Built With

Created with 💙 by **Samar Abdelhameed**
[GitHub](https://github.com/samarabdelhameed) • AI & Blockchain Engineer

## 📄 License

MIT © 2025 – Samar Abdelhameed
