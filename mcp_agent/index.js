const express = require('express');
const app = express();
const PORT = 3001;

// Home route
app.get('/', (req, res) => {
  res.send('👋 Welcome to the MCP Agent!');
});

// Ping route
app.get('/ping', (req, res) => {
  res.send('pong from MCP Agent');
});

app.listen(PORT, () => {
  console.log(`🚀 MCP Agent is listening at http://localhost:${PORT}`);
});
