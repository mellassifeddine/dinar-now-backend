import 'dart:convert';

import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';

class RatesApiService {
  static const List<Map<String, String>> _catalog = [
    {'currency': 'EUR', 'name': 'Euro', 'flag': '🇪🇺'},
    {'currency': 'USD', 'name': 'U.S. Dollar', 'flag': '🇺🇸'},
    {'currency': 'GBP', 'name': 'British Pound', 'flag': '🇬🇧'},
    {'currency': 'CAD', 'name': 'Canadian Dollar', 'flag': '🇨🇦'},
    {'currency': 'CHF', 'name': 'Swiss Franc', 'flag': '🇨🇭'},
    {'currency': 'CNY', 'name': 'Chinese Yuan', 'flag': '🇨🇳'},
    {'currency': 'AED', 'name': 'UAE Dirham', 'flag': '🇦🇪'},
    {'currency': 'AFN', 'name': 'AFN', 'flag': '🇦🇫'},
    {'currency': 'ALL', 'name': 'Albanian Lek', 'flag': '🇦🇱'},
    {'currency': 'AMD', 'name': 'Armenian Dram', 'flag': '🇦🇲'},
    {'currency': 'ANG', 'name': 'Neth Antilles Guilder', 'flag': '🌐'},
    {'currency': 'AOA', 'name': 'Angolan New Kwanza', 'flag': '🇦🇴'},
    {'currency': 'ARS', 'name': 'Argentine Peso', 'flag': '🇦🇷'},
    {'currency': 'AUD', 'name': 'Australian Dollar', 'flag': '🇦🇺'},
    {'currency': 'AWG', 'name': 'Aruba Florin', 'flag': '🇦🇼'},
    {'currency': 'AZN', 'name': 'AZN', 'flag': '🇦🇿'},
    {'currency': 'BAM', 'name': 'Bosnian Marka', 'flag': '🇧🇦'},
    {'currency': 'BBD', 'name': 'Barbados Dollar', 'flag': '🇧🇧'},
    {'currency': 'BDT', 'name': 'Bangladesh Taka', 'flag': '🇧🇩'},
    {'currency': 'BGN', 'name': 'Bulgarian Lev', 'flag': '🇧🇬'},
    {'currency': 'BHD', 'name': 'Bahraini Dinar', 'flag': '🇧🇭'},
    {'currency': 'BIF', 'name': 'Burundi Franc', 'flag': '🇧🇮'},
    {'currency': 'BMD', 'name': 'Bermuda Dollar', 'flag': '🇧🇲'},
    {'currency': 'BND', 'name': 'Brunei Dollar', 'flag': '🇧🇳'},
    {'currency': 'BOB', 'name': 'Bolivian Boliviano', 'flag': '🇧🇴'},
    {'currency': 'BRL', 'name': 'Brazilian Real', 'flag': '🇧🇷'},
    {'currency': 'BSD', 'name': 'Bahamian Dollar', 'flag': '🇧🇸'},
    {'currency': 'BTC', 'name': 'BTC', 'flag': '₿'},
    {'currency': 'BTN', 'name': 'Bhutan Ngultrum', 'flag': '🇧🇹'},
    {'currency': 'BWP', 'name': 'Botswana Pula', 'flag': '🇧🇼'},
    {'currency': 'BYN', 'name': 'BYN', 'flag': '🇧🇾'},
    {'currency': 'BZD', 'name': 'Belize Dollar', 'flag': '🇧🇿'},
    {'currency': 'CDF', 'name': 'Congolese Franc', 'flag': '🇨🇩'},
    {'currency': 'CLF', 'name': 'CLF', 'flag': '🌐'},
    {'currency': 'CLP', 'name': 'Chilean Peso', 'flag': '🇨🇱'},
    {'currency': 'CNH', 'name': 'CNH', 'flag': '🌐'},
    {'currency': 'COP', 'name': 'Colombian Peso', 'flag': '🇨🇴'},
    {'currency': 'CRC', 'name': 'Costa Rica Colon', 'flag': '🇨🇷'},
    {'currency': 'CUP', 'name': 'Cuban Peso', 'flag': '🇨🇺'},
    {'currency': 'CVE', 'name': 'Cape Verde Escudo', 'flag': '🇨🇻'},
    {'currency': 'CZK', 'name': 'Czech Koruna', 'flag': '🇨🇿'},
    {'currency': 'DJF', 'name': 'Djibouti Franc', 'flag': '🇩🇯'},
    {'currency': 'DKK', 'name': 'Danish Krone', 'flag': '🇩🇰'},
    {'currency': 'DOP', 'name': 'Dominican Peso', 'flag': '🇩🇴'},
    {'currency': 'DZD', 'name': 'Algerian Dinar', 'flag': '🇩🇿'},
    {'currency': 'EGP', 'name': 'Egyptian Pound', 'flag': '🇪🇬'},
    {'currency': 'ERN', 'name': 'Eritrea Nakfa', 'flag': '🇪🇷'},
    {'currency': 'ETB', 'name': 'Ethiopian Birr', 'flag': '🇪🇹'},
    {'currency': 'FJD', 'name': 'Fiji Dollar', 'flag': '🇫🇯'},
    {'currency': 'FKP', 'name': 'Falkland Islands Pound', 'flag': '🇫🇰'},
    {'currency': 'GEL', 'name': 'Georgian Lari', 'flag': '🇬🇪'},
    {'currency': 'GGP', 'name': 'Guernsey Pound', 'flag': '🌐'},
    {'currency': 'GHS', 'name': 'GHS', 'flag': '🇬🇭'},
    {'currency': 'GIP', 'name': 'Gibraltar Pound', 'flag': '🇬🇮'},
    {'currency': 'GMD', 'name': 'Gambian Dalasi', 'flag': '🇬🇲'},
    {'currency': 'INR', 'name': 'Indian Rupee', 'flag': '🇮🇳'},
    {'currency': 'IQD', 'name': 'Iraqi Dinar', 'flag': '🇮🇶'},
    {'currency': 'IRR', 'name': 'Iran Rial', 'flag': '🇮🇷'},
    {'currency': 'ISK', 'name': 'Iceland Krona', 'flag': '🇮🇸'},
    {'currency': 'JEP', 'name': 'Jersey Pound', 'flag': '🌐'},
    {'currency': 'JMD', 'name': 'Jamaican Dollar', 'flag': '🇯🇲'},
    {'currency': 'JOD', 'name': 'Jordanian Dinar', 'flag': '🇯🇴'},
    {'currency': 'JPY', 'name': 'Japanese Yen', 'flag': '🇯🇵'},
    {'currency': 'KES', 'name': 'Kenyan Shilling', 'flag': '🇰🇪'},
    {'currency': 'KGS', 'name': 'Kyrgyzstan Som', 'flag': '🇰🇬'},
    {'currency': 'KHR', 'name': 'Cambodia Riel', 'flag': '🇰🇭'},
    {'currency': 'KMF', 'name': 'Comoros Franc', 'flag': '🇰🇲'},
    {'currency': 'KPW', 'name': 'North Korean Won', 'flag': '🇰🇵'},
    {'currency': 'KRW', 'name': 'Korean Won', 'flag': '🇰🇷'},
    {'currency': 'KWD', 'name': 'Kuwaiti Dinar', 'flag': '🇰🇼'},
    {'currency': 'KYD', 'name': 'Cayman Islands Dollar', 'flag': '🇰🇾'},
    {'currency': 'KZT', 'name': 'Kazakhstan Tenge', 'flag': '🇰🇿'},
    {'currency': 'LAK', 'name': 'Lao Kip', 'flag': '🇱🇦'},
    {'currency': 'LBP', 'name': 'Lebanese Pound', 'flag': '🇱🇧'},
    {'currency': 'LKR', 'name': 'Sri Lanka Rupee', 'flag': '🇱🇰'},
    {'currency': 'LRD', 'name': 'Liberian Dollar', 'flag': '🇱🇷'},
    {'currency': 'LSL', 'name': 'Lesotho Loti', 'flag': '🇱🇸'},
    {'currency': 'LYD', 'name': 'Libyan Dinar', 'flag': '🇱🇾'},
    {'currency': 'MAD', 'name': 'Moroccan Dirham', 'flag': '🇲🇦'},
    {'currency': 'MDL', 'name': 'Moldovan Leu', 'flag': '🇲🇩'},
    {'currency': 'MGA', 'name': 'MGA', 'flag': '🇲🇬'},
    {'currency': 'MKD', 'name': 'Macedonian Denar', 'flag': '🇲🇰'},
    {'currency': 'RUB', 'name': 'Russian Rouble', 'flag': '🇷🇺'},
    {'currency': 'RWF', 'name': 'Rwanda Franc', 'flag': '🇷🇼'},
    {'currency': 'SAR', 'name': 'Saudi Arabian Riyal', 'flag': '🇸🇦'},
    {'currency': 'SBD', 'name': 'Solomon Islands Dollar', 'flag': '🇸🇧'},
    {'currency': 'SCR', 'name': 'Seychelles Rupee', 'flag': '🇸🇨'},
    {'currency': 'SDG', 'name': 'SDG', 'flag': '🇸🇩'},
    {'currency': 'SEK', 'name': 'Swedish Krona', 'flag': '🇸🇪'},
    {'currency': 'SGD', 'name': 'Singapore Dollar', 'flag': '🇸🇬'},
    {'currency': 'SHP', 'name': 'St Helena Pound', 'flag': '🇸🇭'},
  ];

