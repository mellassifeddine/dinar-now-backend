import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/cache/rates_cache.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/animated_price.dart';
import '../../../converter/presentation/pages/converter_page.dart';
import '../../../crypto/presentation/pages/crypto_page.dart';
import '../../../digital/presentation/pages/digital_page.dart';
import '../../../gold/presentation/pages/gold_page.dart';
import '../../../rates/data/rates_api_service.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _LiveChangePage(),
    CryptoPage(),
    DigitalPage(),
    GoldPage(),
    SettingsPage(),
  ];

  static const List<_NavItemData> _items = [
    _NavItemData(label: 'Change', icon: Icons.sync_alt_rounded),
    _NavItemData(label: 'Crypto', icon: Icons.currency_bitcoin_rounded),
    _NavItemData(label: 'Digital', icon: Icons.account_balance_wallet_outlined),
    _NavItemData(label: 'Or', icon: Icons.workspace_premium_outlined),
    _NavItemData(label: 'Settings', icon: Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0E1220),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.cardBorder),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = _currentIndex == index;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: 18,
                          color: isSelected
                              ? const Color(0xFF0B111B)
                              : AppTheme.textPrimary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF0B111B)
                                : AppTheme.textPrimary,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _LiveChangePage extends StatefulWidget {
  const _LiveChangePage();

  @override
  State<_LiveChangePage> createState() => _LiveChangePageState();
}

class _LiveChangePageState extends State<_LiveChangePage> {
  bool _isParallel = true;
  bool _loading = true;
  String? _error;
  List<_RateItem> _rates = const [];
  Timer? _timer;

  Map<String, double> _parallelLastSnapshot = {};
  Map<String, double> _officialLastSnapshot = {};

  @override
  void initState() {
    super.initState();
    _loadRates(showLoader: true);

    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _loadRates(showLoader: false),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadRates({required bool showLoader}) async {
    if (showLoader && mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    final cache = _isParallel
        ? await RatesCache.loadParallel()
        : await RatesCache.loadOfficial();

    if (cache != null && cache.isNotEmpty && mounted && _rates.isEmpty) {
      setState(() {
        _rates = _mapRows(cache);
        _loading = false;
      });
    }

    try {
      final rows = _isParallel
          ? await RatesApiService.fetchParallel()
          : await RatesApiService.fetchOfficial();

      if (_isParallel) {
        await RatesCache.saveParallel(rows);
      } else {
        await RatesCache.saveOfficial(rows);
      }

      if (!mounted) return;

      setState(() {
        _rates = _mapRows(rows);
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = _rates.isEmpty
            ? 'Impossible de charger les taux pour le moment.'
            : null;
      });
    }
  }

  List<_RateItem> _mapRows(List<Map<String, dynamic>> rows) {
    final previousSnapshot = _isParallel
        ? _parallelLastSnapshot
        : _officialLastSnapshot;

    final nextSnapshot = <String, double>{};

    final mapped = rows.map((row) {
      final symbol = (row['currency'] ?? '').toString().trim();
      final name = (row['name'] ?? '').toString().trim();
      final buy = _toDouble(row['buy']);
      final sell = _toDouble(row['sell']);
      final flag = (row['flag'] ?? '💱').toString();
      final inverseText = (row['inverseText'] ?? '').toString();

      final currentReference = _isParallel ? ((buy + sell) / 2) : sell;
      nextSnapshot[symbol] = currentReference;

      final previousReference = previousSnapshot[symbol];
      final trend = _computeTrend(previousReference, currentReference);

      return _RateItem(
        symbol: symbol,
        name: name,
        buy: buy,
        sell: sell,
        flag: flag,
        inverseText: inverseText,
        trend: trend,
      );
    }).toList();

    if (_isParallel) {
      _parallelLastSnapshot = nextSnapshot;
    } else {
      _officialLastSnapshot = nextSnapshot;
    }

    return mapped;
  }

  _TrendDirection _computeTrend(double? previous, double current) {
    if (previous == null) return _TrendDirection.flat;

    const epsilon = 0.0001;

    if (current > previous + epsilon) return _TrendDirection.up;
    if (current < previous - epsilon) return _TrendDirection.down;
    return _TrendDirection.flat;
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _loadRates(showLoader: false),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ConverterPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF212A57),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0x66FFFFFF), width: 1),
                ),
                child: const Text(
                  'Converter',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Center(
            child: Text(
              'Change',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF13182B),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SegmentButton(
                    label: 'Parallèle',
                    icon: Icons.check_rounded,
                    selected: _isParallel,
                    onTap: () {
                      if (_isParallel) return;
                      setState(() {
                        _isParallel = true;
                        _rates = const [];
                      });
                      _loadRates(showLoader: true);
                    },
                  ),
                ),
                Expanded(
                  child: _SegmentButton(
                    label: 'Officiel',
                    icon: Icons.account_balance_outlined,
                    selected: !_isParallel,
                    onTap: () {
                      if (!_isParallel) return;
                      setState(() {
                        _isParallel = false;
                        _rates = const [];
                      });
                      _loadRates(showLoader: true);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const _GreenDot(),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isParallel
                      ? 'Marché parallèle • rafraîchissement 30s'
                      : 'Marché officiel • rafraîchissement 30s',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111522),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Text(
                _error!,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
            )
          else
            ..._rates.map(
              (rate) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _CompactRateCard(rate: rate, isOfficial: !_isParallel),
              ),
            ),
        ],
      ),
    );
  }
}

class _CompactRateCard extends StatelessWidget {
  final _RateItem rate;
  final bool isOfficial;

