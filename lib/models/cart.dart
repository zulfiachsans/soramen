import 'package:flutter/foundation.dart';
import 'package:test_fe_sora/models/sora.dart';

class Cart {
  Cart._private();
  static final Cart instance = Cart._private();

  final ValueNotifier<int> count = ValueNotifier<int>(0);
  final List<Map<String, dynamic>> items = [];

  void addItem({
    required Sora sora,
    String? variant,
    int variantPrice = 0,
    int packagingPrice = 0,
    String? packagingLabel,
    int quantity = 1,
  }) {
    items.add({
      'sora': sora,
      'variant': variant,
      'variantPrice': variantPrice,
      'packagingPrice': packagingPrice,
      'packagingLabel': packagingLabel,
      'quantity': quantity,
    });
    count.value = items.length;
  }

  void clear() {
    items.clear();
    count.value = 0;
  }

  Map<String, dynamic>? firstItem() {
    if (items.isEmpty) return null;
    return items.first;
  }
}
