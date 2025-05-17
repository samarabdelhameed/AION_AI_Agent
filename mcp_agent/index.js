const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const { ethers } = require('ethers');
require('dotenv').config();

const app = express();
const PORT = 3001;

app.use(bodyParser.json());

// ✅ تحقق من وجود متغيرات البيئة الأساسية
const { RPC_URL, PRIVATE_KEY, CONTRACT_ADDRESS } = process.env;
if (!RPC_URL || !PRIVATE_KEY || !CONTRACT_ADDRESS) {
  console.error('❌ .env file is missing RPC_URL, PRIVATE_KEY, or CONTRACT_ADDRESS');
  process.exit(1);
}

// ✅ إعداد مزود RPC والموقّع (Signer)
const provider = new ethers.JsonRpcProvider(RPC_URL);
const signer = new ethers.Wallet(PRIVATE_KEY, provider);

// ✅ إعداد العقد الذكي
const contractABI = require('./abi/AIONVault.json').abi;
const vaultContract = new ethers.Contract(CONTRACT_ADDRESS, contractABI, signer);

// 🏠 صفحة رئيسية
app.get('/', (req, res) => {
  res.send('👋 Welcome to the MCP Agent!');
});

// 🔁 اختبار اتصال
app.get('/ping', (req, res) => {
  res.send('pong from MCP Agent');
});

// 📄 جميع بيانات الذاكرة
app.get('/memory/all', (req, res) => {
  try {
    const data = fs.readFileSync('memory.json');
    const parsed = JSON.parse(data);
    res.json(parsed.memory);
  } catch (error) {
    console.error('❌ Failed to read memory file:', error.message);
    res.status(500).json({ error: 'Failed to read memory file.' });
  }
});

// 📄 بيانات مستخدم واحد
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
    console.error('❌ Failed to read memory:', error.message);
    res.status(500).json({ error: 'Failed to read memory file.' });
  }
});

// ✍️ إضافة أو تعديل بيانات مستخدم
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
    console.error('❌ Failed to save memory:', error.message);
    res.status(500).json({ error: 'Failed to update memory file.' });
  }
});

// 💰 رصيد المحفظة BNB
app.get('/wallet/:address', async (req, res) => {
  const address = req.params.address;

  try {
    const balance = await provider.getBalance(address);
    const bnb = ethers.formatEther(balance);
    res.json({ wallet: address, balanceBNB: bnb });
  } catch (error) {
    console.error('❌ Failed to fetch wallet balance:', error.message);
    res.status(500).json({ error: 'Failed to fetch wallet data' });
  }
});

// 📊 تحليل بيانات المستخدم
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
    console.error('❌ Failed to analyze memory:', error.message);
    res.status(500).json({ error: 'Failed to analyze memory.' });
  }
});

// 🏦 عرض الرصيد داخل Vault
app.get('/vault/:wallet', async (req, res) => {
  const wallet = req.params.wallet;

  try {
    const vaultBalance = await vaultContract.balanceOf(wallet);
    res.json({
      wallet,
      vaultBalance: ethers.formatEther(vaultBalance)
    });
  } catch (error) {
    console.error('❌ Failed to fetch vault balance:', error.message);
    res.status(500).json({ error: 'Failed to fetch vault balance.' });
  }
});

// 💸 إيداع BNB
app.post('/vault/deposit', async (req, res) => {
  const { amount } = req.body;
  try {
    const tx = await vaultContract.deposit({ value: ethers.parseEther(amount) });
    await tx.wait();
    res.json({ message: `✅ Deposited ${amount} BNB`, txHash: tx.hash });
  } catch (error) {
    console.error('❌ Deposit failed:', error.message);
    res.status(500).json({ error: 'Failed to deposit.' });
  }
});

// 🔓 سحب BNB
app.post('/vault/withdraw', async (req, res) => {
  const { amount } = req.body;
  try {
    const tx = await vaultContract.withdraw(ethers.parseEther(amount));
    await tx.wait();
    res.json({ message: `✅ Withdrawn ${amount} BNB`, txHash: tx.hash });
  } catch (error) {
    console.error('❌ Withdrawal failed:', error.message);
    res.status(500).json({ error: 'Failed to withdraw.' });
  }
});

// 🚀 تشغيل السيرفر
app.listen(PORT, () => {
  console.log(`🚀 MCP Agent is listening at http://localhost:${PORT}`);
});
