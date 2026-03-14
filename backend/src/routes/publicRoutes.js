const express = require('express');
const db = require('../db/database');

const router = express.Router();

router.get('/health', (req, res) => {
  res.json({
    ok: true,
    service: 'dinar-now-backend',
  });
});

router.get('/api/parallel-rates', (req, res) => {
  const rows = db
    .prepare(`
      SELECT currency, name, flag, buy, sell, updated_at
      FROM parallel_rates
      ORDER BY rowid ASC
    `)
    .all();

  res.json(rows);
});

module.exports = router;
