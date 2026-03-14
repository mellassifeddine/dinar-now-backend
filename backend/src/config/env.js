const path = require('path');

const PORT = Number(process.env.PORT || 3000);
const ADMIN_KEY =
  process.env.ADMIN_KEY || 'change_this_to_a_long_random_secret_key';

const DB_PATH =
  process.env.DB_PATH || path.join(__dirname, '../../data/dinar_now.sqlite');

module.exports = {
  PORT,
  ADMIN_KEY,
  DB_PATH,
};
