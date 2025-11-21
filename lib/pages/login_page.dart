import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_image.png',
              width: MediaQuery.of(context).size.width,
            ),
          ),

          // slight dark overlay for contrast
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.15)),
          ),

          // bottom sign-in card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
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
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Please, Sign in',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                    const SizedBox(height: 16),

                    // continue button (enabled only when form filled)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isFormFilled
                            ? () {
                                final name = _nameCtrl.text.trim();
                                final phone = _phoneCtrl.text.trim();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Lanjutkan: $name / $phone'),
                                  ),
                                );
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((
                            states,
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
                                states.contains(MaterialState.disabled) ? 0 : 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Lanjutkan',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _isFormFilled
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                            ),
                            if (_isFormFilled) ...[
                              const SizedBox(width: 12),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Text(
                      'Sekarang udah nggak jaman pakai nota kertas. Kami kirim nota pembelianmu realtime langsung ke nomor wa kamu.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
