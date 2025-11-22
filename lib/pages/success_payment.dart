import 'package:flutter/material.dart';
import 'package:test_fe_sora/models/cart.dart';
import 'package:test_fe_sora/utils/utils.dart';

class SuccessPayment extends StatelessWidget {
  final int total;

  const SuccessPayment({Key? key, this.total = 0}) : super(key: key);

  String _formatRupiah(int amount) {
    final s = amount.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return 'Rp ' + s.replaceAllMapped(reg, (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 90),
            // small logo at top
            Center(
              child: Image.asset(
                'assets/images/maskotsoramenn.png',
                width: 72,
                height: 72,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Pesanan terkirim',
              style: headingoneSemibold.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 80),

            // Green rounded card area
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 36,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 90),
                        Text(
                          'Silahkan bayar pesanan\nkamu di kasir!',
                          textAlign: TextAlign.center,
                          style: bodyoneSemibold.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(
                          color: Colors.white70,
                          thickness: 1,
                          indent: 24,
                          endIndent: 24,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'TOTAL :',
                          style: bodytwoSemibold.copyWith(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatRupiah(total),
                          style: headingoneBold.copyWith(
                            color: Colors.white,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(
                          color: Colors.white70,
                          thickness: 1,
                          indent: 24,
                          endIndent: 24,
                        ),
                        const SizedBox(height: 28),
                        // Beranda button
                        SizedBox(
                          width: size.width * 0.6,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Cart.instance.clear();
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
                            },
                            child: Text(
                              'Beranda',
                              style: bodyoneSemibold.copyWith(
                                color: secondaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Mascot circle overlapping top of green area
                  Positioned(
                    top: -60,
                    left: (size.width / 2) - 72,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 150,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'assets/images/logoKasir.png',
                          width: 40,
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
  }
}
