# 🧠 MCP Agent – AI Logic for AION

This module powers the decentralized AI agent logic for **AION**, integrating **Membase** for sovereign memory and **BitAgent** for cross-platform intelligence.

It provides a local server that exposes RESTful endpoints for interacting with the memory layer, contract logic (`AIONVault`), and supporting frontend/backend AI workflows.

---

## 📁 Folder Structure

```bash
mcp_agent/
├── index.js                 # Node.js backend server
├── agent_memory.py         # Python script to log memory into Unibase
├── memory.json             # (Legacy) fallback local memory
├── history.json            # Tracks daily balances of wallets
├── abi/                    # Contract ABIs (e.g., AIONVault.json)
├── .env                    # Contains RPC_URL, PRIVATE_KEY, CONTRACT_ADDRESS
└── README.md               # This file
```

---

## 🛠 Setup & Installation

Make sure you have:

- [Node.js](https://nodejs.org)
- [npm](https://www.npmjs.com/)
- [Python 3.10+](https://www.python.org/)
- [Foundry](https://book.getfoundry.sh/) (for smart contract deployment)

```bash
cd mcp_agent
npm install
pip install git+https://github.com/unibaseio/membase.git
```

Create a `.env` file like this:

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

Expected output:

```
🚀 MCP Agent is listening at http://localhost:3001
```

---

## ✅ What’s New / Changes Implemented

### 🔒 Min Amount Thresholds

- Minimum deposit: `0.0000001` BNB
- Minimum withdraw: `0.0000001` BNB

This ensures gas efficiency and avoids accidental misuse of funds.

### 🔁 Simplified Withdraw

Withdraw now uses the wallet from your `.env` (`PRIVATE_KEY`), so no need to send the wallet in the payload.

### 💾 Memory & History Logging

- Agent actions (`deposit`, `withdraw`) are saved to `memory.json`
- Daily history tracked in `history.json`
- Agent also logs events to `Unibase` via `agent_memory.py`

---

## ✅ Available Endpoints

| Route              | Method | Description                          |
| ------------------ | ------ | ------------------------------------ |
| `/`                | GET    | Welcome message                      |
| `/ping`            | GET    | Check if server is alive             |
| `/memory/all`      | GET    | Returns memory for all wallets       |
| `/memory/:wallet`  | GET    | Returns memory for a specific wallet |
| `/memory`          | POST   | Add or update memory for a wallet    |
| `/wallet/:address` | GET    | Get BNB balance for wallet           |
| `/vault/:wallet`   | GET    | Get balance in vault for wallet      |
| `/vault/deposit`   | POST   | Deposit BNB to vault                 |
| `/vault/withdraw`  | POST   | Withdraw BNB from vault              |
| `/history/:wallet` | GET    | Get daily balance logs               |
| `/share/:wallet`   | GET    | Share memory with BitAgent           |
| `/analyze/:wallet` | GET    | Get suggestion for wallet strategy   |

---

## 🧪 Live Working Example

All commands tested and verified:

```bash
curl http://localhost:3001/ping
# pong from MCP Agent

curl -X POST http://localhost:3001/vault/deposit   -H "Content-Type: application/json"   -d '{"amount": "0.00001", "wallet": "0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3"}'
# ✅ Deposited 0.00001 BNB

curl -X POST http://localhost:3001/vault/withdraw   -H "Content-Type: application/json"   -d '{"amount": "0.000001"}'
# ✅ Withdrawn 0.000001 BNB

curl http://localhost:3001/memory/0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3
# shows latest deposit/withdraw strategy

curl http://localhost:3001/analyze/0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3
# Hold position and monitor

curl http://localhost:3001/share/0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3
# Data shared with BitAgent ✅
```

---

## 🧩 Planned Additions

- NLP Agent Integration (e.g. "should I stake today?")
- Gas price monitoring: `/gas-price`
- Agent-level access control (JWT / passkey)
- Native multi-chain vault support
- ZK login and per-user encrypted memory

---

## 📄 License

MIT © 2025 – Samar Abdelhameed
