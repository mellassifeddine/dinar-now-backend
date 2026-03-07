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
  try {
    const rows = db.prepare(`
      SELECT currency, buy, sell
      FROM rates
      ORDER BY currency ASC
    `).all();

    return res.json(rows);
  } catch (error) {
    console.error('GET /rates/parallel error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch parallel rates.'
    });
  }
});

router.post('/update', (req, res) => {
  try {
    const adminKey = getAdminKeyFromRequest(req);
    const expectedKey = process.env.ADMIN_KEY;

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

    if (!currency || typeof buy !== 'number' || typeof sell !== 'number') {
      return res.status(400).json({
        success: false,
        message: 'currency, buy and sell are required and must be valid.'
      });
    }

    const result = db.prepare(`
      UPDATE rates
      SET buy = ?, sell = ?
      WHERE currency = ?
    `).run(buy, sell, currency);

    if (result.changes === 0) {
      return res.status(404).json({
        success: false,
        message: `Currency ${currency} not found.`
      });
    }

    return res.json({
      success: true,
      message: `Rate for ${currency} updated successfully.`
    });
  } catch (error) {
    console.error('POST /rates/update error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to update rate.'
    });
  }
});

module.exports = router;
