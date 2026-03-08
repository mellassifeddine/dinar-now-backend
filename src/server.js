require('dotenv').config();

const express = require('express');
const cors = require('cors');

const ratesRoutes = require('./routes/rates');
const adminRoutes = require('./routes/admin');
const cryptoRoutes = require('./routes/crypto');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Dinar Now API running'
  });
});

app.use('/rates', ratesRoutes);
app.use('/admin', adminRoutes);
app.use('/crypto', cryptoRoutes);

app.listen(PORT, '0.0.0.0', () => {
  console.log('Server running on port', PORT);
});
