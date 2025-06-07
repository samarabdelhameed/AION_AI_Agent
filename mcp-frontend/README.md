# 🌐 AION Frontend – Immortal AI Agent UI

This is the **Frontend Interface** for the [AION Protocol](https://github.com/...) – an **on-chain Immortal AI Agent** built on **BNBChain**.

The interface allows users to interact with:

✅ **AI-Powered Strategy Recommendations**  
✅ **Vault Deposit / Withdraw (BNB)**  
✅ **AI Memory Timeline** → Visualize the agent's learning over time  
✅ **Live Smart Contract Integration** → AIONVault.sol + MCP Agent

Built with:

- ⚡️ **Astro**
- 💨 **TailwindCSS**
- 🥞 **Bun** → Ultra-fast bundler & runtime

---

## 🚀 Tech Stack

| Layer         | Technology                          |
| ------------- | ----------------------------------- |
| Frontend      | Astro 5.x                           |
| Styling       | TailwindCSS                         |
| Build Tool    | Bun                                 |
| UI Components | Vanilla + Custom                    |
| Agent API     | MCP Agent (Node.js + Python)        |
| Blockchain    | BNBChain Testnet (via BlastAPI RPC) |

---

## 🗺 Architecture Flowchart

```plaintext
┌────────────────────────────────┐
│        AION Frontend (Astro)   │
│  + AIRecommendation            │
│  + MemoryTimeline              │
│  + VaultActions (Deposit/Withdraw) │
│  + WalletInfo                  │
└────────────────────────────────┘
             │ REST API Calls
             ▼
┌────────────────────────────────┐
│          MCP Agent (Node.js)   │
│  + /analyze/:wallet            │
│  + /memory/:wallet             │
│  + /vault/:wallet              │
└────────────────────────────────┘
             │
             ▼
┌────────────────────────────────┐
│        BNBChain Smart Contract │
│        AIONVault.sol           │
└────────────────────────────────┘
```

---

## 📁 Folder Structure

```bash
frontend/
├── public/               # Static assets
├── src/
│   ├── components/       # Reusable UI components (WalletInfo, VaultBalance, AIRecommendation, MemoryTimeline, etc.)
│   ├── pages/            # Astro pages (routing based on file name)
│   ├── styles/           # Tailwind and global styles
│   └── utils/            # Utility functions (optional)
├── astro.config.mjs      # Astro config
├── package.json          # Project metadata and scripts
├── bun.lockb             # Bun lock file
├── tsconfig.json         # TypeScript config
└── README.md             # This file
```

---

## 🛠 Setup & Installation

### Prerequisites:

- Install [Bun](https://bun.sh/docs/installation)
- Clone this repo & navigate to `frontend/`

```bash
cd frontend
bun install
```

---

## 💻 Running the Dev Server

```bash
bun run dev
```

Then open your browser at: [http://localhost:4321](http://localhost:4321)

---

## ✨ UI Preview

Expected on `/dashboard`:

✅ Wallet Info (Connected to BNB Testnet)
✅ Vault Balance → Live smart contract read
✅ Vault Actions → Deposit / Withdraw → Triggers MCP Agent
✅ AIRecommendation → Live call to MCP `/analyze/:wallet`
✅ MemoryTimeline → Live call to MCP `/memory/:wallet`

---

## 🧪 Testing Flow (Manual Test)

1️⃣ Connect your wallet (MetaMask) → BNB Testnet
2️⃣ Perform **Deposit** → Check Vault Balance
3️⃣ Check **Memory Timeline** → Verify new Deposit entry
4️⃣ Perform **Withdraw** → Check Vault Balance
5️⃣ Check **Memory Timeline** → Verify Withdraw entry
6️⃣ Check **AIRecommendation** → See strategy suggestion
7️⃣ You can test `curl` on:

```bash
curl http://localhost:3001/memory/<wallet_address>
curl http://localhost:3001/analyze/<wallet_address>
```

---

## 📌 Notes

- Using **BlastAPI** RPC to improve BNBChain testnet stability and avoid free RPC limits.
- Memory Timeline is synced via MCP Agent → `memory.json` → Unibase → Frontend.
- This is a proof-of-concept UI → can be extended with **Charts / Visual Timeline / NLP Agent UI**.

---

## 🧩 Planned Features

✅ Wallet Connect (MetaMask)
✅ Memory Timeline (MCP)
✅ AIRecommendation (live)
✅ Deposit / Withdraw Flow
✅ Responsive Mobile UI

Next:

- [ ] Integrate **NLP Agent** frontend → "What should I do next?" button
- [ ] Add **Gas Cost Analytics** (via /gas-price MCP endpoint)
- [ ] Add full **Strategy Stats Panel** → APY, TVL, Fees Saved
- [ ] Add **Share Memory to BitAgent** button

---

## 📄 License

MIT © 2025 – Samar Abdelhameed

---

## Suggested Commit Message

```text
docs: update AION Frontend README with Architecture Flowchart, Testing Flow, and Features 🚀🧠
```

---

## 🚀 AION – AI-Powered DeFi, Autonomous, Immortal.

## 👁️ `Never stop learning. Never stop optimizing.`

---
