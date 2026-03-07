const Database = require('better-sqlite3');

const db = new Database('rates.db');

db.prepare(`
  CREATE TABLE IF NOT EXISTS rates (
    currency TEXT PRIMARY KEY,
    buy REAL NOT NULL,
    sell REAL NOT NULL
  )
`).run();

const seedRates = [
  { currency: 'EUR', buy: 277.0, sell: 279.0 },
  { currency: 'USD', buy: 231.5, sell: 235.0 },
  { currency: 'GBP', buy: 310.0, sell: 314.0 },
  { currency: 'CAD', buy: 168.0, sell: 172.0 },
  { currency: 'CNY', buy: 18.7, sell: 19.1 },
  { currency: 'CHF', buy: 166.5, sell: 169.8 }
];

const selectOneStmt = db.prepare(`
  SELECT currency
  FROM rates
  WHERE currency = ?
`);

const insertStmt = db.prepare(`
  INSERT INTO rates (currency, buy, sell)
  VALUES (?, ?, ?)
`);

for (const rate of seedRates) {
  const exists = selectOneStmt.get(rate.currency);

  if (!exists) {
    insertStmt.run(rate.currency, rate.buy, rate.sell);
  }
}

module.exports = db;
