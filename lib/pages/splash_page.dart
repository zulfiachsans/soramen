import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_fe_sora/utils/utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Welcome to', style: bodySplash),
              Image.asset('assets/images/maskotsoramenn.png', width: 200),
            ],
          ),
        ),
      ),
    );
  }
}
