const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const { ethers } = require('ethers');

const app = express();
const PORT = 3001;

app.use(bodyParser.json());

// BNBChain public RPC
const provider = new ethers.JsonRpcProvider('https://bsc-dataseed.binance.org/');

// ✅ عقد AIONVault
const contractABI = require('./abi/AIONVault.json').abi;
const CONTRACT_ADDRESS = '0x048AC9bE9365053c5569daa9860cBD5671869188'; // غيّريه لو العقد اتنشر بعنوان تاني
const vaultContract = new ethers.Contract(CONTRACT_ADDRESS, contractABI, provider);

// 🏠 Home
app.get('/', (req, res) => {
  res.send('👋 Welcome to the MCP Agent!');
});

// 🟢 Ping
app.get('/ping', (req, res) => {
  res.send('pong from MCP Agent');
});

// 📄 كل الذاكرة
app.get('/memory/all', (req, res) => {
  try {
    const data = fs.readFileSync('memory.json');
    const parsed = JSON.parse(data);
    res.json(parsed.memory);
  } catch (error) {
    console.error('❌ Error reading memory:', error.message);
    res.status(500).json({ error: 'Failed to read memory file.' });
  }
});

// 📄 ذاكرة محفظة معينة
app.get('/memory/:wallet', (req, res) => {
  const wallet = req.params.wallet;

  try {
    const data = fs.readFileSync('memory.json');
    const parsed = JSON.parse(data);
    const userMemory = parsed.memory.find(entry => entry.wallet === wallet);

    if (userMemory) {
      res.json(userMemory);
    } else {
      res.status(404).json({ message: 'No memory found for this wallet.' });
    }
  } catch (error) {
    console.error('❌ Error reading memory:', error.message);
    res.status(500).json({ error: 'Failed to read memory file.' });
  }
});

// 📝 إضافة/تحديث ذاكرة
app.post('/memory', (req, res) => {
  const newEntry = req.body;

  try {
    const data = fs.readFileSync('memory.json');
    const parsed = JSON.parse(data);

    const index = parsed.memory.findIndex(entry => entry.wallet === newEntry.wallet);

    if (index !== -1) {
      parsed.memory[index] = newEntry;
    } else {
      parsed.memory.push(newEntry);
    }

    fs.writeFileSync('memory.json', JSON.stringify(parsed, null, 2));
    res.status(200).json({ message: 'Memory saved successfully.' });
  } catch (error) {
    console.error('❌ Error saving memory:', error.message);
    res.status(500).json({ error: 'Failed to update memory file.' });
  }
});

// 💰 رصيد المحفظة على BNBChain
app.get('/wallet/:address', async (req, res) => {
  const address = req.params.address;

  try {
    const balance = await provider.getBalance(address);
    const bnb = ethers.formatEther(balance);

    res.json({
      wallet: address,
      balanceBNB: bnb
    });
  } catch (error) {
    console.error('❌ Error fetching wallet data:', error.message);
    res.status(500).json({ error: 'Failed to fetch wallet data' });
  }
});

// 📊 تحليل الاستراتيجية
app.get('/analyze/:wallet', (req, res) => {
  const wallet = req.params.wallet;

  try {
    const data = fs.readFileSync('memory.json');
    const parsed = JSON.parse(data);
    const userMemory = parsed.memory.find(entry => entry.wallet === wallet);

    if (!userMemory) {
      return res.status(404).json({ message: 'No memory found for this wallet.' });
    }

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
    console.error('❌ Error analyzing memory:', error.message);
    res.status(500).json({ error: 'Failed to analyze memory.' });
  }
});

// 🔐 الاتصال بـ Vault Contract لعرض الرصيد من العقد
app.get('/vault/:wallet', async (req, res) => {
  const wallet = req.params.wallet;

  try {
    const vaultBalance = await vaultContract.balanceOf(wallet);
    res.json({
      wallet,
      vaultBalance: ethers.formatEther(vaultBalance)
    });
  } catch (error) {
    console.error('❌ Error reading vault contract:', error.message);
    res.status(500).json({ error: 'Failed to fetch vault balance.' });
  }
});

app.listen(PORT, () => {
  console.log(`🚀 MCP Agent is listening at http://localhost:${PORT}`);
});
