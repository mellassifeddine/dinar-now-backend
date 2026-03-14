const express = require('express');
const path = require('path');

const publicRoutes = require('./routes/publicRoutes');
const adminRoutes = require('./routes/adminRoutes');
const { PORT } = require('./config/env');

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/admin', express.static(path.join(__dirname, 'public/admin')));

app.get('/', (_req, res) => {
  res.redirect('/admin');
});

app.get('/health', (_req, res) => {
  res.json({
    ok: true,
    service: 'dinar-now-backend',
  });
});

app.use('/api', publicRoutes);
app.use('/api/admin', adminRoutes);

try {
  const { ensureSeedRates } = require('./db/seed');
  ensureSeedRates();
  console.log('Seed sync completed at startup.');
} catch (err) {
  console.error('Seed sync skipped due to error:', err.message);
}

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Dinar Now backend running on port ${PORT}`);
});
