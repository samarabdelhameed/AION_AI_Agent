# 🧠 MCP Agent – AI Logic for AION

This module powers the decentralized AI agent logic for **AION**, integrating with:

- 🧠 **Membase** for sovereign memory
- 🧩 **BitAgent (via AIP SDK)** for interoperability
- 📚 **KnowledgeBase** for AI-driven strategy recall
- 💾 **Unibase DA** for on-chain proof of memory
- 🔐 **AIONVault** for smart contract execution (BNBChain + zkSync)

---

## 📁 Folder Structure

```bash
mcp_agent/
├── index.js                 # Node.js backend server
├── agent_memory.py         # Python: stores memory & knowledge to Unibase
├── memory.json             # (Legacy) fallback memory
├── history.json            # Tracks user balances daily
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
```

Create `.env`:

```env
RPC_URL=https://data-seed-prebsc-1-s1.binance.org:8545
PRIVATE_KEY=YOUR_PRIVATE_KEY_HERE
CONTRACT_ADDRESS=0x048AC9bE9365053c5569daa9860cBD5671869188
```

---

## 🚀 Running the Server

```bash
node index.js
```

Expected terminal log:

```
🚀 MCP Agent is listening at http://localhost:3001
✅ Unibase memory saved: ✅ Memory & Knowledge saved successfully.
```

---

## ✅ Features Implemented

### 🔐 Minimal TX Limits

- ✅ Deposit: min `0.0000001` BNB
- ✅ Withdraw: min `0.0000001` BNB (from signer wallet only)

### 🧠 Smart Memory Logging

- ✅ All actions (deposit/withdraw) are saved via `agent_memory.py`
- ✅ Memory stored using `MultiMemory` with Unibase
- ✅ Knowledge stored using `ChromaKnowledgeBase`

### 📊 Wallet + Vault Tracking

- ✅ Daily snapshot saved in `history.json`
- ✅ Suggestions via `/analyze/:wallet` for user strategy

---

## ✅ API Endpoints

| Route              | Method | Description                          |
| ------------------ | ------ | ------------------------------------ |
| `/`                | GET    | Welcome message                      |
| `/ping`            | GET    | Check if server is alive             |
| `/memory/all`      | GET    | Get memory for all wallets           |
| `/memory/:wallet`  | GET    | Get memory for a specific wallet     |
| `/memory`          | POST   | Add/update memory manually           |
| `/wallet/:address` | GET    | Get BNB balance for an address       |
| `/vault/:wallet`   | GET    | Get vault balance                    |
| `/vault/deposit`   | POST   | Deposit BNB to the vault             |
| `/vault/withdraw`  | POST   | Withdraw BNB from the vault          |
| `/history/:wallet` | GET    | View daily balance logs              |
| `/share/:wallet`   | GET    | Share memory with BitAgent (AIP)     |
| `/analyze/:wallet` | GET    | Get AI-based strategy recommendation |

---

## ✅ Tested Scenario (Live)

```bash
# 🟢 Check agent is alive
curl http://localhost:3001/ping

# ✅ Deposit
curl -X POST http://localhost:3001/vault/deposit \
  -H "Content-Type: application/json" \
  -d '{"amount": "0.00001", "wallet": "0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3"}'

# ✅ Withdraw
curl -X POST http://localhost:3001/vault/withdraw \
  -H "Content-Type: application/json" \
  -d '{"amount": "0.000001"}'

# 🧠 View stored memory
curl http://localhost:3001/memory/0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3

# 📊 Analyze strategy
curl http://localhost:3001/analyze/0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3

# 🔁 Share knowledge with BitAgent
curl http://localhost:3001/share/0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3
```

---

## 🧩 Planned Additions

| Feature                 | Description                                         |
| ----------------------- | --------------------------------------------------- |
| NLP Agent               | Natural language queries like "Should I stake now?" |
| `/gas-price` endpoint   | Fetch live gas prices for BNBChain or zkSync        |
| AIP Auth Layer          | Agent authentication (Passkey/JWT)                  |
| Cross-chain Vault Logic | Support zkSync, Arbitrum, Base                      |
| ZK Storage Proofs       | Full Unibase DA integration for long-term memory    |

---

## 📄 License

MIT © 2025 – Samar Abdelhameed
