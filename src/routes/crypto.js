const express = require('express');
const https = require('https');

const router = express.Router();

function fetchJson(url) {
  return new Promise((resolve, reject) => {
    https
      .get(url, { headers: { 'User-Agent': 'DinarNowBackend' } }, (res) => {
        let data = '';

        res.on('data', (chunk) => {
          data += chunk;
        });

        res.on('end', () => {
          try {
            resolve(JSON.parse(data));
          } catch (e) {
            reject(new Error('Invalid JSON from CoinGecko'));
          }
        });
      })
      .on('error', reject);
  });
}

router.get('/', async (req, res) => {
  const apiKey = process.env.COINGECKO_DEMO_API_KEY;

  if (!apiKey) {
    return res.status(500).json({
      success: false,
      message: 'COINGECKO_DEMO_API_KEY missing'
    });
  }

  const page = Number(req.query.page || 1);
  const perPage = Number(req.query.perPage || 10);

  try {
    const url =
      `https://api.coingecko.com/api/v3/coins/markets` +
      `?vs_currency=usd` +
      `&order=market_cap_desc` +
      `&per_page=${perPage}` +
      `&page=${page}` +
      `&sparkline=false` +
      `&price_change_percentage=24h` +
      `&x_cg_demo_api_key=${apiKey}`;

    const json = await fetchJson(url);

    const result = json.map((coin) => ({
      id: coin.id,
      symbol: coin.symbol.toUpperCase(),
      name: coin.name,
      image: coin.image,
      rank: coin.market_cap_rank,
      marketCap: coin.market_cap,
      price: coin.current_price,
      priceChangePercentage24h:
        coin.price_change_percentage_24h_in_currency
    }));

    res.json(result);
  } catch (err) {
    res.status(502).json({
      success: false,
      message: 'CoinGecko request failed.',
      error: err.message
    });
  }
});

module.exports = router;
