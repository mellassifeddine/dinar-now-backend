const express = require('express');
const https = require('https');

const router = express.Router();

router.get('/', (req, res) => {

  const url =
  'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,tether&vs_currencies=usd';

  https.get(url, (apiRes) => {

    let data = '';

    apiRes.on('data', chunk => {
      data += chunk;
    });

    apiRes.on('end', () => {

      const json = JSON.parse(data);

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

    });

  }).on('error', err => {

    res.status(500).json({
      error: err.message
    });

  });

});

module.exports = router;
