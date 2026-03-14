import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  final TextEditingController _searchController = TextEditingController();

  static final List<_CryptoCoin> _allCoins = _buildCoins();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_CryptoCoin> get _filteredCoins {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _allCoins;

    return _allCoins.where((coin) {
      return coin.symbol.toLowerCase().contains(query) ||
          coin.name.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final coins = _filteredCoins;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Crypto',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111522),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppTheme.textSecondary,
                      ),
                      hintText: 'Rechercher une crypto',
                      hintStyle: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111522),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        color: AppTheme.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${coins.length} cryptos affichées',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Text(
                        'Design UI',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
              itemCount: coins.length,
              itemBuilder: (context, index) {
                final coin = coins[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _CryptoCard(coin: coin),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static List<_CryptoCoin> _buildCoins() {
    const baseCoins = [
      ['BTC', 'Bitcoin'],
      ['ETH', 'Ethereum'],
      ['USDT', 'Tether'],
      ['BNB', 'BNB'],
      ['XRP', 'XRP'],
      ['USDC', 'USDC'],
      ['SOL', 'Solana'],
      ['TRX', 'TRON'],
      ['DOGE', 'Dogecoin'],
      ['ADA', 'Cardano'],
      ['AVAX', 'Avalanche'],
      ['SHIB', 'Shiba Inu'],
      ['DOT', 'Polkadot'],
      ['LINK', 'Chainlink'],
      ['TON', 'Toncoin'],
      ['MATIC', 'Polygon'],
      ['LTC', 'Litecoin'],
      ['BCH', 'Bitcoin Cash'],
      ['XLM', 'Stellar'],
      ['ATOM', 'Cosmos'],
      ['ETC', 'Ethereum Classic'],
      ['UNI', 'Uniswap'],
      ['XMR', 'Monero'],
      ['HBAR', 'Hedera'],
      ['APT', 'Aptos'],
      ['NEAR', 'NEAR Protocol'],
      ['FIL', 'Filecoin'],
      ['ICP', 'Internet Computer'],
      ['ARB', 'Arbitrum'],
      ['OP', 'Optimism'],
      ['VET', 'VeChain'],
      ['MKR', 'Maker'],
      ['AAVE', 'Aave'],
      ['ALGO', 'Algorand'],
      ['QNT', 'Quant'],
      ['GRT', 'The Graph'],
      ['SAND', 'The Sandbox'],
      ['MANA', 'Decentraland'],
      ['AXS', 'Axie Infinity'],
      ['EGLD', 'MultiversX'],
      ['THETA', 'Theta Network'],
      ['EOS', 'EOS'],
      ['XTZ', 'Tezos'],
      ['FLOW', 'Flow'],
      ['KCS', 'KuCoin Token'],
      ['CHZ', 'Chiliz'],
      ['RUNE', 'THORChain'],
      ['CAKE', 'PancakeSwap'],
      ['KAVA', 'Kava'],
      ['SNX', 'Synthetix'],
      ['COMP', 'Compound'],
      ['CRV', 'Curve DAO'],
      ['1INCH', '1inch'],
      ['ENJ', 'Enjin Coin'],
      ['BAT', 'Basic Attention Token'],
      ['ZEC', 'Zcash'],
      ['DASH', 'Dash'],
      ['WOO', 'WOO'],
      ['LDO', 'Lido DAO'],
      ['PEPE', 'Pepe'],
      ['BONK', 'Bonk'],
      ['INJ', 'Injective'],
      ['SEI', 'Sei'],
      ['SUI', 'Sui'],
      ['TIA', 'Celestia'],
      ['JTO', 'Jito'],
      ['PYTH', 'Pyth Network'],
      ['JUP', 'Jupiter'],
      ['WIF', 'dogwifhat'],
      ['FLOKI', 'Floki'],
      ['BTT', 'BitTorrent'],
      ['KAS', 'Kaspa'],
      ['CRO', 'Cronos'],
      ['OKB', 'OKB'],
      ['LEO', 'LEO Token'],
      ['IMX', 'Immutable'],
      ['RNDR', 'Render'],
      ['FET', 'Fetch.ai'],
      ['AGIX', 'SingularityNET'],
      ['OCEAN', 'Ocean Protocol'],
      ['ROSE', 'Oasis Network'],
      ['MINA', 'Mina'],
      ['CFX', 'Conflux'],
      ['FTM', 'Fantom'],
      ['GALA', 'Gala'],
      ['DYDX', 'dYdX'],
      ['GMX', 'GMX'],
      ['BLUR', 'Blur'],
      ['SUPER', 'SuperVerse'],
      ['MASK', 'Mask Network'],
      ['YFI', 'yearn.finance'],
      ['ANKR', 'Ankr'],
      ['ZIL', 'Zilliqa'],
      ['HOT', 'Holo'],
      ['IOTA', 'IOTA'],
      ['RSR', 'Reserve Rights'],
      ['ONT', 'Ontology'],
      ['QTUM', 'Qtum'],
      ['CELO', 'Celo'],
      ['GLM', 'Golem'],
      ['SKL', 'SKALE'],
      ['WAXP', 'WAX'],
      ['SXP', 'Solar'],
      ['IOST', 'IOST'],
      ['ZEN', 'Horizen'],
      ['SC', 'Siacoin'],
      ['ICX', 'ICON'],
      ['ONE', 'Harmony'],
      ['KNC', 'Kyber Network'],
      ['STORJ', 'Storj'],
      ['UMA', 'UMA'],
      ['API3', 'API3'],
      ['LRC', 'Loopring'],
      ['BAL', 'Balancer'],
      ['TRB', 'Tellor'],
      ['SSV', 'SSV Network'],
      ['DYM', 'Dymension'],
      ['ALT', 'AltLayer'],
      ['PORTAL', 'Portal'],
      ['STRK', 'Starknet'],
      ['ZETA', 'ZetaChain'],
      ['MANTA', 'Manta Network'],
      ['ASTR', 'Astar'],
      ['CSPR', 'Casper'],
      ['ACH', 'Alchemy Pay'],
      ['CELR', 'Celer Network'],
      ['POLYX', 'Polymesh'],
      ['XNO', 'Nano'],
      ['HNT', 'Helium'],
      ['AUDIO', 'Audius'],
      ['CHR', 'Chromia'],
      ['RVN', 'Ravencoin'],
      ['MTL', 'Metal'],
      ['BICO', 'Biconomy'],
      ['HOOK', 'Hooked Protocol'],
      ['TWT', 'Trust Wallet Token'],
      ['CTSI', 'Cartesi'],
      ['PENDLE', 'Pendle'],
      ['ARKM', 'Arkham'],
      ['NTRN', 'Neutron'],
      ['OM', 'MANTRA'],
      ['ILV', 'Illuvium'],
      ['MAGIC', 'Magic'],
      ['METIS', 'Metis'],
      ['XAI', 'Xai'],
      ['RPL', 'Rocket Pool'],
      ['AERGO', 'Aergo'],
      ['ORDI', 'ORDI'],
      ['MEME', 'Memecoin'],
      ['SATS', 'SATS'],
      ['CKB', 'Nervos Network'],
      ['JOE', 'JOE'],
      ['MAV', 'Maverick Protocol'],
      ['WLD', 'Worldcoin'],
      ['TAO', 'Bittensor'],
      ['AKT', 'Akash Network'],
      ['STRAX', 'Stratis'],
      ['OSMO', 'Osmosis'],
      ['XEC', 'eCash'],
      ['DCR', 'Decred'],
      ['LSK', 'Lisk'],
      ['AR', 'Arweave'],
      ['COTI', 'COTI'],
      ['PHA', 'Phala Network'],
      ['NMR', 'Numeraire'],
      ['FLUX', 'Flux'],
      ['USTC', 'TerraClassicUSD'],
      ['LUNC', 'Terra Classic'],
      ['BABYDOGE', 'Baby Doge Coin'],
      ['TURBO', 'Turbo'],
      ['NOT', 'Notcoin'],
      ['PIXEL', 'Pixels'],
      ['ACE', 'Fusionist'],
      ['RENDER', 'Render'],
      ['GNO', 'Gnosis'],
      ['SUSHI', 'Sushi'],
      ['BAND', 'Band Protocol'],
      ['CTK', 'Shentu'],
      ['EDU', 'Open Campus'],
      ['RAY', 'Raydium'],
      ['MEW', 'cat in a dogs world'],
      ['NEO', 'NEO'],
      ['GAS', 'Gas'],
      ['WAVES', 'Waves'],
      ['KSM', 'Kusama'],
      ['MOVR', 'Moonriver'],
      ['GLMR', 'Moonbeam'],
      ['LSK2', 'Lisk 2'],
      ['ZRX', '0x'],
      ['MOG', 'Mog Coin'],
      ['BOME', 'BOOK OF MEME'],
      ['MYRO', 'Myro'],
      ['TNSR', 'Tensor'],
      ['ATH', 'Aethir'],
      ['OMNI', 'Omni Network'],
      ['REZ', 'Renzo'],
      ['ENA', 'Ethena'],
      ['ETHFI', 'ether.fi'],
      ['PRIME', 'Echelon Prime'],
      ['CFG', 'Centrifuge'],
      ['SCRT', 'Secret'],
      ['JASMY', 'JasmyCoin'],
      ['PNUT', 'Peanut the Squirrel'],
      ['GOAT', 'Goatseus Maximus'],
      ['POPCAT', 'Popcat'],
      ['BRETT', 'Brett'],
      ['CATI', 'Catizen'],
      ['HMSTR', 'Hamster Kombat'],
    ];

    final coins = <_CryptoCoin>[];

    for (var i = 0; i < baseCoins.length; i++) {
      final symbol = baseCoins[i][0];
      final name = baseCoins[i][1];

      if (i == 0) {
        coins.add(
          const _CryptoCoin(
            rank: 1,
            symbol: 'BTC',
            name: 'Bitcoin',
            marketCapText: '1,4 billions \$US',
            priceText: '70 112 \$US',
            changeText: '0.92%',
            isPositive: true,
          ),
        );
      } else if (i == 1) {
        coins.add(
          const _CryptoCoin(
            rank: 2,
            symbol: 'ETH',
            name: 'Ethereum',
            marketCapText: '248,293 Md \$US',
            priceText: '2 060,73 \$US',
            changeText: '1.96%',
            isPositive: true,
          ),
        );
      } else if (i == 2) {
        coins.add(
          const _CryptoCoin(
            rank: 3,
            symbol: 'USDT',
            name: 'Tether',
            marketCapText: '183,953 Md \$US',
            priceText: '0,999962 \$US',
            changeText: '–',
            isPositive: null,
          ),
        );
      } else if (i == 3) {
        coins.add(
          const _CryptoCoin(
            rank: 4,
            symbol: 'BNB',
            name: 'BNB',
            marketCapText: '88,691 Md \$US',
            priceText: '650,66 \$US',
            changeText: '1.49%',
            isPositive: true,
          ),
        );
      } else if (i == 4) {
        coins.add(
          const _CryptoCoin(
            rank: 5,
            symbol: 'XRP',
            name: 'XRP',
            marketCapText: '84,555 Md \$US',
            priceText: '1,38 \$US',
            changeText: '0.43%',
            isPositive: true,
          ),
        );
      } else if (i == 5) {
        coins.add(
          const _CryptoCoin(
            rank: 6,
            symbol: 'USDC',
            name: 'USDC',
            marketCapText: '78,791 Md \$US',
            priceText: '0,99991 \$US',
            changeText: '–',
            isPositive: null,
          ),
        );
      } else if (i == 6) {
        coins.add(
          const _CryptoCoin(
            rank: 7,
            symbol: 'SOL',
            name: 'Solana',
            marketCapText: '49,241 Md \$US',
            priceText: '86,32 \$US',
            changeText: '1.47%',
            isPositive: true,
          ),
        );
      } else if (i == 7) {
        coins.add(
          const _CryptoCoin(
            rank: 8,
            symbol: 'TRX',
            name: 'TRON',
            marketCapText: '27,497 Md \$US',
            priceText: '0,290221 \$US',
            changeText: '0.67%',
            isPositive: true,
          ),
        );
      } else {
        final rank = i + 1;
        final marketCap = (220.0 - (i * 0.87)).clamp(1.2, 220.0);
        final price = (1800.0 / (i + 2)).clamp(0.00012, 999.0);
        final changeBase = ((i % 9) - 4) * 0.38;

        final bool? isPositive;
        final String changeText;

        if (i % 11 == 0) {
          isPositive = null;
          changeText = '–';
        } else if (changeBase >= 0) {
          isPositive = true;
          changeText = '${changeBase.toStringAsFixed(2)}%';
        } else {
          isPositive = false;
          changeText = '${changeBase.abs().toStringAsFixed(2)}%';
        }

        coins.add(
          _CryptoCoin(
            rank: rank,
            symbol: symbol,
            name: name,
            marketCapText: '${marketCap.toStringAsFixed(3)} Md \$US',
            priceText: _formatUsdPrice(price),
            changeText: changeText,
            isPositive: isPositive,
          ),
        );
      }
    }

    return coins;
  }

  static String _formatUsdPrice(double value) {
    if (value >= 100) {
      return '${value.toStringAsFixed(2)} \$US';
    }
    if (value >= 1) {
      return '${value.toStringAsFixed(4)} \$US';
    }
    return '${value.toStringAsFixed(6)} \$US';
  }
}

class _CryptoCard extends StatelessWidget {
  final _CryptoCoin coin;

  const _CryptoCard({required this.coin});

  Color get _changeColor {
    if (coin.isPositive == null) return AppTheme.textMuted;
    return coin.isPositive! ? const Color(0xFFA8F28B) : const Color(0xFFFF7B7B);
  }

  IconData? get _changeIcon {
    if (coin.isPositive == null) return null;
    return coin.isPositive!
        ? Icons.north_east_rounded
        : Icons.south_east_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111522),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        children: [
          _CryptoIcon(symbol: coin.symbol),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${coin.name} (${coin.symbol})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B3145),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${coin.rank}',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        coin.marketCapText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 108,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  coin.priceText,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_changeIcon != null) ...[
                      Icon(_changeIcon, size: 16, color: _changeColor),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      coin.changeText,
                      style: TextStyle(
                        color: _changeColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CryptoIcon extends StatelessWidget {
  final String symbol;

  const _CryptoIcon({required this.symbol});

  String get _normalizedSymbol {
    final lower = symbol.toLowerCase();
    if (lower == 'render') return 'rndr';
    if (lower == 'lsk2') return 'lsk';
    return lower;
  }

  @override
  Widget build(BuildContext context) {
    final iconUrl = 'https://cryptoicons.org/api/icon/$_normalizedSymbol/200';

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF20255A),
        borderRadius: BorderRadius.circular(26),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        iconUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            alignment: Alignment.center,
            color: const Color(0xFF20255A),
            child: Text(
              symbol.length <= 4 ? symbol : symbol.substring(0, 4),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CryptoCoin {
  final int rank;
  final String symbol;
  final String name;
  final String marketCapText;
  final String priceText;
  final String changeText;
  final bool? isPositive;

  const _CryptoCoin({
    required this.rank,
    required this.symbol,
    required this.name,
    required this.marketCapText,
    required this.priceText,
    required this.changeText,
    required this.isPositive,
  });
}
