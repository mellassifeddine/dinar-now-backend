const express = require('express');
const db = require('../db/database');
const { ADMIN_KEY } = require('../config/env');
const {
  broadcastParallelRatesUpdated,
} = require('../utils/ratesEvents');

const router = express.Router();

function requireAdmin(req, res, next) {
  const key =
    req.header('x-admin-key') ||
    req.body.adminKey ||
    req.query.adminKey;

  if (!key || key !== ADMIN_KEY) {
    return res.status(401).json({
      success: false,
      message: 'Unauthorized: invalid admin key.',
    });
  }

  next();
}

router.get('/rates', requireAdmin, (_req, res) => {
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
      message: 'Failed to load rates.',
    });
  }
});

router.post('/rates', requireAdmin, (req, res) => {
  try {
    const currency = String(req.body.currency || '').trim().toUpperCase();
    const name = String(req.body.name || '').trim();
    const flag = String(req.body.flag || '💱').trim();
    const buy = Number(req.body.buy || 0);
    const sell = Number(req.body.sell || 0);

    if (!currency || !name) {
      return res.status(400).json({
        success: false,
        message: 'currency and name are required.',
      });
    }

    const existing = db
      .prepare('SELECT currency FROM parallel_rates WHERE currency = ?')
      .get(currency);

    if (existing) {
      db.prepare(
        `
        UPDATE parallel_rates
        SET name = ?, flag = ?, buy = ?, sell = ?, updated_at = CURRENT_TIMESTAMP
        WHERE currency = ?
        `
      ).run(name, flag, buy, sell, currency);
    } else {
      db.prepare(
        `
        INSERT INTO parallel_rates (currency, name, flag, buy, sell)
        VALUES (?, ?, ?, ?, ?)
        `
      ).run(currency, name, flag, buy, sell);
    }

    const row = db
      .prepare(
        `
        SELECT currency, name, flag, buy, sell, updated_at
        FROM parallel_rates
        WHERE currency = ?
        `
      )
      .get(currency);

    broadcastParallelRatesUpdated({
      currency,
      buy,
      sell,
    });

    return res.json({
      success: true,
      row,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to save rate.',
    });
  }
});

module.exports = router;
