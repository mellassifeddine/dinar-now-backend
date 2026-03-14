const express = require('express');
const db = require('../db/database');
const {
  addListener,
  removeListener,
} = require('../utils/ratesEvents');

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

router.get('/parallel-rates/stream', (req, res) => {
  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache, no-transform',
    Connection: 'keep-alive',
    'X-Accel-Buffering': 'no',
    'Access-Control-Allow-Origin': '*',
  });

  res.write(': connected\n\n');

  addListener(res);

  const heartbeat = setInterval(() => {
    try {
      res.write(': heartbeat\n\n');
    } catch (_) {
      clearInterval(heartbeat);
      removeListener(res);
    }
  }, 25000);

  req.on('close', () => {
    clearInterval(heartbeat);
    removeListener(res);
    res.end();
  });
});

module.exports = router;
