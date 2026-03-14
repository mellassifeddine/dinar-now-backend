const db = require('./database');

const seedRates = [
  ['EUR', 'Euro', '🇪🇺', 240.0, 245.0],
  ['USD', 'U.S. Dollar', '🇺🇸', 231.5, 235.0],
  ['GBP', 'British Pound', '🇬🇧', 310.0, 314.0],
  ['CAD', 'Canadian Dollar', '🇨🇦', 174.7, 175.0],
  ['CHF', 'Swiss Franc', '🇨🇭', 166.5, 169.8],
  ['CNY', 'Chinese Yuan', '🇨🇳', 18.7, 19.1],
  ['AED', 'UAE Dirham', '🇦🇪', 111.2, 114.0],
  ['AFN', 'AFN', '🇦🇫', 114.4, 117.2],
  ['ALL', 'Albanian Lek', '🇦🇱', 117.6, 120.4],
  ['AMD', 'Armenian Dram', '🇦🇲', 120.7, 123.5],
  ['ANG', 'Neth Antilles Guilder', '🌐', 123.9, 126.7],
  ['AOA', 'Angolan New Kwanza', '🇦🇴', 127.1, 129.9],
  ['ARS', 'Argentine Peso', '🇦🇷', 130.2, 133.0],
  ['AUD', 'Australian Dollar', '🇦🇺', 133.4, 136.2],
  ['AWG', 'Aruba Florin', '🇦🇼', 136.6, 139.4],
  ['AZN', 'AZN', '🇦🇿', 139.8, 142.6],
  ['BAM', 'Bosnian Marka', '🇧🇦', 142.9, 145.7],
  ['BBD', 'Barbados Dollar', '🇧🇧', 146.1, 148.9],
  ['BDT', 'Bangladesh Taka', '🇧🇩', 149.3, 152.1],
  ['BGN', 'Bulgarian Lev', '🇧🇬', 152.4, 155.2],
  ['BHD', 'Bahraini Dinar', '🇧🇭', 155.6, 158.4],
  ['BIF', 'Burundi Franc', '🇧🇮', 158.8, 161.6],
  ['BMD', 'Bermuda Dollar', '🇧🇲', 161.9, 164.7],
  ['BND', 'Brunei Dollar', '🇧🇳', 165.1, 167.9],
  ['BOB', 'Bolivian Boliviano', '🇧🇴', 168.3, 171.1],
  ['BRL', 'Brazilian Real', '🇧🇷', 171.5, 174.3],
  ['BSD', 'Bahamian Dollar', '🇧🇸', 174.6, 177.4],
  ['BTC', 'BTC', '₿', 177.8, 180.6],
  ['BTN', 'Bhutan Ngultrum', '🇧🇹', 181.0, 183.8],
  ['BWP', 'Botswana Pula', '🇧🇼', 184.1, 186.9],
  ['BYN', 'BYN', '🇧🇾', 187.3, 190.1],
  ['BZD', 'Belize Dollar', '🇧🇿', 190.5, 193.3],
  ['CDF', 'Congolese Franc', '🇨🇩', 193.6, 196.4],
  ['CLF', 'CLF', '🌐', 196.8, 199.6],
  ['CLP', 'Chilean Peso', '🇨🇱', 200.0, 202.8],
  ['CNH', 'CNH', '🌐', 203.1, 205.9],
  ['COP', 'Colombian Peso', '🇨🇴', 206.3, 209.1],
  ['CRC', 'Costa Rica Colon', '🇨🇷', 209.5, 212.3],
  ['CUP', 'Cuban Peso', '🇨🇺', 212.7, 215.5],
  ['CVE', 'Cape Verde Escudo', '🇨🇻', 215.8, 218.6],
  ['CZK', 'Czech Koruna', '🇨🇿', 219.0, 221.8],
  ['DJF', 'Djibouti Franc', '🇩🇯', 222.2, 225.0],
  ['DKK', 'Danish Krone', '🇩🇰', 225.3, 228.1],
  ['DOP', 'Dominican Peso', '🇩🇴', 228.5, 231.3],
  ['DZD', 'Algerian Dinar', '🇩🇿', 231.7, 234.5],
  ['EGP', 'Egyptian Pound', '🇪🇬', 234.9, 237.7],
  ['ERN', 'Eritrea Nakfa', '🇪🇷', 238.0, 240.8],
  ['ETB', 'Ethiopian Birr', '🇪🇹', 241.2, 244.0],
  ['FJD', 'Fiji Dollar', '🇫🇯', 244.4, 247.2],
  ['FKP', 'Falkland Islands Pound', '🇫🇰', 247.5, 250.3],
  ['GEL', 'Georgian Lari', '🇬🇪', 250.7, 253.5],
  ['GGP', 'Guernsey Pound', '🌐', 253.9, 256.7],
  ['GHS', 'GHS', '🇬🇭', 257.0, 259.8],
  ['GIP', 'Gibraltar Pound', '🇬🇮', 260.2, 263.0],
  ['GMD', 'Gambian Dalasi', '🇬🇲', 263.4, 266.2],
  ['INR', 'Indian Rupee', '🇮🇳', 266.6, 269.4],
  ['IQD', 'Iraqi Dinar', '🇮🇶', 269.7, 272.5],
  ['IRR', 'Iran Rial', '🇮🇷', 272.9, 275.7],
  ['ISK', 'Iceland Krona', '🇮🇸', 276.1, 278.9],
  ['JEP', 'Jersey Pound', '🌐', 279.2, 282.0],
  ['JMD', 'Jamaican Dollar', '🇯🇲', 282.4, 285.2],
  ['JOD', 'Jordanian Dinar', '🇯🇴', 285.6, 288.4],
  ['JPY', 'Japanese Yen', '🇯🇵', 288.7, 291.5],
  ['KES', 'Kenyan Shilling', '🇰🇪', 291.9, 294.7],
  ['KGS', 'Kyrgyzstan Som', '🇰🇬', 295.1, 297.9],
  ['KHR', 'Cambodia Riel', '🇰🇭', 298.2, 301.0],
  ['KMF', 'Comoros Franc', '🇰🇲', 301.4, 304.2],
  ['KPW', 'North Korean Won', '🇰🇵', 304.6, 307.4],
  ['KRW', 'Korean Won', '🇰🇷', 307.8, 310.6],
  ['KWD', 'Kuwaiti Dinar', '🇰🇼', 310.9, 313.7],
  ['KYD', 'Cayman Islands Dollar', '🇰🇾', 314.1, 316.9],
  ['KZT', 'Kazakhstan Tenge', '🇰🇿', 317.3, 320.1],
  ['LAK', 'Lao Kip', '🇱🇦', 320.4, 323.2],
  ['LBP', 'Lebanese Pound', '🇱🇧', 323.6, 326.4],
  ['LKR', 'Sri Lanka Rupee', '🇱🇰', 326.8, 329.6],
  ['LRD', 'Liberian Dollar', '🇱🇷', 330.0, 332.8],
  ['LSL', 'Lesotho Loti', '🇱🇸', 333.1, 335.9],
  ['LYD', 'Libyan Dinar', '🇱🇾', 336.3, 339.1],
  ['MAD', 'Moroccan Dirham', '🇲🇦', 339.5, 342.3],
  ['MDL', 'Moldovan Leu', '🇲🇩', 342.6, 345.4],
  ['MGA', 'MGA', '🇲🇬', 345.8, 348.6],
  ['MKD', 'Macedonian Denar', '🇲🇰', 349.0, 351.8],
  ['RUB', 'Russian Rouble', '🇷🇺', 352.1, 354.9],
  ['RWF', 'Rwanda Franc', '🇷🇼', 355.3, 358.1],
  ['SAR', 'Saudi Arabian Riyal', '🇸🇦', 358.5, 361.3],
  ['SBD', 'Solomon Islands Dollar', '🇸🇧', 361.6, 364.4],
  ['SCR', 'Seychelles Rupee', '🇸🇨', 364.8, 367.6],
  ['SDG', 'SDG', '🇸🇩', 368.0, 370.8],
  ['SEK', 'Swedish Krona', '🇸🇪', 371.2, 374.0],
  ['SGD', 'Singapore Dollar', '🇸🇬', 374.3, 377.1],
  ['SHP', 'St Helena Pound', '🇸🇭', 377.5, 380.3],
];

function ensureSeedRates() {
  const insertOrIgnore = db.prepare(`
    INSERT OR IGNORE INTO parallel_rates (currency, name, flag, buy, sell)
    VALUES (?, ?, ?, ?, ?)
  `);

  const transaction = db.transaction((items) => {
    for (const item of items) {
      insertOrIgnore.run(...item);
    }
  });

  transaction(seedRates);

  const row = db.prepare('SELECT COUNT(*) AS count FROM parallel_rates').get();

  console.log(
    `Seed sync completed. parallel_rates now contains ${row.count} currencies.`
  );
}

if (require.main === module) {
  ensureSeedRates();
}

module.exports = {
  ensureSeedRates,
  seedRates,
};
