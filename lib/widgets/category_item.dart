import 'package:flutter/material.dart';
import 'package:test_fe_sora/models/sora.dart';
import 'package:test_fe_sora/utils/utils.dart';
import 'package:test_fe_sora/pages/detail_page.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(this.sora, {super.key});
  final Sora sora;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              reverseTransitionDuration: const Duration(milliseconds: 600),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DetailPage(sora: sora),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                // No additional transition here; Hero will animate over the route duration.
                return child;
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sora.name ?? 'Unknown',
                      style: bodyoneSemibold.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sora.description ?? 'No description',
                      style: bodyfiveRegular.copyWith(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${sora.price ?? '0'}',
                      style: bodyoneRegular.copyWith(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: sora.color ?? Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Hero(
                  tag: 'sora-image-${sora.name}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      sora.imageUrl ?? '',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
