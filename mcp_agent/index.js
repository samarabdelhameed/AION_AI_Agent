const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const { ethers } = require('ethers');
const { exec } = require('child_process');
require('dotenv').config();

const app = express();
const PORT = 3001;

app.use(bodyParser.json());

const { RPC_URL, PRIVATE_KEY, CONTRACT_ADDRESS } = process.env;
if (!RPC_URL || !PRIVATE_KEY || !CONTRACT_ADDRESS) {
  console.error('❌ .env file is missing RPC_URL, PRIVATE_KEY, or CONTRACT_ADDRESS');
  process.exit(1);
}

const provider = new ethers.JsonRpcProvider(RPC_URL);
const signer = new ethers.Wallet(PRIVATE_KEY, provider);
const contractABI = require('./abi/AIONVault.json').abi;
const vaultContract = new ethers.Contract(CONTRACT_ADDRESS, contractABI, signer);

// 🧠 Update History
function updateHistory(wallet, bnbBalance, vaultBalance) {
  const file = 'history.json';
  const today = new Date().toISOString().split('T')[0];
  let history = {};

  if (fs.existsSync(file)) {
    history = JSON.parse(fs.readFileSync(file));
  }

  if (!history[wallet]) {
    history[wallet] = [];
  }

  const alreadyExists = history[wallet].some(entry => entry.date === today);
  if (!alreadyExists) {
    history[wallet].push({
      date: today,
      bnb: parseFloat(bnbBalance),
      vault: parseFloat(vaultBalance)
    });
    fs.writeFileSync(file, JSON.stringify(history, null, 2));
  }
}

// 🏠 Basic Routes
app.get('/', (req, res) => res.send('👋 Welcome to the MCP Agent!'));
app.get('/ping', (req, res) => res.send('pong from MCP Agent'));

// 🧠 Memory (legacy JSON)
app.get('/memory/all', (req, res) => {
  try {
    const data = fs.readFileSync('memory.json');
    const parsed = JSON.parse(data);
    res.json(parsed.memory);
  } catch (error) {
    res.status(500).json({ error: 'Failed to read memory file.' });
  }
});

