# 🧠 MCP Agent – AI Logic for AION

This module powers the decentralized AI agent logic for **AION**, integrating **Membase** for sovereign memory and **BitAgent** for cross-platform intelligence.

It provides a local server that exposes RESTful endpoints for interacting with the memory layer, contract logic (AIONVault), and supporting the frontend/backend AI workflows.

---

## 📁 Folder Structure

This directory contains:

- `index.js`: Express-based Node.js server
- `agent_memory.py`: Python script to log memory into Unibase (Membase)
- `memory.json`: (Deprecated) fallback local memory
- `abi/`: ABI definitions for smart contracts (e.g., `AIONVault.json`)
- `.env`: Environment configuration (RPC, signer, contract address)

---

## 🛠 Setup & Installation

Make sure you have [Node.js](https://nodejs.org), [npm](https://www.npmjs.com/), and [Python 3.10+](https://www.python.org/) installed.

```bash
cd mcp_agent
npm install
pip install git+https://github.com/unibaseio/membase.git
```

Create a `.env` file with the following:

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

> Default port is `3001`. You’ll see:

```
🚀 MCP Agent is listening at http://localhost:3001
```

---

## ✅ Unibase Memory Integration (Membase)

This agent uses [Membase SDK](https://github.com/unibaseio/membase) to log all vault activity on-chain via sovereign memory.

### 📄 Script

`agent_memory.py` takes wallet interactions and logs them into Unibase:

```bash
python3 agent_memory.py 0xabc123 deposit auto_yield 0.01
```

> ✅ Memory saved to Unibase

### 🎯 Functionality

- `MultiMemory` used instead of `memory.json`
- `Message()` from Unibase SDK with `role="user"` or `"assistant"`
- Automatically called from `/vault/deposit` and `/vault/withdraw` handlers

---

## ✅ Available Endpoints

| Route              | Method | Description                       |
| ------------------ | ------ | --------------------------------- |
| `/`                | GET    | Welcome message                   |
| `/ping`            | GET    | Returns heartbeat                 |
| `/memory/all`      | GET    | All stored memory                 |
| `/memory/:wallet`  | GET    | Memory for a specific wallet      |
| `/analyze/:wallet` | GET    | Strategy analysis for wallet      |
| `/wallet/:address` | GET    | Get BNB balance for address       |
| `/vault/:wallet`   | GET    | Balance inside AIONVault contract |
| `/vault/deposit`   | POST   | Deposit BNB to the vault          |
| `/vault/withdraw`  | POST   | Withdraw BNB from the vault       |

---

## ✅ Sample Output (Live Test)

All these examples were tested live with real blockchain data and working smart contract interaction:

```bash
curl http://localhost:3001/memory/all
# [{"wallet":"0x1d58...ED3","last_action":"deposit","amount":0.005,"strategy":"auto_yield",...}]

curl http://localhost:3001/memory/0x1d58...ED3
# {...}

curl http://localhost:3001/analyze/0x1d58...ED3
# {"suggested_action":"Hold position and monitor"}

curl http://localhost:3001/wallet/0x1d58...ED3
# {"balanceBNB":"0.00577311"}

curl -X POST http://localhost:3001/vault/deposit \
  -H "Content-Type: application/json" \
  -d '{"amount": "0.001"}'
# {"message":"✅ Deposited 0.001 BNB", "txHash": "0xb820...cf"}

curl -X POST http://localhost:3001/vault/withdraw \
  -H "Content-Type: application/json" \
  -d '{"amount": "0.0005"}'
# {"message":"✅ Withdrawn 0.0005 BNB", "txHash": "0x9811...ff"}
```

---

## 🧩 Future Additions

- `GET /gas-price`: fetch gas data from BNBChain
- `POST /recommend`: AI response based on memory/metrics
- Authentication layer for agent/contract roles
- Agent-to-agent interoperability with BitAgent (via AIP SDK)
- Unibase DA proof and long-term task coordination

---

## 📄 License

MIT © 2025 – Samar Abdelhameed

```

```
