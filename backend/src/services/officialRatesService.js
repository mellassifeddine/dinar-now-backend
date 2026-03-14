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
  return `1 DZD = ${inv.toFixed(4)} ${symbol}`;
}

function stripHtml(html) {
  return html
    .replace(/<script[\s\S]*?<\/script>/gi, ' ')
    .replace(/<style[\s\S]*?<\/style>/gi, ' ')
    .replace(/<[^>]*>/g, ' ')
    .replace(/&nbsp;/gi, ' ')
    .replace(/&#160;/gi, ' ')
    .replace(/&AMP;/gi, '&')
    .replace(/\s+/g, ' ')
    .trim()
    .toUpperCase();
}

async function getOfficialRates() {
  const html = await fetchText(
    'https://www.bank-of-algeria.dz/taux-de-change-journalier/'
  );

  const text = stripHtml(html);
  const rows = [];

  for (const symbol of Object.keys(META)) {
    const patterns = [
      new RegExp(`\\b${symbol}\\b[^0-9]{0,20}(\\d+[.,]\\d+)`, 'i'),
      new RegExp(`\\b${symbol}\\b[^0-9]{0,20}(\\d+)`, 'i'),
    ];

    let value = null;

    for (const regex of patterns) {
      const match = text.match(regex);
      if (!match) continue;

      const parsed = Number(match[1].replace(',', '.'));
      if (Number.isFinite(parsed) && parsed > 0) {
        value = parsed;
        break;
      }
    }

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
    throw new Error('Official rates not detected on page');
  }

  return rows;
}

module.exports = {
  getOfficialRates,
};
