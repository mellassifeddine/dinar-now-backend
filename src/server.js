require('dotenv').config();

const express = require('express');
const cors = require('cors');

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
    admin: `http://localhost:${PORT}/admin`
  });
});

app.use('/rates', ratesRoutes);
app.use('/admin', adminRoutes);

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
