import 'package:flutter/material.dart';
import 'package:test_fe_sora/utils/utils.dart';

class ButtonPressed extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final double? height;

  const ButtonPressed({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: bodyoneSemibold.copyWith(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
