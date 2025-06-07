### `frontend/README.md`

````markdown
# 🌐 AION Frontend – Immortal AI Agent UI

This is the frontend interface for the **AION** project – an on-chain, immortal AI agent on **BNBChain**. It provides users with an intuitive and minimal interface to interact with the AI-powered agent, enabling one-click DeFi automation and insight retrieval.

Built using **Astro**, styled with **TailwindCSS**, and bundled with **Bun** for speed and efficiency.

---

## 🚀 Tech Stack

- **Framework:** Astro 5.0
- **Build Tool:** Bun
- **Styling:** TailwindCSS
- **UI Kit:** shadcn/ui (optional)
- **Routing:** Astro file-based routing system

---

## 📁 Folder Structure

```bash
frontend/
├── public/               # Static assets
├── src/
│   ├── components/       # Reusable UI components
│   ├── pages/            # Astro pages (routing based on file name)
│   ├── styles/           # Tailwind and global styles
│   └── utils/            # Utility functions (optional)
├── astro.config.mjs      # Astro config
├── package.json          # Project metadata and scripts
├── bun.lock              # Bun lock file
├── tsconfig.json         # TypeScript config
└── README.md             # This file
```
````

---

## 🛠 Setup & Installation

Make sure you have [Bun](https://bun.sh/docs/installation) installed.

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

## 📸 Preview

You’ll see a welcome screen from Astro with a message:

```
To get started, open the src/pages directory in your project.
```

If you have customized the homepage (like in AION), you'll see:

```
👁 AION
Immortal AI Agent on BNBChain
[Launch Agent]
```

---

## 🧪 Testing (Manual)

After running the dev server:

- Visit `/` – Homepage UI
- Click "Launch Agent" – connect to AI logic (coming soon)
- Integrate with `/api/ping` from `mcp_agent` (planned)

- Memory Timeline reads live events (Deposit / Withdraw) from Vault Smart Contract on BNB Testnet.
- Using BlastAPI RPC for high reliability and better limits.

---

## 🧩 Planned Features

- Wallet connection (MetaMask or WalletConnect)
- Real-time MCP agent integration
- Strategy visualization (TVL, APY, gas fee stats)
- Custom strategy builder UI
- Dark mode + responsive layout

---

## 📄 License

MIT © 2025

```

---
```
