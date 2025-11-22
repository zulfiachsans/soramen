import 'package:flutter/material.dart';
import 'package:test_fe_sora/models/sora.dart';
import 'package:test_fe_sora/pages/success_payment.dart';
import 'package:test_fe_sora/utils/utils.dart';
import 'package:test_fe_sora/models/cart.dart';

class ReceiptPage extends StatefulWidget {
  final Sora sora;
  final String? selectedVariant;
  final int? basePrice;
  final int? variantPrice;
  final int? packagingPrice;
  final String? packagingLabel;
  final int? quantity;
  final String? itemName;

  const ReceiptPage({
    super.key,
    required this.sora,
    this.selectedVariant,
    this.basePrice,
    this.variantPrice,
    this.packagingPrice,
    this.packagingLabel,
    this.quantity,
    this.itemName,
  });

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  int? _selectedTable;

  Future<void> _showTablePicker() async {
    final picked = await showDialog<int>(
      context: context,
      builder: (context) {
        int tempSelected = _selectedTable ?? -1;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 4),
                        Text('Nomor Meja', style: bodytwoSemibold),
                        const Spacer(),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.table_restaurant,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(15, (i) {
                        final num = i + 1;
                        final isSelected = tempSelected == num;
                        return GestureDetector(
                          onTap: () => setState(() => tempSelected = num),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? secondaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: secondaryColor,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              '$num',
                              style: isSelected
                                  ? bodyoneBold.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                    )
                                  : bodythreeSemibold.copyWith(
                                      color: secondaryColor,
                                      fontSize: 14,
                                    ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(
                          context,
                        ).pop(tempSelected > 0 ? tempSelected : null),
                        child: Text(
                          'Pilih',
                          style: bodyoneBold.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    if (picked != null && picked > 0) setState(() => _selectedTable = picked);
  }

  String _formatCurrency(int value) {
    final s = value.toString();
    final reg = RegExp(r"\B(?=(\d{3})+(?!\d))");
    return 'Rp ${s.replaceAllMapped(reg, (m) => '.')}';
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = Cart.instance.items;

    int calculateBasePrice(Sora s) =>
        int.tryParse(s.price?.replaceAll('.', '') ?? '') ?? 0;

    int jumlah = 0;
    List<Map<String, dynamic>> displayItems = [];

    if (cartItems.isNotEmpty) {
      for (final it in cartItems) {
        final Sora s = it['sora'] as Sora;
        final int variantPrice = (it['variantPrice'] as int?) ?? 0;
        final int packagingPrice = (it['packagingPrice'] as int?) ?? 0;
        final int qty = (it['quantity'] as int?) ?? 1;
        final int base = calculateBasePrice(s);
        final int unit = base + variantPrice + packagingPrice;
        final int lineTotal = unit * qty;
        jumlah += lineTotal;
        displayItems.add({
          'sora': s,
          'variant': it['variant'] as String?,
          'variantPrice': variantPrice,
          'packagingLabel': it['packagingLabel'] as String?,
          'packagingPrice': packagingPrice,
          'quantity': qty,
          'unit': unit,
          'lineTotal': lineTotal,
        });
      }
    } else {
      final base = widget.basePrice ?? 0;
      final variant = widget.variantPrice ?? 0;
      final packaging = widget.packagingPrice ?? 0;
      final qty = widget.quantity ?? 1;
      final itemPerUnit = base + variant + packaging;
      final lineTotal = itemPerUnit * qty;
      jumlah = lineTotal;
      displayItems.add({
        'sora': widget.sora,
        'variant': widget.selectedVariant,
        'variantPrice': variant,
        'packagingLabel': widget.packagingLabel,
        'packagingPrice': packaging,
        'quantity': qty,
        'unit': itemPerUnit,
        'lineTotal': lineTotal,
      });
    }

    final ppn = (jumlah * 11 / 100).round();
    final subtotal = jumlah + ppn;
    final pembulatan = ((subtotal + 99) ~/ 100) * 100;
    final total = pembulatan;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60, left: edge, right: edge),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(22),
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
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Nota Pesanan',
                            style: bodyoneSemibold.copyWith(fontSize: 20),
                          ),
                          const SizedBox(height: 6),
                          if (_selectedTable != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.table_restaurant,
                                        size: 16,
                                        color: Colors.black87,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'MEJA $_selectedTable',
                                        style: bodyfourRegular,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: _showTablePicker,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.table_restaurant,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        // scrollable list of items
                        Expanded(
                          child: ListView.builder(
                            itemCount: displayItems.length,
                            itemBuilder: (context, idx) {
                              final it = displayItems[idx];
                              final Sora s = it['sora'] as Sora;
                              final String? variant = it['variant'] as String?;
                              final int variantPrice =
                                  it['variantPrice'] as int? ?? 0;
                              final String? packagingLabel =
                                  it['packagingLabel'] as String?;
                              final int packagingPrice =
                                  it['packagingPrice'] as int? ?? 0;
                              final int qty = it['quantity'] as int? ?? 1;
                              final int unit = it['unit'] as int? ?? 0;
                              final int lineTotal =
                                  it['lineTotal'] as int? ?? 0;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (s.imageUrl != null &&
                                        s.imageUrl!.isNotEmpty)
                                      Center(
                                        child: Image.asset(
                                          s.imageUrl!,
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width /
                                              5,
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    Text(
                                      s.name ?? 'Menu Item',
                                      style: bodytwoSemibold.copyWith(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Harga',
                                          style: bodyoneSemibold.copyWith(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          _formatCurrency(unit),
                                          style: bodyfourRegular,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    if (variant != null) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              variant,
                                              style: bodyoneSemibold.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            _formatCurrency(variantPrice),
                                            style: bodyfourRegular,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                    ],
                                    if (packagingLabel != null &&
                                        packagingPrice > 0) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              packagingLabel,
                                              style: bodyoneSemibold.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            _formatCurrency(packagingPrice),
                                            style: bodyfourRegular,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                    ],
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Jumlah',
                                          style: bodyoneSemibold.copyWith(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text('$qty', style: bodyfourRegular),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Subtotal',
                                          style: bodyfourRegular,
                                        ),
                                        Text(
                                          _formatCurrency(lineTotal),
                                          style: bodyfourRegular,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Divider(color: Color(0xFFEEEEEE)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 12),

                        // totals below
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Jumlah', style: bodyfourRegular),
                                Text(
                                  _formatCurrency(jumlah),
                                  style: bodyfourRegular,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('PPN 11%', style: bodyfourRegular),
                                Text(
                                  _formatCurrency(ppn),
                                  style: bodyfourRegular,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Subtotal', style: bodyfourRegular),
                                Text(
                                  _formatCurrency(subtotal),
                                  style: bodyfourRegular,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pembulatan', style: bodyfourRegular),
                                Text(
                                  _formatCurrency(pembulatan),
                                  style: bodyfourRegular,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('TOTAL', style: bodyoneBold),
                                Text(
                                  _formatCurrency(total),
                                  style: bodyoneBold,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: secondaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          SuccessPayment(total: total),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Bayar',
                                  style: bodyoneBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: greyColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  Cart.instance.clear();
                                  Navigator.of(
                                    context,
                                  ).popUntil((r) => r.isFirst);
                                },
                                child: Text(
                                  'Batalkan Pesanan',
                                  style: bodyoneBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
