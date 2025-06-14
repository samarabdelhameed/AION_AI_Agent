# 🧠 AION – The Immortal AI DeFi Agent on BNBChain

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

---

## 🚀 Deployment Status (mainnet)

## 🚀 Deployment Status (mainnet)

The **AIONVault** smart contract has been successfully deployed to the **BNB Mainnet**:

| Item                 | Value                                                                                                                                                             |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Network**          | BNB Mainnet (Chain ID: 56)                                                                                                                                        |
| **Contract Name**    | `AIONVault`                                                                                                                                                       |
| **Contract Address** | [`0x732bDE5798f20D96F71cdFC805227E97a4822090`](https://bscscan.com/address/0x732bDE5798f20D96F71cdFC805227E97a4822090)                                            |
| **Deployment TX**    | [`0xd747570d16a0362260a2aa39130ec9284ab72a23e16ac08a43b0e74cfec48343`](https://bscscan.com/tx/0xd747570d16a0362260a2aa39130ec9284ab72a23e16ac08a43b0e74cfec48343) |
| **Block**            | `51097893`                                                                                                                                                        |
| **Gas Used**         | `528,492` gas @ `0.1 gwei`                                                                                                                                        |
| **Total Cost**       | `0.0000528492 BNB`                                                                                                                                                |
| **Deployer Wallet**  | New SAFE Wallet used ✅                                                                                                                                           |

**Deployment Successful ✅ — Onchain Execution Complete**

---

## ✅ Contract Verification

After deploying the **AIONVault** contract to the **BNB Mainnet**, the contract was fully verified on both:

- ✅ **Sourcify**
- ✅ **BscScan** (official BNB Mainnet explorer)

---

### 🔍 Verification Process

#### Step 1 — Verify via Sourcify

```bash
forge verify-contract --chain-id 56 \
0x732bDE5798f20D96F71cdFC805227E97a4822090 \
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
--chain-id 56 \
0x732bDE5798f20D96F71cdFC805227E97a4822090 \
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

### 🔗 Live Verified Contract

- [✅ View on BscScan (Verified)](https://bscscan.com/address/0x732bDE5798f20D96F71cdFC805227E97a4822090#code)

---

### 🎯 Summary

✅ The **AIONVault.sol** smart contract is now:

- ✅ Verified on **Sourcify** → ensures transparency and open source compliance.
- ✅ Verified on **BscScan** → fully visible on-chain to hackathon judges and users.

---

The **AIONVault** smart contract has been successfully deployed to the **BNB Mainnet**:

| Item                 | Value                                                                                                                                                             |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Network**          | BNB Mainnet (Chain ID: 56)                                                                                                                                        |
| **Contract Name**    | `AIONVault`                                                                                                                                                       |
| **Contract Address** | [`0x732bDE5798f20D96F71cdFC805227E97a4822090`](https://bscscan.com/address/0x732bDE5798f20D96F71cdFC805227E97a4822090)                                            |
| **Deployment TX**    | [`0xd747570d16a0362260a2aa39130ec9284ab72a23e16ac08a43b0e74cfec48343`](https://bscscan.com/tx/0xd747570d16a0362260a2aa39130ec9284ab72a23e16ac08a43b0e74cfec48343) |
| **Block**            | `51097893`                                                                                                                                                        |
| **Gas Used**         | `528,492` gas @ `0.1 gwei`                                                                                                                                        |
| **Total Cost**       | `0.0000528492 BNB`                                                                                                                                                |
| **Deployer Wallet**  | New SAFE Wallet used ✅                                                                                                                                           |

**Deployment Successful ✅ — Onchain Execution Complete**

---

## ✅ Live Mainnet Testing

A full E2E testing of the MCP Agent → AIONVault Mainnet → Unibase Memory → AI Timeline flow was conducted successfully.

### 🔍 Test Scenario:

| Step | Action                | Wallet Used                                              | Result                                                                                                                                                                             |
| ---- | --------------------- | -------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1️⃣   | Deposit 0.0001 BNB    | `0x14D7795A2566Cd16eaA1419A26ddB643CE523655`             | ✅ Success → TX: [`0x89d4fd7c9d02794215ae8c0dccfd6ecf140526a73ae154fec4a976b61e83104b`](https://bscscan.com/tx/0x89d4fd7c9d02794215ae8c0dccfd6ecf140526a73ae154fec4a976b61e83104b) |
| 2️⃣   | Withdraw 0.00002 BNB  | `0x14D7795A2566Cd16eaA1419A26ddB643CE523655`             | ✅ Success → TX: [`0x99912be600c244dde5b11cccbf15e28fc48cd25a24a390c95142f1b374867ff0`](https://bscscan.com/tx/0x99912be600c244dde5b11cccbf15e28fc48cd25a24a390c95142f1b374867ff0) |
| 3️⃣   | Check Memory Timeline | API `/memory/0x14D7795A2566Cd16eaA1419A26ddB643CE523655` | ✅ Returned full Timeline-ready Memory                                                                                                                                             |

---

### 🧠 Timeline Memory Example (API Result)

````json
[
  {
    "content": "User performed deposit of 0.0001 BNB with strategy auto_yield",
    "role": "assistant",
    "metadata": {
      "wallet": "0x14D7795A2566Cd16eaA1419A26ddB643CE523655",
      "strategy": "auto_yield",
      "amount": 0.0001,
      "last_action": "Deposit"
    },
    "created_at": "2025-06-09T05:10:20.663Z"
  },
  {
    "content": "User performed withdraw of 0.00002 BNB with strategy auto_yield",
    "role": "assistant",
    "metadata": {
      "wallet": "0x14D7795A2566Cd16eaA1419A26ddB643CE523655",
      "strategy": "auto_yield",
      "amount": 0.00002,
      "last_action": "Withdraw"
    },
    "created_at": "2025-06-09T05:11:32.738Z"
  }
]

---

## 🔐 Smart Contract – AIONVault.sol

```solidity
function deposit() external payable;
function withdraw(uint256 amount) external;
function balanceOf(address user) external view returns (uint256);
````

- ✅ Emits `Deposited` and `Withdrawn`
- ✅ Prevents over-withdrawals
- ✅ Tracks vault balances

Deployed on: [BNB Testnet](https://testnet.bscscan.com/address/0x048AC9bE9365053c5569daa9860cBD5671869188)

Deployment TX: [View on BscScan](https://testnet.bscscan.com/tx/0x601c86ad950e92c5d2314c3d683f15b029a6a5e771226060a517e0688f261480)

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

````bash
git submodule update --init --recursive

---

## 📈 Live Testing Examples

```bash
# Health check
curl http://localhost:3001/ping

# Deposit
curl -X POST http://localhost:3001/vault/deposit \
  -H "Content-Type: application/json" \
  -d '{"wallet": "0x...", "amount": "0.005"}'

# Share memory
curl http://localhost:3001/share/0x...
````

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
