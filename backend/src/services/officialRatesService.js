const https = require('https');

const SOURCES = [
  'https://www.bank-of-algeria.dz/taux-de-change-journalier/',
  'https://www.bank-of-algeria.dz/',
];

const META = {
  EUR: { name: 'Euro', flag: '🇪🇺' },
  USD: { name: 'U.S. Dollar', flag: '🇺🇸' },
  GBP: { name: 'British Pound', flag: '🇬🇧' },
  CAD: { name: 'Canadian Dollar', flag: '🇨🇦' },
  CHF: { name: 'Swiss Franc', flag: '🇨🇭' },
  CNY: { name: 'Chinese Yuan', flag: '🇨🇳' },
  SAR: { name: 'Saudi Arabian Riyal', flag: '🇸🇦' },
  AED: { name: 'UAE Dirham', flag: '🇦🇪' },
  QAR: { name: 'Qatari Riyal', flag: '🇶🇦' },
  TND: { name: 'Tunisian Dinar', flag: '🇹🇳' },
  MAD: { name: 'Moroccan Dirham', flag: '🇲🇦' },
  EGP: { name: 'Egyptian Pound', flag: '🇪🇬' },
  NOK: { name: 'Norwegian Krone', flag: '🇳🇴' },
  AUD: { name: 'Australian Dollar', flag: '🇦🇺' },
  LYD: { name: 'Libyan Dinar', flag: '🇱🇾' },
  JPY: { name: 'Japanese Yen', flag: '🇯🇵' },
  DKK: { name: 'Danish Krone', flag: '🇩🇰' },
  SEK: { name: 'Swedish Krona', flag: '🇸🇪' },
};

const PREFERRED_ORDER = [
  'EUR',
  'USD',
  'GBP',
  'CAD',
  'CHF',
  'CNY',
  'SAR',
  'AED',
  'QAR',
  'TND',
  'MAD',
  'EGP',
  'NOK',
  'AUD',
  'LYD',
  'JPY',
  'DKK',
  'SEK',
];

let cache = {
  rows: null,
  fetchedAt: 0,
};

const CACHE_TTL_MS = 60 * 60 * 1000;

function fetchUrl(url, redirectCount = 0) {
  return new Promise((resolve, reject) => {
    const req = https.get(
      url,
      {
        headers: {
          'User-Agent': 'DinarNow/1.0 (+official-rates)',
          Accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
      },
      (res) => {
        const statusCode = res.statusCode || 0;

        if (
          statusCode >= 300 &&
          statusCode < 400 &&
          res.headers.location &&
          redirectCount < 5
        ) {
          const redirectedUrl = new URL(res.headers.location, url).toString();
          res.resume();
          resolve(fetchUrl(redirectedUrl, redirectCount + 1));
          return;
        }

        if (statusCode < 200 || statusCode >= 300) {
          res.resume();
          reject(new Error(`HTTP ${statusCode} for ${url}`));
          return;
        }

        let raw = '';
        res.setEncoding('utf8');

        res.on('data', (chunk) => {
          raw += chunk;
        });

        res.on('end', () => {
          resolve(raw);
        });
      }
    );

    req.on('error', reject);
    req.setTimeout(15000, () => {
      req.destroy(new Error(`Timeout for ${url}`));
    });
  });
}

function htmlToPlainText(html) {
  return html
    .replace(/<script[\s\S]*?<\/script>/gi, ' ')
    .replace(/<style[\s\S]*?<\/style>/gi, ' ')
    .replace(/<[^>]+>/g, ' ')
    .replace(/&nbsp;/gi, ' ')
    .replace(/&amp;/gi, '&')
    .replace(/&quot;/gi, '"')
    .replace(/&#39;/gi, "'")
    .replace(/\s+/g, ' ')
    .trim();
}

function parseNumber(value) {
  return Number(String(value).replace(',', '.'));
}

function buildInverseText(rate, symbol) {
  if (!rate || rate <= 0) return '';
  const inverse = 1 / rate;
  const digits = inverse >= 1 ? 4 : 6;
  return `1 DZD = ${inverse.toFixed(digits)} ${symbol}`;
}

function extractRowsFromText(text) {
  const rows = [];

  for (const symbol of PREFERRED_ORDER) {
    const meta = META[symbol];
    if (!meta) continue;

    const patterns = [
      new RegExp(`\\b${symbol}\\b[^\\d]{0,24}(\\d{1,3}(?:[\\.,]\\d{1,6})?)`, 'i'),
      new RegExp(`${symbol}[\\s,.;:]{1,12}(\\d{1,3}(?:[\\.,]\\d{1,6})?)`, 'i'),
    ];

    let value = null;

    for (const pattern of patterns) {
      const match = text.match(pattern);
      if (match && match[1]) {
        value = parseNumber(match[1]);
        if (Number.isFinite(value) && value > 0) {
          break;
        }
      }
    }

    if (!Number.isFinite(value) || value <= 0) continue;

    rows.push({
      currency: symbol,
      name: meta.name,
      flag: meta.flag,
      buy: 0,
      sell: value,
      inverseText: buildInverseText(value, symbol),
      updated_at: new Date().toISOString(),
    });
  }

  rows.sort((a, b) => {
    return PREFERRED_ORDER.indexOf(a.currency) - PREFERRED_ORDER.indexOf(b.currency);
  });

  return rows;
}

async function fetchOfficialRatesFresh() {
  let bestRows = [];

  for (const source of SOURCES) {
    try {
      const html = await fetchUrl(source);
      const text = htmlToPlainText(html);
      const rows = extractRowsFromText(text);

      if (rows.length > bestRows.length) {
        bestRows = rows;
      }
    } catch (_) {
      // try next source
    }
  }

  if (!bestRows.length) {
    throw new Error('Failed to parse official rates from Banque d’Algérie sources.');
  }

  cache = {
    rows: bestRows,
    fetchedAt: Date.now(),
  };

  return bestRows;
}

async function getOfficialRates() {
  const isCacheFresh =
    Array.isArray(cache.rows) &&
    cache.rows.length > 0 &&
    Date.now() - cache.fetchedAt < CACHE_TTL_MS;

  if (isCacheFresh) {
    return cache.rows;
  }

  try {
    return await fetchOfficialRatesFresh();
  } catch (error) {
    if (Array.isArray(cache.rows) && cache.rows.length > 0) {
      return cache.rows;
    }
    throw error;
  }
}

module.exports = {
  getOfficialRates,
};
