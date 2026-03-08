const express = require('express');
const https = require('https');

const router = express.Router();

function fetchCoinGeckoJson(url, demoApiKey) {
  return new Promise((resolve, reject) => {
    const request = https.get(
      url,
      {
        headers: {
          'User-Agent': 'DinarNowBackend/1.0',
          'Accept': 'application/json',
          'x-cg-demo-api-key': demoApiKey,
        },
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
            return reject(
              new Error(`CoinGecko returned invalid JSON: ${data}`)
            );
          }

          if (response.statusCode && response.statusCode >= 400) {
            const message =
              json?.error ||
              json?.status?.error_message ||
              `CoinGecko returned HTTP ${response.statusCode}`;

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
      request.destroy(new Error('CoinGecko request timeout.'));
    });
  });
}

router.get('/', async (req, res) => {
  const rawKey = process.env.COINGECKO_DEMO_API_KEY;
  const demoApiKey = String(rawKey || '').trim();

  if (!demoApiKey) {
    return res.status(500).json({
      success: false,
      message: 'COINGECKO_DEMO_API_KEY is missing on the server.',
    });
  }

  const page = Math.max(1, Number.parseInt(req.query.page, 10) || 1);
  const perPage = Math.min(
    50,
    Math.max(1, Number.parseInt(req.query.perPage, 10) || 10)
  );

  try {
    const pingUrl =
      `https://api.coingecko.com/api/v3/ping` +
      `?x_cg_demo_api_key=${encodeURIComponent(demoApiKey)}`;

    await fetchCoinGeckoJson(pingUrl, demoApiKey);

    const marketsUrl =
      `https://api.coingecko.com/api/v3/coins/markets` +
      `?vs_currency=usd` +
      `&order=market_cap_desc` +
      `&per_page=${perPage}` +
      `&page=${page}` +
      `&sparkline=false` +
      `&price_change_percentage=24h` +
      `&locale=en` +
      `&x_cg_demo_api_key=${encodeURIComponent(demoApiKey)}`;

    const json = await fetchCoinGeckoJson(marketsUrl, demoApiKey);

    if (!Array.isArray(json)) {
      return res.status(502).json({
        success: false,
        message: 'CoinGecko returned an unexpected payload.',
        raw: json,
      });
    }

    const result = json.map((item) => ({
      id: item.id,
      symbol: String(item.symbol || '').toUpperCase(),
      name: item.name,
      image: item.image,
      rank: item.market_cap_rank,
      marketCap: item.market_cap,
      price: item.current_price,
      priceChangePercentage24h:
        item.price_change_percentage_24h_in_currency,
    }));

    return res.json(result);
  } catch (error) {
    console.error('GET /crypto error:', error.message);

    return res.status(502).json({
      success: false,
      message: 'CoinGecko request failed.',
      error: error.message,
      keyPresent: true,
      keyLength: demoApiKey.length,
    });
  }
});

module.exports = router;
