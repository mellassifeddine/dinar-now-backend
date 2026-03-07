const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const dbPath = path.join(__dirname, '../../rates.db');
const db = new sqlite3.Database(dbPath);

db.serialize(() => {
  db.run(`
    CREATE TABLE IF NOT EXISTS rates (
      currency TEXT PRIMARY KEY,
      buy REAL NOT NULL,
      sell REAL NOT NULL
    )
  `);

  const seedRates = [
    ['EUR', 277.0, 279.0],
    ['USD', 231.5, 235.0],
    ['GBP', 310.0, 314.0],
    ['CAD', 168.0, 172.0],
    ['CNY', 18.7, 19.1],
    ['CHF', 166.5, 169.8]
  ];

  const stmt = db.prepare(`
    INSERT OR IGNORE INTO rates (currency, buy, sell)
    VALUES (?, ?, ?)
  `);

  for (const rate of seedRates) {
    stmt.run(rate);
  }

  stmt.finalize();
});

module.exports = db;
