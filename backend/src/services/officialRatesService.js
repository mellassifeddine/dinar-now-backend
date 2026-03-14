const https = require('https');

const META = {
  EUR: { name: 'Euro', flag: '🇪🇺' },
  USD: { name: 'U.S. Dollar', flag: '🇺🇸' },
  GBP: { name: 'British Pound', flag: '🇬🇧' },
  CAD: { name: 'Canadian Dollar', flag: '🇨🇦' },
  CHF: { name: 'Swiss Franc', flag: '🇨🇭' },
  CNY: { name: 'Chinese Yuan', flag: '🇨🇳' },
  SAR: { name: 'Saudi Riyal', flag: '🇸🇦' },
  AED: { name: 'UAE Dirham', flag: '🇦🇪' },
  QAR: { name: 'Qatar Riyal', flag: '🇶🇦' },
  TND: { name: 'Tunisian Dinar', flag: '🇹🇳' },
  MAD: { name: 'Moroccan Dirham', flag: '🇲🇦' },
  EGP: { name: 'Egyptian Pound', flag: '🇪🇬' },
};

const agent = new https.Agent({
  rejectUnauthorized: false,
});

function fetchJson(url) {
  return new Promise((resolve, reject) => {
    https
      .get(
        url,
        {
          agent,
          headers: {
            'User-Agent': 'DinarNow/1.0',
            Accept: 'application/json,text/plain,*/*',
          },
        },
        (res) => {
          const statusCode = res.statusCode || 0;

          if (statusCode < 200 || statusCode >= 300) {
            res.resume();
            reject(new Error(`HTTP ${statusCode}`));
            return;
          }

          let data = '';
          res.setEncoding('utf8');

          res.on('data', (chunk) => {
            data += chunk;
          });

          res.on('end', () => {
            try {
              resolve(JSON.parse(data));
            } catch (err) {
              reject(err);
            }
          });
        }
      )
      .on('error', reject);
  });
}

function buildInverse(rate, symbol) {
  if (!rate || rate <= 0) return '';
  const inv = 1 / rate;
  return `1 DZD = ${inv.toFixed(4)} ${symbol}`;
}

async function getOfficialRates() {
  const url = 'https://www.bank-of-algeria.dz/wp-json/wp/v2/taux-change';
  const data = await fetchJson(url);

  if (!Array.isArray(data)) {
    throw new Error('Invalid official API response');
  }

  const rows = [];

  for (const item of data) {
    const symbol = String(item.currency || '').trim().toUpperCase();

    if (!META[symbol]) continue;

    const value = Number(item.rate);

    if (!Number.isFinite(value) || value <= 0) continue;

    rows.push({
      currency: symbol,
      name: META[symbol].name,
      flag: META[symbol].flag,
      buy: 0,
      sell: value,
      inverseText: buildInverse(value, symbol),
      updated_at: new Date().toISOString(),
    });
  }

  if (!rows.length) {
    throw new Error('No official rates returned');
  }

  return rows;
}

module.exports = {
  getOfficialRates,
};
