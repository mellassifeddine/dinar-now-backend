require('dotenv').config();

const express = require('express');
const cors = require('cors');
const https = require('https');

const ratesRoutes = require('./routes/rates');
const adminRoutes = require('./routes/admin');

const app = express();
const PORT = Number(process.env.PORT || 3000);

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  return res.json({
    success: true,
    message: 'Dinar Now API is running.',
    admin: '/admin'
  });
});

app.use('/rates', ratesRoutes);
app.use('/admin', adminRoutes);

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});

/* keep render awake */

const SELF_URL =
  'https://dinar-now-backend.onrender.com';

setInterval(() => {

  https.get(SELF_URL, (res) => {
    console.log('Self ping:', res.statusCode);
  }).on('error', (err) => {
    console.log('Ping error:', err.message);
  });

}, 5 * 60 * 1000);
