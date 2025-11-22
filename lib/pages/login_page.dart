import 'package:flutter/material.dart';
import 'package:test_fe_sora/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  bool _isFormFilled = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_validateForm);
    _phoneCtrl.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameCtrl.removeListener(_validateForm);
    _phoneCtrl.removeListener(_validateForm);
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _validateForm() {
    final filled =
        _nameCtrl.text.trim().isNotEmpty && _phoneCtrl.text.trim().isNotEmpty;
    if (filled != _isFormFilled) setState(() => _isFormFilled = filled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/login_image.png',
            width: MediaQuery.of(context).size.width,

            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.08,
              left: 20,
            ),
            child: Image.asset(
              'assets/images/maskotsoramenn.png',
              width: MediaQuery.of(context).size.width / 5,
              fit: BoxFit.cover,
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              padding: EdgeInsets.fromLTRB(20, 18, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Text('Please, Sign in', style: bodyoneBold),
                        const SizedBox(height: 12),
                        // name field
                        TextField(
                          controller: _nameCtrl,
                          decoration: InputDecoration(
                            hintText: 'Masukkan nama',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // phone field with whatsapp icon on left
                        TextField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Nomor handphone (WA)',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            prefixIcon: Container(
                              width: 48,
                              height: 48,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.phone_android,
                                color: Colors.green,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // continue button (enabled only when form filled)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isFormFilled
                                ? () {
                                    final name = _nameCtrl.text.trim();
                                    final phone = _phoneCtrl.text.trim();
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/home',
                                    );
                                  }
                                : null,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((
                                    Set<MaterialState> states,
                                  ) {
                                    if (states.contains(MaterialState.disabled))
                                      return Colors.grey.shade300;
                                    return const Color(0xFF6DDF2B);
                                  }),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              elevation: MaterialStateProperty.resolveWith(
                                (states) =>
                                    states.contains(MaterialState.disabled)
                                    ? 0.0
                                    : 2.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Lanjutkan',
                                  style: bodyoneBold.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: _isFormFilled
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                                if (_isFormFilled) ...[
                                  const SizedBox(width: 12),
                                ],
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            // Style default untuk seluruh TextSpan jika tidak ditentukan
                            style: bodyoneSemibold.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            children: <TextSpan>[
                              // Bagian 1: Teks Hitam
                              TextSpan(
                                text:
                                    'Sekarang udah nggak jaman pakai nota kertas. Kami kirim ',
                              ),

                              // Bagian 2: Teks MERAH (yang Anda minta)
                              TextSpan(
                                text: 'nota pembelian',
                                style: const TextStyle(color: redColor),
                              ),

                              // Bagian 3: Teks Hitam
                              TextSpan(
                                text: 'mu realtime langsung ke nomor WA kamu.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // floating badge: switch between wait and lets-go when form filled
          Positioned(
            right: 28,
            bottom: MediaQuery.of(context).size.height * 0.45 - 50,
            child: SizedBox(
              width: 90,
              height: 90,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: _isFormFilled
                    ? Image.asset(
                        'assets/images/letsgo_badge.png',
                        key: const ValueKey('letsgo'),
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Lets\nGo',
                                textAlign: TextAlign.right,
                                style: bodyoneBold.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Image.asset(
                        'assets/images/wait_badge.png',
                        key: const ValueKey('wait'),
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: greyColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Wa\nit',
                                  textAlign: TextAlign.right,
                                  style: bodyoneBold.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '!',
                                  textAlign: TextAlign.right,
                                  style: bodyoneBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
