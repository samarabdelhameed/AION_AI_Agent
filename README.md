# AION – The Immortal AI DeFi Agent

## Overview
AION is an on-chain immortal AI agent on BNBChain that optimizes DeFi yield strategies using autonomous decision-making, decentralized memory via Membase, and cross-agent interoperability via BitAgent.

---

## Tech Stack
- **Blockchain:** BNBChain
- **AI Layer:** BitAgent + Membase + MCP
- **Frontend:** Next.js 15, TailwindCSS, shadcn/ui
- **Smart Contracts:** Solidity + Hardhat
- **Interoperability:** MCP & cross-agent messaging

---

## Folder Structure
```
AION_AI_Agent/
├── contracts/           # Solidity smart contracts
├── frontend/            # React-based frontend
│   ├── public/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── styles/
│   │   └── utils/
├── mcp_agent/           # AI agent scripts using MCP + BitAgent
├── docs/                # Flowcharts, diagrams, documentation
```

---

## Flowchart (MVP)
```mermaid
flowchart TD
    User -->|Connect Wallet| UI[AION Interface]
    UI --> AI[AI Agent (MCP + BitAgent)]
    AI -->|Fetch Memory| Membase
    AI -->|Yield Strategy| Contracts
    Contracts --> BNBChain
    AI -->|Share Insights| OtherAgents
```

---

## Setup
### Frontend
```bash
cd frontend
npm install
npm run dev
```

### Smart Contracts (using Foundry)
```bash
cd contracts
forge init
forge build
```

### MCP Agent
```bash
cd mcp_agent
npm install
node index.js
```

---

## Authors
Built by Samar Abdelhameed – AI + Blockchain Developer