import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class DigitalPage extends StatefulWidget {
  const DigitalPage({super.key});

  @override
  State<DigitalPage> createState() => _DigitalPageState();
}

class _DigitalPageState extends State<DigitalPage> {
  _DigitalCurrency _selectedCurrency = _DigitalCurrency.eur;
  DateTime _lastUpdated = DateTime(2026, 3, 14, 0, 19);

  static final Map<_DigitalCurrency, List<_DigitalRateItem>> _data = {
    _DigitalCurrency.eur: const [
      _DigitalRateItem(
        name: 'MyFin',
        subtitle: 'Euro',
        logoUrl:
            'https://play-lh.googleusercontent.com/5mJ9s4A0gkM4gU1QvYQ6fYF4rY1g2Sg4Q5lQ6G6f0m4mK8Q8m0n6mP0H8vVw3Q=s256-rw',
        minDzd: '280',
        maxDzd: '290',
        fallbackText: 'MF',
      ),
      _DigitalRateItem(
        name: 'Wise',
        subtitle: 'Euro',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Wise_2021.svg/512px-Wise_2021.svg.png',
        minDzd: '280',
        maxDzd: '290',
        fallbackText: 'W',
      ),
      _DigitalRateItem(
        name: 'Paysera',
        subtitle: 'Euro',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Paysera_logo.svg/512px-Paysera_logo.svg.png',
        minDzd: '280',
        maxDzd: '290',
        fallbackText: 'P',
      ),
      _DigitalRateItem(
        name: 'PayPal',
        subtitle: 'Euro',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/PayPal.svg/512px-PayPal.svg.png',
        minDzd: '278',
        maxDzd: '288',
        fallbackText: 'PP',
      ),
      _DigitalRateItem(
        name: 'Dukascopy',
        subtitle: 'Euro',
        logoUrl: 'https://www.dukascopy.bank/static/images/logo_en.png',
        minDzd: '248',
        maxDzd: '260',
        fallbackText: 'D',
      ),
      _DigitalRateItem(
        name: 'N26',
        subtitle: 'Euro',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/N26_logo.svg/512px-N26_logo.svg.png',
        minDzd: '258',
        maxDzd: '260',
        fallbackText: 'N26',
      ),
      _DigitalRateItem(
        name: 'Moneco',
        subtitle: 'Euro',
        logoUrl:
            'https://play-lh.googleusercontent.com/L0sN0E4xjKJ3s9w9YvT7JgI4JbD6M2W2wWw7Q0fWfM4mN0rM7kA0vE0bQ0K8nA=s256-rw',
        minDzd: '280',
        maxDzd: '290',
        fallbackText: 'M',
      ),
      _DigitalRateItem(
        name: 'Revolut',
        subtitle: 'Euro',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Revolut_logo.svg/512px-Revolut_logo.svg.png',
        minDzd: '280',
        maxDzd: '290',
        fallbackText: 'R',
      ),
      _DigitalRateItem(
        name: 'Payoneer',
        subtitle: 'Euro',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Payoneer_logo.svg/512px-Payoneer_logo.svg.png',
        minDzd: '243',
        maxDzd: '243',
        fallbackText: 'P',
      ),
    ],
    _DigitalCurrency.usd: const [
      _DigitalRateItem(
        name: 'Wise',
        subtitle: 'U.S. Dollar',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Wise_2021.svg/512px-Wise_2021.svg.png',
        minDzd: '236',
        maxDzd: '245',
        fallbackText: 'W',
      ),
      _DigitalRateItem(
        name: 'Paysera',
        subtitle: 'U.S. Dollar',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Paysera_logo.svg/512px-Paysera_logo.svg.png',
        minDzd: '235',
        maxDzd: '244',
        fallbackText: 'P',
      ),
      _DigitalRateItem(
        name: 'PayPal',
        subtitle: 'U.S. Dollar',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/PayPal.svg/512px-PayPal.svg.png',
        minDzd: '238',
        maxDzd: '246',
        fallbackText: 'PP',
      ),
      _DigitalRateItem(
        name: 'Revolut',
        subtitle: 'U.S. Dollar',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Revolut_logo.svg/512px-Revolut_logo.svg.png',
        minDzd: '237',
        maxDzd: '245',
        fallbackText: 'R',
      ),
      _DigitalRateItem(
        name: 'Payoneer',
        subtitle: 'U.S. Dollar',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Payoneer_logo.svg/512px-Payoneer_logo.svg.png',
        minDzd: '231',
        maxDzd: '241',
        fallbackText: 'P',
      ),
      _DigitalRateItem(
        name: 'Dukascopy',
        subtitle: 'U.S. Dollar',
        logoUrl: 'https://www.dukascopy.bank/static/images/logo_en.png',
        minDzd: '239',
        maxDzd: '248',
        fallbackText: 'D',
      ),
      _DigitalRateItem(
        name: 'N26',
        subtitle: 'U.S. Dollar',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/N26_logo.svg/512px-N26_logo.svg.png',
        minDzd: '240',
        maxDzd: '247',
        fallbackText: 'N26',
      ),
    ],
    _DigitalCurrency.usdt: const [
      _DigitalRateItem(
        name: 'Binance',
        subtitle: 'USDT',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Binance_logo.svg/512px-Binance_logo.svg.png',
        minDzd: '236',
        maxDzd: '243',
        fallbackText: 'B',
      ),
      _DigitalRateItem(
        name: 'RedotPay',
        subtitle: 'USDT',
        logoUrl:
            'https://play-lh.googleusercontent.com/Y8KX4c1jA5m4v9l3aH8mY7b3lC8u2bW0r7tM4m9v8mYv0aB2A2fJm8H5F4w2qA=s256-rw',
        minDzd: '235',
        maxDzd: '242',
        fallbackText: 'R',
      ),
      _DigitalRateItem(
        name: 'Advcash',
        subtitle: 'USDT',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/AdvCash_logo.png/512px-AdvCash_logo.png',
        minDzd: '234',
        maxDzd: '241',
        fallbackText: 'A',
      ),
      _DigitalRateItem(
        name: 'Payeer',
        subtitle: 'USDT',
        logoUrl: 'https://payeer.com/bitrix/templates/payeer/images/logo.svg',
        minDzd: '233',
        maxDzd: '240',
        fallbackText: 'P',
      ),
      _DigitalRateItem(
        name: 'Perfect Money',
        subtitle: 'USDT',
        logoUrl: 'https://perfectmoney.com/img/logo.png',
        minDzd: '232',
        maxDzd: '239',
        fallbackText: 'PM',
      ),
      _DigitalRateItem(
        name: 'Skrill',
        subtitle: 'USDT',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Skrill_logo.svg/512px-Skrill_logo.svg.png',
        minDzd: '231',
        maxDzd: '238',
        fallbackText: 'S',
      ),
      _DigitalRateItem(
        name: 'Cash',
        subtitle: 'USDT',
        minDzd: '230',
        maxDzd: '237',
        fallbackText: '💵',
      ),
    ],
  };

