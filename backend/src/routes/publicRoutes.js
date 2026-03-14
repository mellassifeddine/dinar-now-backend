const express = require('express');
const db = require('../db/database');

const router = express.Router();

router.get('/parallel-rates', (_req, res) => {
  try {
    const rows = db
      .prepare(
        `
        SELECT currency, name, flag, buy, sell, updated_at
        FROM parallel_rates
        ORDER BY rowid ASC
        `
      )
      .all();

    return res.json(rows);
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to load parallel rates.',
    });
  }
});

module.exports = router;