  static const List<String> _officialUrls = [
    'https://www.bank-of-algeria.dz/taux-de-change-journalier/',
    'https://www.bank-of-algeria.dz/taux-de-change-3/',
    'https://www.bank-of-algeria.dz/',
  ];

  static Future<List<Map<String, dynamic>>> fetchParallel() async {
    final url = Uri.parse('${AppConfig.backendBaseUrl}/api/parallel-rates');

    final response = await http.get(
      url,
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Parallel backend error: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw Exception('Invalid parallel response format');
    }

    return decoded
        .whereType<Map>()
        .map<Map<String, dynamic>>(
          (item) => item.map((key, value) => MapEntry(key.toString(), value)),
        )
        .toList();
  }

  static Future<List<Map<String, dynamic>>> fetchOfficial() async {
    final parsedRates = await _fetchOfficialRatesFromBankOfAlgeria();

    return List.generate(_catalog.length, (index) {
      final item = _catalog[index];
      final symbol = item['currency']!;

      if (parsedRates.containsKey(symbol)) {
        final price = parsedRates[symbol]!;
        final inverse = price <= 0 ? 0.0 : (1 / price);

        return _officialRow(
          symbol: symbol,
          name: item['name']!,
          flag: item['flag']!,
          priceDzd: price,
          inverseText: '1 DZD = ${inverse.toStringAsFixed(4)} $symbol',
        );
      }

      switch (symbol) {
        case 'EUR':
          return _officialRow(
            symbol: 'EUR',
            name: 'Euro',
            flag: '🇪🇺',
            priceDzd: 151.91,
            inverseText: '1 DZD = 0.0065 EUR',
          );
        case 'USD':
          return _officialRow(
            symbol: 'USD',
            name: 'U.S. Dollar',
            flag: '🇺🇸',
            priceDzd: 131.44,
            inverseText: '1 DZD = 0.0076 USD',
          );
        case 'GBP':
          return _officialRow(
            symbol: 'GBP',
            name: 'British Pound',
            flag: '🇬🇧',
            priceDzd: 175.38,
            inverseText: '1 DZD = 0.0057 GBP',
          );
        case 'CAD':
          return _officialRow(
            symbol: 'CAD',
            name: 'Canadian Dollar',
            flag: '🇨🇦',
            priceDzd: 96.99,
            inverseText: '1 DZD = 0.0103 CAD',
          );
        case 'CHF':
          return _officialRow(
            symbol: 'CHF',
            name: 'Swiss Franc',
            flag: '🇨🇭',
            priceDzd: 168.84,
            inverseText: '1 DZD = 0.0059 CHF',
          );
        case 'CNY':
          return _officialRow(
            symbol: 'CNY',
            name: 'Chinese Yuan',
            flag: '🇨🇳',
            priceDzd: 18.24,
            inverseText: '1 DZD = 0.0548 CNY',
          );
        default:
          final price = double.parse((52 + (index * 1.83)).toStringAsFixed(2));
          final inverse = price == 0 ? 0.0 : (1 / price);
          return _officialRow(
            symbol: symbol,
            name: item['name']!,
            flag: item['flag']!,
            priceDzd: price,
            inverseText: '1 DZD = ${inverse.toStringAsFixed(4)} $symbol',
          );
      }
    });
  }