  void _refreshTimestamp() {
    setState(() {
      _lastUpdated = DateTime.now();
    });
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String get _formattedUpdatedAt {
    final d = _lastUpdated;
    return '${_twoDigits(d.day)}/${_twoDigits(d.month)}/${d.year} ${_twoDigits(d.hour)}:${_twoDigits(d.minute)}';
  }

  List<_DigitalRateItem> get _currentItems =>
      _data[_selectedCurrency] ?? const [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 14),
            const Center(
              child: Text(
                'Digital',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _CurrencyTabs(
                selected: _selectedCurrency,
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF232948),
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(
                          color: const Color(0xFF39406A),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Dernière mise à jour : $_formattedUpdatedAt',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFD4D8EA),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _refreshTimestamp,
                    child: const SizedBox(
                      width: 38,
                      height: 38,
                      child: Icon(
                        Icons.refresh_rounded,
                        color: Color(0xFF4E6CFF),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
                itemCount: _currentItems.length,
                itemBuilder: (context, index) {
                  final item = _currentItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _DigitalRateCard(item: item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyTabs extends StatelessWidget {
  final _DigitalCurrency selected;
  final ValueChanged<_DigitalCurrency> onChanged;

  const _CurrencyTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF232948),
        borderRadius: BorderRadius.circular(31),
        border: Border.all(color: const Color(0xFF39406A), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _CurrencyTabButton(
              selected: selected == _DigitalCurrency.eur,
              label: 'EUR',
              emoji: '🇪🇺',
              onTap: () => onChanged(_DigitalCurrency.eur),
            ),
          ),
          Expanded(
            child: _CurrencyTabButton(
              selected: selected == _DigitalCurrency.usd,
              label: 'USD',
              emoji: '🇺🇸',
              onTap: () => onChanged(_DigitalCurrency.usd),
            ),
          ),
          Expanded(
            child: _CurrencyTabButton(
              selected: selected == _DigitalCurrency.usdt,
              label: 'USDT',
              emoji: '₮',
              emojiBg: const Color(0xFF57C8A7),
              onTap: () => onChanged(_DigitalCurrency.usdt),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyTabButton extends StatelessWidget {
  final bool selected;
  final String label;
  final String emoji;
  final Color? emojiBg;
  final VoidCallback onTap;

  const _CurrencyTabButton({
    required this.selected,
    required this.label,
    required this.emoji,
    this.emojiBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUsdt = label == 'USDT';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4B69F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: isUsdt ? 24 : 26,
                  height: isUsdt ? 24 : 26,
                  decoration: BoxDecoration(
                    color: emojiBg ?? const Color(0xFF0F2D73),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    emoji,
                    style: TextStyle(
                      fontSize: emoji == '₮' ? 16 : 13,
                      color: emoji == '₮' ? Colors.white : null,
                      fontWeight: emoji == '₮' ? FontWeight.w800 : null,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: isUsdt ? 12.5 : 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DigitalRateCard extends StatelessWidget {
  final _DigitalRateItem item;

  const _DigitalRateCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF222449), Color(0xFF151A3E), Color(0xFF10173A)],
        ),
        border: Border.all(color: const Color(0xFF2E3764), width: 1),
      ),
      child: Row(
        children: [
          _DigitalCircleLogo(item: item),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFBEC4E2),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 126,
            child: Row(
              children: [
                Expanded(
                  child: _MinMaxBlock(label: 'min DZD', value: item.minDzd),
                ),
                Container(
                  width: 1,
                  height: 54,
                  color: const Color(0xFF3C49AF),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: _MinMaxBlock(label: 'max DZD', value: item.maxDzd),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MinMaxBlock extends StatelessWidget {
  final String label;
  final String value;

  const _MinMaxBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFFD5D9EE),
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _DigitalCircleLogo extends StatelessWidget {
  final _DigitalRateItem item;

  const _DigitalCircleLogo({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1B2150),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: item.logoUrl != null
            ? Padding(
                padding: const EdgeInsets.all(4),
                child: Image.network(
                  item.logoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _DigitalFallbackLogo(text: item.fallbackText);
                  },
                ),
              )
            : _DigitalFallbackLogo(text: item.fallbackText),
      ),
    );
  }
}

class _DigitalFallbackLogo extends StatelessWidget {
  final String text;

  const _DigitalFallbackLogo({required this.text});

  @override
  Widget build(BuildContext context) {
    final display = text.length > 3 ? text.substring(0, 3) : text;

    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2A3577),
      ),
      alignment: Alignment.center,
      child: Text(
        display,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DigitalRateItem {
  final String name;
  final String subtitle;
  final String? logoUrl;
  final String minDzd;
  final String maxDzd;
  final String fallbackText;

  const _DigitalRateItem({
    required this.name,
    required this.subtitle,
    this.logoUrl,
    required this.minDzd,
    required this.maxDzd,
    required this.fallbackText,
  });
}

enum _DigitalCurrency { eur, usd, usdt }
