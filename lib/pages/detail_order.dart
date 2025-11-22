import 'package:flutter/material.dart';
import 'package:test_fe_sora/models/sora.dart';
import 'package:test_fe_sora/pages/detail_page.dart';
import 'package:test_fe_sora/models/cart.dart';
import 'package:test_fe_sora/utils/utils.dart';
import 'package:test_fe_sora/widgets/button_pressed.dart';

class DetailOrder extends StatefulWidget {
  final Sora sora;
  const DetailOrder({super.key, required this.sora});

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  int _selectedVariant = -1;
  final int _packagingPrice = 2000;
  int _orderType = 0; // 0 = eat-in (Makan sini), 1 = takeaway (Dibungkus)

  // sample variants; in a real app variants may come from the model/backend
  final List<Map<String, dynamic>> _variants = [
    {'title': 'Pedas level 1', 'price': 3000},
    {'title': 'Pedas level 2', 'price': 4000},
    {'title': 'Pedas level 3', 'price': 4000},
  ];

  int _priceBase() {
    final p = int.tryParse(widget.sora.price?.replaceAll('.', '') ?? '') ?? 0;
    return p;
  }

  int _selectedVariantPrice() {
    // kept for backward compatibility but not used now
    if (_selectedVariant >= 0 && _selectedVariant < _variants.length) {
      return _variants[_selectedVariant]['price'] as int;
    }
    return 0;
  }

  String _formatCurrency(int value) {
    final s = value.toString();
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    final sora = widget.sora;
    final base = _priceBase();

    // decide effective variants based on category
    final cat = (sora.category ?? '').toLowerCase();
    final bool isDrink = cat.contains('minum') || cat.contains('drink');
    final bool isDessert = cat.contains('dessert');

    final List<Map<String, dynamic>> effectiveVariants;
    if (isDessert) {
      effectiveVariants = [];
    } else if (isDrink) {
      effectiveVariants = [
        {'title': 'Dengan Es', 'price': 2000},
        {'title': 'Tanpa Es', 'price': 1000},
      ];
    } else {
      effectiveVariants = _variants;
    }

    // ensure selected variant index is valid for effectiveVariants
    if (_selectedVariant >= effectiveVariants.length) {
      _selectedVariant = -1;
    }

    final variantPrice = _selectedVariant >= 0
        ? (effectiveVariants[_selectedVariant]['price'] as int)
        : 0;
    final packaging = _orderType == 1 ? _packagingPrice : 0;
    final total = base + variantPrice + packaging;

    final packagingLabel = (_orderType == 1 && isDrink) ? 'Plastik' : 'Mika';

    return Scaffold(
      backgroundColor: sora.color ?? Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60, left: edge, right: edge),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Image.asset('assets/images/maskotsoramenn.png', width: 50),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 150),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    sora.name ?? '',
                    style: bodyoneSemibold.copyWith(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 16),

                // price summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Harga', style: bodyfiveMedium),
                    Text(
                      'Rp ${_formatCurrency(base)}',
                      style: bodyfiveMedium.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(),

                // show selected variant (if any) under Harga
                if (_selectedVariant >= 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        effectiveVariants[_selectedVariant]['title'] as String,
                        style: bodyfiveMedium,
                      ),
                      Text(
                        'Rp ${_formatCurrency(effectiveVariants[_selectedVariant]['price'] as int)}',
                        style: bodyfiveMedium.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(),
                ],

                // packaging price when 'Dibungkus' selected
                if (_orderType == 1) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(packagingLabel, style: bodyfiveMedium),
                      Text(
                        'Rp ${_formatCurrency(_packagingPrice)}',
                        style: bodyfiveMedium.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(),
                ],

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: bodyoneSemibold),
                    Text(
                      'Rp ${_formatCurrency(total)}',
                      style: bodyoneSemibold.copyWith(color: Colors.red),
                    ),
                  ],
                ),
                const Divider(),

                const SizedBox(height: 12),
                Text(
                  'Pilih varian',
                  style: bodyoneSemibold.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 8),

                // variants as radio buttons (only show if available)
                if (effectiveVariants.isNotEmpty) ...[
                  ...List.generate(effectiveVariants.length, (i) {
                    final v = effectiveVariants[i];
                    return Column(
                      children: [
                        RadioListTile<int>(
                          value: i,
                          groupValue: _selectedVariant,
                          activeColor: secondaryColor,
                          onChanged: (val) =>
                              setState(() => _selectedVariant = val ?? -1),
                          title: Text(v['title'] as String),
                          secondary: Text(
                            'Rp ${_formatCurrency(v['price'] as int)}',
                          ),
                        ),
                        const Divider(height: 1),
                      ],
                    );
                  }),
                ],

                const SizedBox(height: 16),

                // order type toggle (Makan sini / Dibungkus)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _orderType = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _orderType == 0
                              ? secondaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.restaurant,
                              color: _orderType == 0
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Makan sini',
                              style: bodyfiveMedium.copyWith(
                                color: _orderType == 0
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => setState(() => _orderType = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _orderType == 1
                              ? secondaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              color: _orderType == 1
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Dibungkus',
                              style: bodyfiveMedium.copyWith(
                                color: _orderType == 1
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                const Spacer(),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ButtonPressed(
                        label: 'Tambahkan',
                        color: secondaryColor,
                        onPressed: () {
                          final variantTitle =
                              (_selectedVariant >= 0 &&
                                  _selectedVariant < effectiveVariants.length)
                              ? (effectiveVariants[_selectedVariant]['title']
                                    as String)
                              : null;

                          // show a temporary popup indicating item added with floating icon and count
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 140,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // white rounded card with message
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.8,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.15,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(width: 68),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Item berhasil ditambahkan',
                                                      style: bodyoneSemibold,
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      variantTitle ??
                                                          (sora.name ?? ''),
                                                      style: bodyfourRegular,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // floating item icon with count badge
                                      Positioned(
                                        top: 0,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              width: 68,
                                              height: 68,
                                              decoration: BoxDecoration(
                                                color: secondaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.check_sharp,
                                                  color: Colors.white,
                                                  size: 34,
                                                ),
                                              ),
                                            ),
                                            // count badge
                                            Positioned(
                                              right: -6,
                                              top: -6,
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '1',
                                                    style: bodyoneBold.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                          // after a short delay, add to cart, dismiss popup and return to Home
                          Future.delayed(const Duration(milliseconds: 700), () {
                            // add item to shared cart
                            Cart.instance.addItem(
                              sora: sora,
                              variant: variantTitle,
                              variantPrice: variantPrice,
                              packagingPrice: packaging,
                              packagingLabel: packagingLabel,
                              quantity: 1,
                            );

                            // dismiss dialog
                            if (Navigator.of(context).canPop())
                              Navigator.of(context).pop();

                            // pop back to the first route (home)
                            Navigator.of(context).popUntil((r) => r.isFirst);
                          });
                        },
                        height: 56,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ButtonPressed(
                        label: 'Batal',
                        color: const Color(0xFF726B6B),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailPage(sora: widget.sora),
                            ),
                          );
                        },
                        height: 56,
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
