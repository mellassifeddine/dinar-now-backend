const db = require('./database');
const { currencyCatalog } = require('../utils/catalog');

const insertStmt = db.prepare(`
  INSERT INTO parallel_rates (currency, name, flag, buy, sell, updated_at)
  VALUES (@currency, @name, @flag, @buy, @sell, CURRENT_TIMESTAMP)
  ON CONFLICT(currency) DO UPDATE SET
    name = excluded.name,
    flag = excluded.flag,
    buy = excluded.buy,
    sell = excluded.sell,
    updated_at = CURRENT_TIMESTAMP
`);

function seedRow(index, item) {
  switch (item.currency) {
    case 'EUR':
      return {
        ...item,
        buy: 277.0,
        sell: 279.0,
      };
    case 'USD':
      return {
        ...item,
        buy: 231.5,
        sell: 235.0,
      };
    case 'GBP':
      return {
        ...item,
        buy: 310.0,
        sell: 314.0,
      };
    case 'CAD':
      return {
        ...item,
        buy: 174.7,
        sell: 175.0,
      };
    case 'CHF':
      return {
        ...item,
        buy: 166.5,
        sell: 169.8,
      };
    case 'CNY':
      return {
        ...item,
        buy: 18.7,
        sell: 19.1,
      };
    default: {
      const sell = Number((95 + index * 3.17).toFixed(1));
      const buy = Number((sell - 2.8).toFixed(1));
      return {
        ...item,
        buy: buy < 0 ? 0 : buy,
        sell,
      };
    }
  }
}

const transaction = db.transaction(() => {
  currencyCatalog.forEach((item, index) => {
    insertStmt.run(seedRow(index, item));
  });
});

transaction();

console.log('Seed completed successfully.');
