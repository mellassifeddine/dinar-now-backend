const express = require('express');
const db = require('../db/database');

const router = express.Router();

function getAdminKeyFromRequest(req) {
  const headerKey = req.headers['x-admin-key'];
  const bodyKey = req.body?.adminKey;

  if (typeof headerKey === 'string' && headerKey.trim() !== '') {
    return headerKey.trim();
  }

  if (typeof bodyKey === 'string' && bodyKey.trim() !== '') {
    return bodyKey.trim();
  }

  return null;
}

router.get('/parallel', (req, res) => {
  db.all(
    `
      SELECT currency, buy, sell
      FROM rates
      ORDER BY currency ASC
    `,
    [],
    (err, rows) => {
      if (err) {
        console.error('GET /rates/parallel error:', err);
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch parallel rates.'
        });
      }

      return res.json(rows);
    }
  );
});

router.post('/update', (req, res) => {
  const expectedKey = process.env.ADMIN_KEY;
  const adminKey = getAdminKeyFromRequest(req);

  if (!expectedKey) {
    return res.status(500).json({
      success: false,
      message: 'ADMIN_KEY is missing on the server.'
    });
  }

  if (!adminKey || adminKey !== expectedKey) {
    return res.status(401).json({
      success: false,
      message: 'Unauthorized. Invalid admin key.'
    });
  }

  const { currency, buy, sell } = req.body;

  if (
    !currency ||
    typeof buy !== 'number' ||
    Number.isNaN(buy) ||
    typeof sell !== 'number' ||
    Number.isNaN(sell)
  ) {
    return res.status(400).json({
      success: false,
      message: 'currency, buy and sell are required and must be valid.'
    });
  }

  db.run(
    `
      UPDATE rates
      SET buy = ?, sell = ?
      WHERE currency = ?
    `,
    [buy, sell, currency],
    function (err) {
      if (err) {
        console.error('POST /rates/update error:', err);
        return res.status(500).json({
          success: false,
          message: 'Failed to update rate.'
        });
      }

      if (this.changes === 0) {
        return res.status(404).json({
          success: false,
          message: `Currency ${currency} not found.`
        });
      }

      return res.json({
        success: true,
        message: `Rate for ${currency} updated successfully.`
      });
    }
  );
});

module.exports = router;
