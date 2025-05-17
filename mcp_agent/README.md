### `mcp_agent/README.md`

````markdown
# 🧠 MCP Agent – AI Logic for AION

This module is responsible for running the decentralized AI agent logic for **AION**, integrating **Membase** for sovereign memory and **BitAgent** for cross-platform intelligence.

It provides a local server that exposes RESTful endpoints for interacting with the AI memory layer, fetching strategies, and supporting the frontend.

---

## 📁 Folder Purpose

This directory contains:

- Express-based API server
- Route handlers for core AI functions (e.g., memory, strategy, health check)
- Integration entrypoint for the MCP (Model Context Protocol)

---

## 🛠 Setup & Installation

Make sure you have [Node.js](https://nodejs.org) and [npm](https://www.npmjs.com/) installed.

```bash
cd mcp_agent
npm install
```
````

---

## 🚀 Running the Server

Start the server using:

```bash
node index.js
```

> You can change the port from inside `index.js` if needed.

---

## ✅ Available Endpoints

| Route           | Method | Description                                      |
| --------------- | ------ | ------------------------------------------------ |
| `/`             | GET    | Welcome message                                  |
| `/ping`         | GET    | Returns simple heartbeat `"pong from MCP Agent"` |
| _(Coming soon)_ |        | `GET /gas-price`, `POST /recommend`, etc.        |

---

## 🖼 Example Output

- Visiting `http://localhost:3001/` in the browser:

  ```
  👋 Welcome to the MCP Agent!
  ```

- Visiting `http://localhost:3001/ping`:

  ```
  pong from MCP Agent
  ```

---

## 🔧 Next Steps (Planned Features)

- `GET /gas-price`: fetch gas info from BNBChain
- `POST /recommend`: AI decision based on yield data + memory
- `GET /memory/:userId`: fetch AI-stored data per wallet

---

## 🧪 Testing (Manual)

After launching the server:

```bash
curl http://localhost:3001
# Output: 👋 Welcome to the MCP Agent!

curl http://localhost:3001/ping
# Output: pong from MCP Agent
```

---

## 📄 License

MIT © 2025

```

```
