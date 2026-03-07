const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const dbPath = path.join(__dirname, '../../rates.db');

const db = new sqlite3.Database(dbPath);

db.serialize(() => {

  db.run(`
    CREATE TABLE IF NOT EXISTS rates (
      currency TEXT PRIMARY KEY,
      buy REAL,
      sell REAL
    )
  `);

  const seedRates = [
    ['EUR',277,279],
    ['USD',231.5,235],
    ['GBP',310,314],
    ['CAD',168,172],
    ['CNY',18.7,19.1],
    ['CHF',166.5,169.8]
  ];

  seedRates.forEach(rate=>{
    db.run(`
      INSERT OR IGNORE INTO rates(currency,buy,sell)
      VALUES(?,?,?)
    `,rate);
  });

});

module.exports = db;