app.get('/memory/:wallet', (req, res) => {
  const wallet = req.params.wallet;
  try {
    const data = fs.readFileSync('memory.json');
    const parsed = JSON.parse(data);
    const userMemory = parsed.memory.find(entry => entry.wallet === wallet);
    userMemory ? res.json(userMemory) : res.status(404).json({ message: 'No memory found.' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to read memory file.' });
  }
});

app.post('/memory', (req, res) => {
  const newEntry = req.body;
  try {
    const data = fs.readFileSync('memory.json');
    const parsed = JSON.parse(data);
    const index = parsed.memory.findIndex(entry => entry.wallet === newEntry.wallet);
    if (index !== -1) parsed.memory[index] = newEntry;
    else parsed.memory.push(newEntry);
    fs.writeFileSync('memory.json', JSON.stringify(parsed, null, 2));
    res.status(200).json({ message: 'Memory saved.' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to update memory.' });
  }
});

// 💰 Wallet Info
app.get('/wallet/:address', async (req, res) => {
  try {
    const balance = await provider.getBalance(req.params.address);
    res.json({ wallet: req.params.address, balanceBNB: ethers.formatEther(balance) });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch wallet.' });
  }
});

// 📊 Strategy Analysis
app.get('/analyze/:wallet', (req, res) => {
  const wallet = req.params.wallet;
  try {
    const data = fs.readFileSync('memory.json');
    const parsed = JSON.parse(data);
    const userMemory = parsed.memory.find(entry => entry.wallet === wallet);
    if (!userMemory) return res.status(404).json({ message: 'No memory found.' });

    const suggestion = userMemory.amount > 800
      ? 'Consider rebalancing or staking'
      : 'Hold position and monitor';

    res.json({
      wallet: userMemory.wallet,
      strategy: userMemory.strategy,
      last_action: userMemory.last_action,
      suggested_action: suggestion,
      timestamp: userMemory.timestamp
    });
  } catch (error) {
    res.status(500).json({ error: 'Failed to analyze.' });
  }
});

// 🏦 Vault Balance
app.get('/vault/:wallet', async (req, res) => {
  try {
    const vaultBalance = await vaultContract.balanceOf(req.params.wallet);
    res.json({ wallet: req.params.wallet, vaultBalance: ethers.formatEther(vaultBalance) });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch vault balance.' });
  }
});

// 💸 Deposit BNB
app.post('/vault/deposit', async (req, res) => {
  const { amount, wallet } = req.body;
  try {
    const minAmount = 0.0000001;
    if (parseFloat(amount) < minAmount) {
      return res.status(400).json({ error: `Minimum deposit is ${minAmount} BNB.` });
    }

    const tx = await vaultContract.deposit({ value: ethers.parseEther(amount) });
    await tx.wait();

    const bnb = await provider.getBalance(wallet);
    const vault = await vaultContract.balanceOf(wallet);
    updateHistory(wallet, ethers.formatEther(bnb), ethers.formatEther(vault));

    exec(`python3 agent_memory.py ${wallet} deposit auto_yield ${amount}`, (err, stdout, stderr) => {
      if (err) {
        console.error("❌ Unibase memory logging failed:", stderr);
      } else {
        console.log("✅ Unibase memory saved:", stdout);
      }
    });

    res.json({ message: `✅ Deposited ${amount} BNB`, txHash: tx.hash });
  } catch (error) {
    console.error("❌ Deposit Error:", error);
    res.status(500).json({ error: 'Failed to deposit.' });
  }
});

// 🔓 Withdraw BNB
app.post('/vault/withdraw', async (req, res) => {
  let { amount, wallet } = req.body;
  if (!wallet) wallet = await signer.getAddress();
  if (!amount || parseFloat(amount) < 0.0000001) {
    amount = "0.0000001";
  }

  try {
    console.log("🔥 Withdraw initiated:", amount, "BNB from", wallet);

    const tx = await vaultContract.withdraw(ethers.parseEther(amount));
    await tx.wait();

    const bnb = await provider.getBalance(wallet);
    const vault = await vaultContract.balanceOf(wallet);
    updateHistory(wallet, ethers.formatEther(bnb), ethers.formatEther(vault));

    exec(`python3 agent_memory.py ${wallet} withdraw auto_yield ${amount}`, (err, stdout, stderr) => {
      if (err) {
        console.error("❌ Unibase memory logging failed:", stderr);
      } else {
        console.log("✅ Unibase memory saved:", stdout);
      }
    });

    res.json({ message: `✅ Withdrawn ${amount} BNB`, txHash: tx.hash });
  } catch (error) {
    console.error("❌ Withdraw Error:", error);
    res.status(500).json({ error: 'Failed to withdraw.' });
  }
});

// 🔄 Share Memory with BitAgent
app.get('/share/:wallet', (req, res) => {
  try {
    const data = fs.readFileSync('memory.json');
    const parsed = JSON.parse(data);
    const userMemory = parsed.memory.find(entry => entry.wallet === req.params.wallet);
    if (!userMemory) return res.status(404).json({ message: 'No memory found.' });
    res.json({ sharedWith: "BitAgent", wallet: req.params.wallet, data: userMemory });
  } catch (error) {
    res.status(500).json({ error: 'Failed to share memory.' });
  }
});

// 📈 History
app.get('/history/:wallet', (req, res) => {
  try {
    const data = fs.readFileSync('history.json');
    const parsed = JSON.parse(data);
    if (!parsed[req.params.wallet]) return res.status(404).json({ message: 'No history found.' });
    res.json(parsed[req.params.wallet]);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch history.' });
  }
});

// ✅ Start Server
app.listen(PORT, () => {
  console.log(`🚀 MCP Agent is listening at http://localhost:${PORT}`);
});
