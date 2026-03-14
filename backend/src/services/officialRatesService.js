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

function fetchText(url) {
  return new Promise((resolve, reject) => {
    https
      .get(
        url,
        {
          agent,
          headers: {
            'User-Agent': 'DinarNow/1.0',
            Accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
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
            resolve(data);
          });
        }
      )
      .on('error', reject);
  });
}

function buildInverse(rate, symbol) {
  if (!rate || rate <= 0) return '';
  const inv = 1 / rate;
  const digits = inv >= 1 ? 4 : 6;
  return `1 DZD = ${inv.toFixed(digits)} ${symbol}`;
}

async function getOfficialRates() {
  const html = await fetchText('https://www.bank-of-algeria.dz/');

  const rows = [];

  for (const symbol of Object.keys(META)) {
    const regex = new RegExp(`${symbol}[^0-9]{0,10}([0-9]+[.,][0-9]+)`, 'i');
    const match = html.match(regex);

    if (!match) continue;

    const value = parseFloat(match[1].replace(',', '.'));

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
    throw new Error('No official rates parsed');
  }

  return rows;
}

module.exports = {
  getOfficialRates,
};
