import 'package:flutter/material.dart';

import '../../../../core/cache/rates_cache.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../rates/data/rates_api_service.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final TextEditingController _amountController = TextEditingController(
    text: '1',
  );

  bool _isParallel = true;
  bool _loading = true;
  String? _error;

  List<_ConverterRate> _rates = const [];

  String _fromCurrency = 'DZD';
  String _toCurrency = 'EUR';

  @override
  void initState() {
    super.initState();
    _loadRates();
    _amountController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadRates() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final cache = _isParallel
        ? await RatesCache.loadParallel()
        : await RatesCache.loadOfficial();

    if (cache != null && cache.isNotEmpty && _rates.isEmpty && mounted) {
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
        _ensureValidSelections();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _ensureValidSelections();
        _loading = false;
        _error = _rates.isEmpty
            ? 'Impossible de charger les taux pour le moment.'
            : null;
      });
    }
  }

  List<_ConverterRate> _mapRows(List<Map<String, dynamic>> rows) {
    return rows
        .map(
          (row) => _ConverterRate(
            currency: (row['currency'] ?? '').toString().trim().toUpperCase(),
            name: (row['name'] ?? '').toString().trim(),
            buy: _toDouble(row['buy']),
            sell: _toDouble(row['sell']),
            flag: (row['flag'] ?? '💱').toString(),
          ),
        )
        .where((item) => item.currency.isNotEmpty)
        .toList();
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.')) ?? 0;
  }

  List<_CurrencyOption> get _currencyOptions {
    final options = <_CurrencyOption>[
      const _CurrencyOption(code: 'DZD', name: 'Algerian Dinar', flag: '🇩🇿'),
    ];

    final seen = <String>{'DZD'};

    for (final rate in _rates) {
      final code = rate.currency.trim().toUpperCase();
      if (code.isEmpty || seen.contains(code)) continue;

      options.add(
        _CurrencyOption(code: code, name: rate.name, flag: rate.flag),
      );
      seen.add(code);
    }

    return options;
  }

  void _ensureValidSelections() {
    final codes = _currencyOptions.map((e) => e.code).toSet();

    if (!codes.contains(_fromCurrency)) {
      _fromCurrency = 'DZD';
    }

    if (!codes.contains(_toCurrency) || _toCurrency == _fromCurrency) {
      _toCurrency = codes.contains('EUR') && _fromCurrency != 'EUR'
          ? 'EUR'
          : codes.firstWhere(
              (code) => code != _fromCurrency,
              orElse: () => 'DZD',
            );
    }
  }

  _ConverterRate? _findRate(String code) {
    final normalized = code.trim().toUpperCase();
    for (final rate in _rates) {
      if (rate.currency == normalized) return rate;
    }
    return null;
  }

  double? _convertAmount() {
    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );

    if (amount == null || amount < 0) return null;
    if (_fromCurrency == _toCurrency) return amount;

    final amountInDzd = _toDzd(amount, _fromCurrency);
    if (amountInDzd == null) return null;

    final converted = _fromDzd(amountInDzd, _toCurrency);
    return converted;
  }

  double? _toDzd(double amount, String fromCurrency) {
    if (fromCurrency == 'DZD') return amount;

    final rate = _findRate(fromCurrency);
    if (rate == null) return null;

    if (_isParallel) {
      if (rate.buy <= 0) return null;
      return amount * rate.buy;
    } else {
      if (rate.sell <= 0) return null;
      return amount * rate.sell;
    }
  }

  double? _fromDzd(double amountDzd, String toCurrency) {
    if (toCurrency == 'DZD') return amountDzd;

    final rate = _findRate(toCurrency);
    if (rate == null) return null;

    if (rate.sell <= 0) return null;
    return amountDzd / rate.sell;
  }

  String _formatResult(double? value) {
    if (value == null) return '--';
    if (value >= 1000) return value.toStringAsFixed(2);
    if (value >= 1) return value.toStringAsFixed(4);
    return value.toStringAsFixed(6);
  }

  @override
  Widget build(BuildContext context) {
    final convertedValue = _convertAmount();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Converter')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadRates,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
            children: [
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
                      child: _MarketButton(
                        label: 'Parallèle',
                        selected: _isParallel,
                        onTap: () {
                          if (_isParallel) return;
                          setState(() {
                            _isParallel = true;
                            _rates = const [];
                          });
                          _loadRates();
                        },
                      ),
                    ),
                    Expanded(
                      child: _MarketButton(
                        label: 'Officiel',
                        selected: !_isParallel,
                        onTap: () {
                          if (!_isParallel) return;
                          setState(() {
                            _isParallel = false;
                            _rates = const [];
                          });
                          _loadRates();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF171A33),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF272B4D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Montant',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Entrez un montant',
                        hintStyle: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0E1220),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: AppTheme.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: AppTheme.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: AppTheme.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (_loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primary,
                          ),
                        ),
                      )
                    else ...[
                      _CurrencySelector(
                        label: 'De',
                        value: _fromCurrency,
                        options: _currencyOptions,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _fromCurrency = value;
                            if (_toCurrency == _fromCurrency) {
                              _toCurrency = 'DZD';
                            }
                            _ensureValidSelections();
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              final oldFrom = _fromCurrency;
                              _fromCurrency = _toCurrency;
                              _toCurrency = oldFrom;
                              _ensureValidSelections();
                            });
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF212A57),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.cardBorder),
                            ),
                            child: const Icon(
                              Icons.swap_vert_rounded,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CurrencySelector(
                        label: 'Vers',
                        value: _toCurrency,
                        options: _currencyOptions,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _toCurrency = value;
                            if (_toCurrency == _fromCurrency) {
                              _fromCurrency = 'DZD';
                            }
                            _ensureValidSelections();
                          });
                        },
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1220),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Résultat',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_formatResult(convertedValue)} $_toCurrency',
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _isParallel
                                  ? 'Parallèle: devise → DZD au prix Achat, DZD → devise au prix Vente.'
                                  : 'Officiel: conversion calculée avec le taux officiel chargé.',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: Color(0xFFFF8A8A),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarketButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MarketButton({
    required this.label,
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
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrencySelector extends StatelessWidget {
  final String label;
  final String value;
  final List<_CurrencyOption> options;
  final ValueChanged<String?> onChanged;

  const _CurrencySelector({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF0E1220),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF171A33),
              iconEnabledColor: AppTheme.textPrimary,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              items: options.map((option) {
                return DropdownMenuItem<String>(
                  value: option.code,
                  child: Text(
                    '${option.flag}  ${option.code} - ${option.name}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrencyOption {
  final String code;
  final String name;
  final String flag;

  const _CurrencyOption({
    required this.code,
    required this.name,
    required this.flag,
  });
}

class _ConverterRate {
  final String currency;
  final String name;
  final double buy;
  final double sell;
  final String flag;

  const _ConverterRate({
    required this.currency,
    required this.name,
    required this.buy,
    required this.sell,
    required this.flag,
  });
}