  const _CompactRateCard({required this.rate, required this.isOfficial});

  @override
  Widget build(BuildContext context) {
    const priceStyle = TextStyle(
      color: AppTheme.textPrimary,
      fontSize: 17,
      fontWeight: FontWeight.w800,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF171A33),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF272B4D), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _CurrencyBadge(flag: rate.flag),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rate.symbol,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rate.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _TrendArrowIcon(trend: rate.trend, size: 18),
          const SizedBox(width: 8),
          if (isOfficial)
            _OfficialPriceBlock(
              value: rate.sell,
              inverseText: rate.inverseText,
              style: priceStyle,
            )
          else ...[
            _RatePriceBlock(
              value: rate.sell,
              label: 'Vente',
              style: priceStyle,
              labelColor: const Color(0xFFFF7B7B),
            ),
            const SizedBox(width: 14),
            _RatePriceBlock(
              value: rate.buy,
              label: 'Achat',
              style: priceStyle,
              labelColor: const Color(0xFFA8F28B),
            ),
          ],
        ],
      ),
    );
  }
}

class _OfficialPriceBlock extends StatelessWidget {
  final double value;
  final String inverseText;
  final TextStyle style;

  const _OfficialPriceBlock({
    required this.value,
    required this.inverseText,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedPrice(value: value, style: style, fractionDigits: 2),
          const SizedBox(height: 4),
          Text(
            inverseText,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendArrowIcon extends StatelessWidget {
  final _TrendDirection trend;
  final double size;

  const _TrendArrowIcon({required this.trend, this.size = 18});

  Color get _color {
    switch (trend) {
      case _TrendDirection.up:
        return const Color(0xFFA8F28B);
      case _TrendDirection.down:
        return const Color(0xFFFF7B7B);
      case _TrendDirection.flat:
        return const Color(0xFFEDEFF7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TrendArrowPainter(trend: trend, color: _color),
      ),
    );
  }
}

class _TrendArrowPainter extends CustomPainter {
  final _TrendDirection trend;
  final Color color;

  const _TrendArrowPainter({required this.trend, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final headPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final glowPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.56, size.height * 0.46),
        size.width * 0.55,
        [color.withValues(alpha: 0.14), color.withValues(alpha: 0.0)],
      )
      ..blendMode = BlendMode.plus;

    if (trend == _TrendDirection.down) {
      final path = Path()
        ..moveTo(size.width * 0.08, size.height * 0.30)
        ..lineTo(size.width * 0.34, size.height * 0.52)
        ..lineTo(size.width * 0.56, size.height * 0.42)
        ..lineTo(size.width * 0.82, size.height * 0.72);

      canvas.drawPath(path, linePaint);

      final head = Path()
        ..moveTo(size.width * 0.88, size.height * 0.78)
        ..lineTo(size.width * 0.72, size.height * 0.73)
        ..lineTo(size.width * 0.83, size.height * 0.58)
        ..close();

      canvas.drawPath(head, headPaint);
    } else if (trend == _TrendDirection.flat) {
      final path = Path()
        ..moveTo(size.width * 0.12, size.height * 0.58)
        ..lineTo(size.width * 0.34, size.height * 0.46)
        ..lineTo(size.width * 0.54, size.height * 0.54)
        ..lineTo(size.width * 0.76, size.height * 0.38);

      canvas.drawPath(path, linePaint);

      final head = Path()
        ..moveTo(size.width * 0.86, size.height * 0.34)
        ..lineTo(size.width * 0.70, size.height * 0.34)
        ..lineTo(size.width * 0.78, size.height * 0.48)
        ..close();

      canvas.drawPath(head, headPaint);
    } else {
      final path = Path()
        ..moveTo(size.width * 0.08, size.height * 0.70)
        ..lineTo(size.width * 0.34, size.height * 0.48)
        ..lineTo(size.width * 0.56, size.height * 0.58)
        ..lineTo(size.width * 0.82, size.height * 0.28);

      canvas.drawPath(path, linePaint);

      final head = Path()
        ..moveTo(size.width * 0.88, size.height * 0.22)
        ..lineTo(size.width * 0.72, size.height * 0.26)
        ..lineTo(size.width * 0.83, size.height * 0.40)
        ..close();

      canvas.drawPath(head, headPaint);
    }

    canvas.drawCircle(
      Offset(size.width * 0.54, size.height * 0.47),
      size.width * 0.50,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TrendArrowPainter oldDelegate) {
    return oldDelegate.trend != trend || oldDelegate.color != color;
  }
}

class _RatePriceBlock extends StatelessWidget {
  final double value;
  final String label;
  final TextStyle style;
  final Color labelColor;

  const _RatePriceBlock({
    required this.value,
    required this.label,
    required this.style,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedPrice(value: value, style: style, fractionDigits: 1),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: labelColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyBadge extends StatelessWidget {
  final String flag;

  const _CurrencyBadge({required this.flag});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF20255A),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(flag, style: const TextStyle(fontSize: 20)),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF3D63F2) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x333D63F2),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppTheme.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  final String label;
  final IconData icon;

  const _NavItemData({required this.label, required this.icon});
}

class _RateItem {
  final String symbol;
  final String name;
  final double buy;
  final double sell;
  final String flag;
  final String inverseText;
  final _TrendDirection trend;

  const _RateItem({
    required this.symbol,
    required this.name,
    required this.buy,
    required this.sell,
    required this.flag,
    required this.inverseText,
    required this.trend,
  });
}

enum _TrendDirection { up, down, flat }

class _GreenDot extends StatelessWidget {
  const _GreenDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
