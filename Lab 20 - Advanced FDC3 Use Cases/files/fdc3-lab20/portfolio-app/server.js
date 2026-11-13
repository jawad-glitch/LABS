const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

const positions = [
  { ticker: 'AAPL', name: 'Apple Inc.', quantity: 5000, avgPrice: 150.25, currentPrice: 175.30, isin: 'US0378331005' },
  { ticker: 'MSFT', name: 'Microsoft Corp.', quantity: 3000, avgPrice: 280.50, currentPrice: 310.75, isin: 'US5949181045' },
  { ticker: 'JNJ', name: 'Johnson & Johnson', quantity: 4000, avgPrice: 165.80, currentPrice: 172.45, isin: 'US4781601046' },
  { ticker: 'KO', name: 'Coca-Cola Co.', quantity: 8000, avgPrice: 55.20, currentPrice: 58.75, isin: 'US1912161007' }
];

app.get('/api/positions', (req, res) => res.json(positions));
app.get('/health', (req, res) => res.json({ status: 'ok', service: 'Portfolio App' }));

app.listen(3001, '0.0.0.0', () => {
  console.log('Portfolio App listening on port 3001');
});
