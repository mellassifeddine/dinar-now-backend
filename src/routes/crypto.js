const express = require('express');
const https = require('https');

const router = express.Router();

let cacheData = null;
let cacheTime = 0;

const CACHE_DURATION_MS = 30000;

function fetchJson(url) {
  return new Promise((resolve, reject) => {
    const request = https.get(
      url,
      {
        headers: {
          'User-Agent': 'DinarNowBackend/1.0',
          'Accept': 'application/json'
        }
      },
      (response) => {
        let data = '';

        response.on('data', (chunk) => {
          data += chunk;
        });

        response.on('end', () => {
          let json;

          try {
            json = JSON.parse(data);
          } catch (_) {
            return reject(new Error('Provider returned invalid JSON.'));
          }

          if (response.statusCode && response.statusCode >= 400) {
            const message =
              json?.error ||
              json?.status?.error_message ||
              `Provider returned HTTP ${response.statusCode}`;
            return reject(new Error(message));
          }

          resolve(json);
        });
      }
    );

    request.on('error', (error) => {
      reject(error);
    });

    request.setTimeout(10000, () => {
      request.destroy(new Error('Provider request timeout.'));
    });
  });
}

function buildLogoUrl(symbol) {
  const normalized = String(symbol || '')
    .toLowerCase()
    .replace(/[^a-z0-9]/g, '');

  if (!normalized) {
    return '';
  }

  return `https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/128/color/${normalized}.png`;
}

router.get('/', async (req, res) => {
  const page = Math.max(1, Number.parseInt(req.query.page, 10) || 1);
  const perPage = Math.min(
    50,
    Math.max(1, Number.parseInt(req.query.perPage, 10) || 10)
  );

  const now = Date.now();

  if (
    cacheData &&
    cacheData.page === page &&
    cacheData.perPage === perPage &&
    now - cacheTime < CACHE_DURATION_MS
  ) {
    return res.json(cacheData.items);
  }

  try {
    const url = 'https://api.coinpaprika.com/v1/tickers';

    const json = await fetchJson(url);

    if (!Array.isArray(json)) {
      return res.status(502).json({
        success: false,
        message: 'CoinPaprika returned an unexpected payload.'
      });
    }

    const start = (page - 1) * perPage;
    const end = start + perPage;

    const result = json
      .filter((item) => item && item.rank)
      .sort((a, b) => (a.rank || 999999) - (b.rank || 999999))
      .slice(start, end)
      .map((item) => ({
        id: item.id,
        symbol: String(item.symbol || '').toUpperCase(),
        name: item.name,
        image: buildLogoUrl(item.symbol),
        rank: item.rank || 0,
        marketCap: item.quotes?.USD?.market_cap ?? 0,
        price: item.quotes?.USD?.price ?? 0,
        priceChangePercentage24h:
          item.quotes?.USD?.percent_change_24h ?? null
      }));

    cacheData = {
      page,
      perPage,
      items: result
    };
    cacheTime = now;

    return res.json(result);
  } catch (error) {
    console.error('GET /crypto error:', error.message);

    if (cacheData?.items?.length) {
      return res.json(cacheData.items);
    }

    return res.status(502).json({
      success: false,
      message: 'Crypto provider request failed.',
      error: error.message
    });
  }
});

module.exports = router;
