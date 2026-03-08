const express = require('express');
const https = require('https');

const router = express.Router();

router.get('/', (req, res) => {

  const url =
    'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,tether&vs_currencies=usd';

  const request = https.get(url, (apiRes) => {

    let data = '';

    apiRes.on('data', chunk => {
      data += chunk;
    });

    apiRes.on('end', () => {

      try {

        const json = JSON.parse(data);

        if (!json.bitcoin || !json.ethereum || !json.tether) {
          return res.status(500).json({
            error: 'Invalid response from CoinGecko'
          });
        }

        res.json([
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
        ]);

      } catch (err) {

        res.status(500).json({
          error: 'Failed to parse API response'
        });

      }

    });

  });

  request.on('error', err => {

    res.status(500).json({
      error: 'External API request failed'
    });

  });

  request.setTimeout(8000, () => {
    request.destroy();
    res.status(504).json({
      error: 'Crypto API timeout'
    });
  });

});

module.exports = router;
