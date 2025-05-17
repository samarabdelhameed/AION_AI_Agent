const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const { ethers } = require('ethers');

const app = express();
const PORT = 3001;

app.use(bodyParser.json());

// BNBChain public RPC
const provider = new ethers.JsonRpcProvider('https://bsc-dataseed.binance.org/');

// Home route
app.get('/', (req, res) => {
  res.send('👋 Welcome to the MCP Agent!');
});

// Ping route
app.get('/ping', (req, res) => {
  res.send('pong from MCP Agent');
});

// Get all memory
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

// Get memory for specific wallet
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

// Add or update memory entry
app.post('/memory', (req, res) => {
  const newEntry = req.body;

  try {
    const data = fs.readFileSync('memory.json');
    const parsed = JSON.parse(data);

    const index = parsed.memory.findIndex(entry => entry.wallet === newEntry.wallet);

    if (index !== -1) {
      parsed.memory[index] = newEntry; // Update existing entry
    } else {
      parsed.memory.push(newEntry); // Add new entry
    }

    fs.writeFileSync('memory.json', JSON.stringify(parsed, null, 2));
    res.status(200).json({ message: 'Memory saved successfully.' });
  } catch (error) {
    console.error('❌ Error saving memory:', error.message);
    res.status(500).json({ error: 'Failed to update memory file.' });
  }
});

// Real-time wallet balance on BNBChain
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

app.listen(PORT, () => {
  console.log(`🚀 MCP Agent is listening at http://localhost:${PORT}`);
});
