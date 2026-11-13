const express = require('express');
const cors = require('cors');
const path = require('path');
const { randomUUID } = require('crypto');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

app.post('/api/orders', (req, res) => {
  const { ticker, side, quantity, price } = req.body || {};
  const validSide = ['BUY', 'SELL'].includes(String(side).toUpperCase());

  if (
    typeof ticker !== 'string' || !ticker.trim() ||
    !validSide ||
    !Number.isFinite(Number(quantity)) || Number(quantity) <= 0 ||
    !Number.isFinite(Number(price)) || Number(price) <= 0
  ) {
    return res.status(400).json({
      error: 'Provide ticker, BUY/SELL side, positive quantity and positive price'
    });
  }

  const order = {
    orderId: randomUUID(),
    ticker: ticker.trim().toUpperCase(),
    side: String(side).toUpperCase(),
    quantity: Number(quantity),
    price: Number(price),
    status: 'ACCEPTED',
    createdAt: new Date().toISOString()
  };

  console.log('SIMULATED ORDER:', JSON.stringify(order));
  res.status(201).json(order);
});

app.get('/health', (req, res) => res.json({ status: 'ok', service: 'Trading App' }));

app.listen(3002, '0.0.0.0', () => {
  console.log('Trading App listening on port 3002');
});
