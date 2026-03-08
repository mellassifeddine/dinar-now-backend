const express = require('express');
const https = require('https');

const router = express.Router();

let cacheData = null;
let cacheTime = 0;

const CACHE_DURATION = 30000;

function fetchJson(url) {
  return new Promise((resolve, reject) => {
    https.get(url, { headers: { 'User-Agent': 'DinarNowBackend' } }, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          resolve(json);
        } catch (err) {
          reject(new Error('Invalid JSON from CoinGecko'));
        }
      });
    }).on('error', reject);
  });
}

router.get('/', async (req, res) => {

  const now = Date.now();

  if (cacheData && now - cacheTime < CACHE_DURATION) {
    return res.json(cacheData);
  }

  try {

    const url =
      "https://api.coingecko.com/api/v3/coins/markets" +
      "?vs_currency=usd" +
      "&order=market_cap_desc" +
      "&per_page=30" +
      "&page=1" +
      "&sparkline=false" +
      "&price_change_percentage=24h";

    const json = await fetchJson(url);

    const result = json.map((coin) => ({
      id: coin.id,
      symbol: coin.symbol.toUpperCase(),
      name: coin.name,
      image: coin.image,
      rank: coin.market_cap_rank,
      marketCap: coin.market_cap,
      price: coin.current_price,
      priceChangePercentage24h: coin.price_change_percentage_24h
    }));

    cacheData = result;
    cacheTime = now;

    res.json(result);

  } catch (error) {

    console.error(error);

    res.status(500).json({
      success: false,
      message: "CoinGecko request failed",
      error: error.message
    });

  }

});

module.exports = router;
