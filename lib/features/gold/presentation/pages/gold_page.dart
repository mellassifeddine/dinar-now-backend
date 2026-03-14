import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class GoldPage extends StatefulWidget {
  const GoldPage({super.key});

  @override
  State<GoldPage> createState() => _GoldPageState();
}

class _GoldPageState extends State<GoldPage> {
  DateTime _lastUpdated = DateTime(2026, 3, 14, 1, 7);

  static const List<_GoldItem> _items = [
    _GoldItem(
      title: 'Or 18K',
      purity: '75%',
      purityColor: Color(0xFF9C7A3D),
      priceDzd: '28880 DZD',
    ),
    _GoldItem(
      title: 'Or 21K',
      purity: '87.5%',
      purityColor: Color(0xFFB08A40),
      priceDzd: '33700 DZD',
    ),
    _GoldItem(
      title: 'Or 24K',
      purity: '99.9%',
      purityColor: Color(0xFFD0A13B),
      priceDzd: '38510 DZD',
    ),
    _GoldItem(
      title: 'Or Cassé',
      purity: 'Cassé',
      purityColor: Color(0xFF7E5B46),
      priceDzd: '28300 DZD',
    ),
    _GoldItem(
      title: 'Or Cassé Or Italien',
      purity: 'Cassé',
      purityColor: Color(0xFF7E5B46),
      priceDzd: '28800 DZD',
    ),
  ];

  void _refresh() {
    setState(() {
      _lastUpdated = DateTime.now();
    });
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String get _formattedUpdatedAt {
    final d = _lastUpdated;
    return '${_twoDigits(d.day)}/${_twoDigits(d.month)}/${d.year} ${_twoDigits(d.hour)}:${_twoDigits(d.minute)}';
  }

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
                'Or',
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
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _refresh,
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF232948),
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(
                          color: const Color(0xFF39406A),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Color(0xFF7FA7FF),
                        size: 20,
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
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _GoldCard(item: item),
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

class _GoldCard extends StatelessWidget {
  final _GoldItem item;

  const _GoldCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF1D2047), Color(0xFF171B3C), Color(0xFF131733)],
        ),
        border: Border.all(color: const Color(0xFF272B4D), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const _GoldCoinIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    _PurityBadge(text: item.purity, color: item.purityColor),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'par gramme',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Prix',
                style: TextStyle(
                  color: Color(0xFFD7DAEA),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.priceDzd,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFF3C352),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoldCoinIcon extends StatelessWidget {
  const _GoldCoinIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFFFFEB9A), Color(0xFFE2B23B), Color(0xFF9B681D)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44E2B23B),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFFE08A), width: 1),
          gradient: const RadialGradient(
            colors: [Color(0xFFFFD86C), Color(0xFFD89A28), Color(0xFF8C5C17)],
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          '24K',
          style: TextStyle(
            color: Color(0xFF5B3800),
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _PurityBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _PurityBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final isBroken = color.value == const Color(0xFF7E5B46).value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.55), width: 0.8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isBroken ? const Color(0xFFD9B299) : const Color(0xFFFFD56E),
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _GoldItem {
  final String title;
  final String purity;
  final Color purityColor;
  final String priceDzd;

  const _GoldItem({
    required this.title,
    required this.purity,
    required this.purityColor,
    required this.priceDzd,
  });
}
