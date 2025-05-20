# 🧠 MCP Agent – AI Logic for AION

This module powers the decentralized AI agent logic for **AION**, integrating with:

- 🧠 **Membase** for sovereign memory (via `MultiMemory`)
- 🧩 **BitAgent (via AIP SDK)** for agent interoperability
- 📚 **KnowledgeBase (Chroma)** for AI-driven strategy recall
- 💾 **Unibase DA Layer** for on-chain memory proof
- 🔐 **AIONVault** for smart contract execution on **BNBChain**

---

## 📁 Folder Structure

```bash
mcp_agent/
├── index.js                 # Node.js backend server (MCP Agent)
├── agent_memory.py         # Python: stores memory & knowledge via Unibase SDK
├── aip_share.py            # Python: share memory via AIP agent protocol
├── memory.json             # (Legacy) fallback memory (deprecated)
├── history.json            # Tracks wallet + vault balance snapshots
├── abi/                    # AIONVault ABI
├── .env                    # RPC_URL, PRIVATE_KEY, CONTRACT_ADDRESS
└── README.md               # This file
```

---

## 🛠 Setup & Installation

```bash
cd mcp_agent
npm install
pip install git+https://github.com/unibaseio/membase.git
pip install git+https://github.com/unibaseio/aip-agent.git
```

Create `.env`:

```env
RPC_URL=https://data-seed-prebsc-1-s1.binance.org:8545
PRIVATE_KEY=YOUR_PRIVATE_KEY_HERE
CONTRACT_ADDRESS=0x048AC9bE9365053c5569daa9860cBD5671869188
```

---

## 🚀 Running the Agent & Server

```bash
# Start the MCP API server
node index.js

# Execute AIP Agent Interop (simulate cross-agent knowledge sync)
python3 aip_share.py <wallet_address>
```

Expected logs (Node.js):

```
🚀 MCP Agent is listening at http://localhost:3001
✅ Unibase memory saved: ✅ Memory & Knowledge saved successfully.
```

Expected logs (Python AIP):

```
🔗 Initializing AIP Agent 'AinonAgent'...
🔑 Connecting agent to wallet: 0x...
📩 Sending message to AinonAgent memory...
✅ Memory log sent via send_message ✅
```

---

## ✅ Features Implemented

### 🧠 AI + Memory Layer

- ✅ **MultiMemory (Membase)** integration for sovereign memory
- ✅ **Chroma KnowledgeBase** for contextual strategy memory
- ✅ Memory logged from deposit/withdraw actions in `agent_memory.py`

### 🤝 Agent-to-Agent Communication

- ✅ `aip_share.py` sends AI memory to BitAgent using AIP SDK
- ✅ AIP Agent initialized with `SingleThreadedAgentRuntime`
- ✅ Exposed `/share/:wallet` API for BitAgent compatibility

### 🔐 DeFi Execution (Smart Contract)

- ✅ `AIONVault.sol` supports deposit and withdraw in native BNB
- ✅ On-chain state is updated and logged in `history.json`
- ✅ Deposit/Withdraw logic integrated with ethers.js + Python memory log

---

## ✅ API Endpoints

| Route              | Method | Description                       |
| ------------------ | ------ | --------------------------------- |
| `/`                | GET    | Welcome message                   |
| `/ping`            | GET    | Check if server is alive          |
| `/memory/all`      | GET    | Get memory for all wallets        |
| `/memory/:wallet`  | GET    | Get memory for a specific wallet  |
| `/memory`          | POST   | Add/update memory manually        |
| `/wallet/:address` | GET    | Get BNB balance for an address    |
| `/vault/:wallet`   | GET    | Get vault balance from contract   |
| `/vault/deposit`   | POST   | Deposit BNB to AIONVault          |
| `/vault/withdraw`  | POST   | Withdraw BNB from AIONVault       |
| `/history/:wallet` | GET    | View wallet-vault historical data |
| `/share/:wallet`   | GET    | Share memory to BitAgent (AIP)    |
| `/analyze/:wallet` | GET    | AI-based strategy recommendation  |

---

## ✅ Integration Logs (Live Testing)

```bash
# 🔁 Run full agent sharing (Python)
python3 aip_share.py 0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3

# 🟢 Check server is alive
curl http://localhost:3001/ping

# ✅ Deposit simulation
curl -X POST http://localhost:3001/vault/deposit \
  -H "Content-Type: application/json" \
  -d '{"amount": "0.00001", "wallet": "0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3"}'

# ✅ Withdraw simulation
curl -X POST http://localhost:3001/vault/withdraw \
  -H "Content-Type: application/json" \
  -d '{"amount": "0.000001"}'

# 🧠 Read memory
curl http://localhost:3001/memory/0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3

# 📊 Analyze strategy
curl http://localhost:3001/analyze/0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3

# 🔁 Share memory
curl http://localhost:3001/share/0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3
```

---

## 🧩 Planned Enhancements

| Feature                    | Description                                  |
| -------------------------- | -------------------------------------------- |
| 🗣️ NLP Agent               | Natural queries: "What should I do next?"    |
| ⚡ Gas Oracle              | `/gas-price` endpoint with live data         |
| 🔐 Auth Layer              | AIP Agent auth with JWT/Passkeys             |
| 🌉 Cross-chain Vault Logic | Support zkSync, Arbitrum, Base               |
| 🔏 ZK-Proof DA Storage     | Long-term memory proof via Unibase blob + ZK |

---

## 📄 License

MIT © 2025 – Samar Abdelhameed

```

```
