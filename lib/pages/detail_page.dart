import 'package:flutter/material.dart';
import 'package:test_fe_sora/models/sora.dart';
import 'package:test_fe_sora/pages/detail_order.dart';
import 'package:test_fe_sora/utils/utils.dart';
import 'package:test_fe_sora/widgets/button_pressed.dart';

class DetailPage extends StatefulWidget {
  final Sora sora;
  const DetailPage({super.key, required this.sora});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _quantity = 1;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _inc() => setState(() => _quantity++);
  void _dec() => setState(() {
    if (_quantity > 1) _quantity--;
  });

  @override
  Widget build(BuildContext context) {
    final sora = widget.sora;
    final headerColor = sora.color ?? Colors.redAccent;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                // header with big image and controls
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.36,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: headerColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                      ),
                      // back button
                      Positioned(
                        left: 12,
                        top: 20,
                        child: Material(
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
                      ),
                      // three dots
                      Positioned(
                        right: 18,
                        top: 26,
                        child: Column(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Center(
                          child: Hero(
                            tag: 'sora-image-${sora.name}',
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: MediaQuery.of(context).size.width / 1.2,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  sora.imageUrl ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.broken_image,
                                    size: 80,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // content area - scrollable so keyboard doesn't overflow
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 20,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sora.name ?? '',
                                        style: bodyoneBold.copyWith(
                                          fontSize: 26,
                                        ),
                                        softWrap: true,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        sora.category ?? '',
                                        style: bodythreeMedium.copyWith(
                                          color: Colors.grey.shade300,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // variant badge
                                Container(
                                  width: 120,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.edit_note_outlined,
                                          color: secondaryColor,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Varian',
                                        style: bodyfiveMedium.copyWith(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rp ${sora.price ?? '0'}',
                                  style: bodyoneSemibold.copyWith(fontSize: 22),
                                ),
                                const SizedBox(width: 12),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: _dec,
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                    Text(
                                      '$_quantity',
                                      style: bodyoneSemibold.copyWith(
                                        fontSize: 18,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _inc,
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Text(
                              'About Produk',
                              style: bodyoneSemibold.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              sora.description ?? '-',
                              style: bodyfiveRegular.copyWith(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 12),

                            TextField(
                              controller: _noteController,
                              decoration: InputDecoration(
                                hintText: 'Catatan :',
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              maxLines: 3,
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ButtonPressed(
                                label: 'Pesan Ini',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => DetailOrder(sora: sora),
                                    ),
                                  );
                                },
                                color: secondaryColor,
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.33,
              left: MediaQuery.of(context).size.width * 0.7,
              right: 0,
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/maskotsoramenn_noshad.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
