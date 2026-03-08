const express = require('express');
const https = require('https');

const router = express.Router();

let lastGoodCryptoResponse = [
  {
    symbol: 'BTC',
    name: 'Bitcoin',
    price: 0
  },
  {
    symbol: 'ETH',
    name: 'Ethereum',
    price: 0
  },
  {
    symbol: 'USDT',
    name: 'Tether',
    price: 0
  }
];

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
          if (response.statusCode && response.statusCode >= 400) {
            return reject(
              new Error(`External API returned HTTP ${response.statusCode}`)
            );
          }

          try {
            const json = JSON.parse(data);
            resolve(json);
          } catch (_) {
            reject(new Error('Failed to parse external API response.'));
          }
        });
      }
    );

    request.on('error', (error) => {
      reject(error);
    });

    request.setTimeout(10000, () => {
      request.destroy(new Error('External API timeout.'));
    });
  });
}

router.get('/', async (req, res) => {
  try {
    const url =
      'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,tether&vs_currencies=usd';

    const json = await fetchJson(url);

    if (
      !json ||
      !json.bitcoin ||
      !json.ethereum ||
      !json.tether ||
      typeof json.bitcoin.usd !== 'number' ||
      typeof json.ethereum.usd !== 'number' ||
      typeof json.tether.usd !== 'number'
    ) {
      throw new Error('Invalid crypto payload from external API.');
    }

    const result = [
      {
        symbol: 'BTC',
        name: 'Bitcoin',
        price: json.bitcoin.usd
      },
      {
        symbol: 'ETH',
        name: 'Ethereum',
        price: json.ethereum.usd
      },
      {
        symbol: 'USDT',
        name: 'Tether',
        price: json.tether.usd
      }
    ];

    lastGoodCryptoResponse = result;

    return res.json(result);
  } catch (error) {
    console.error('GET /crypto error:', error.message);

    const hasUsableCache = lastGoodCryptoResponse.some((item) => item.price > 0);

    if (hasUsableCache) {
      return res.json({
        source: 'cache',
        data: lastGoodCryptoResponse
      });
    }

    return res.status(502).json({
      success: false,
      message: 'Crypto provider unavailable.',
      error: error.message
    });
  }
});

module.exports = router;
