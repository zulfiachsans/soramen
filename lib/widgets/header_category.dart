import 'package:flutter/material.dart';
import 'package:test_fe_sora/utils/utils.dart';

class HeaderCategory extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;
  const HeaderCategory({
    required this.icon,
    required this.label,
    required this.color,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: selected ? color : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: selected
                    ? null
                    : Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : color,
                size: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: bodyfiveRegular.copyWith(color: Colors.white)),
      ],
    );
  }
}