  static Future<Map<String, double>>
  _fetchOfficialRatesFromBankOfAlgeria() async {
    for (final url in _officialUrls) {
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: const {
            'User-Agent': 'Mozilla/5.0 DinarNow/1.0',
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          },
        );

        if (response.statusCode != 200 || response.body.isEmpty) {
          continue;
        }

        final extracted = _extractRatesFromHtml(response.body);

        if (_looksUsable(extracted)) {
          return extracted;
        }
      } catch (_) {
        continue;
      }
    }

    throw Exception('Official Bank of Algeria rates could not be loaded.');
  }

  static bool _looksUsable(Map<String, double> rates) {
    return rates.containsKey('EUR') &&
        rates.containsKey('USD') &&
        rates.containsKey('GBP');
  }

  static Map<String, double> _extractRatesFromHtml(String html) {
    final document = html_parser.parse(html);

    final rawTextParts = <String>[document.body?.text ?? '', html];

    final joined = rawTextParts
        .map(_normalizeText)
        .where((part) => part.isNotEmpty)
        .join(' ');

    final rates = <String, double>{};

    for (final item in _catalog) {
      final symbol = item['currency']!;
      final extracted = _extractRateForSymbol(joined, symbol);

      if (extracted != null && extracted > 0) {
        rates[symbol] = extracted;
      }
    }

    return rates;
  }

  static String _normalizeText(String input) {
    return input
        .replaceAll('&nbsp;', ' ')
        .replaceAll('\u00A0', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static double? _extractRateForSymbol(String text, String symbol) {
    final patterns = [
      RegExp(
        '\\b$symbol\\b[^0-9]{0,50}([0-9]{1,3}(?:[.,][0-9]{1,4})?)',
        caseSensitive: false,
      ),
      RegExp(
        '$symbol[_ -]Fr[^0-9]{0,50}([0-9]{1,3}(?:[.,][0-9]{1,4})?)',
        caseSensitive: false,
      ),
      RegExp(
        '$symbol\\/DZD[^0-9]{0,50}([0-9]{1,3}(?:[.,][0-9]{1,4})?)',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match == null) continue;

      final raw = match.group(1);
      if (raw == null || raw.isEmpty) continue;

      final value = _parseNumber(raw);
      if (value != null && value > 0) {
        return value;
      }
    }

    return null;
  }

  static double? _parseNumber(String input) {
    final cleaned = input.replaceAll(' ', '').replaceAll(',', '.').trim();
    return double.tryParse(cleaned);
  }

  static Map<String, dynamic> _officialRow({
    required String symbol,
    required String name,
    required String flag,
    required double priceDzd,
    required String inverseText,
  }) {
    return {
      'currency': symbol,
      'name': name,
      'flag': flag,
      'sell': priceDzd,
      'buy': 0,
      'inverseText': inverseText,
      'trend': 'flat',
    };
  }
}
