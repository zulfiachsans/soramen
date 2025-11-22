import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_fe_sora/models/sora.dart';
import 'package:test_fe_sora/utils/utils.dart';
import 'package:test_fe_sora/widgets/category_item.dart';
import 'package:test_fe_sora/widgets/header_category.dart';
import 'package:test_fe_sora/models/cart.dart';
import 'package:test_fe_sora/pages/receipt_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Sora> _filtered = [];
  Timer? _debounce;
  bool _isLoading = false;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _filtered.addAll(soraList);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isLoading = true;
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _applyFilters();
    });
  }

  Color _colorFor(String cat) {
    switch (cat.toLowerCase()) {
      case 'food':
        return redColor;
      case 'drink':
        return Colors.cyan;
      case 'dessert':
        return purpleColor;
      case 'bento':
        return yellowColor;
      case 'topping':
        return primaryColor;
      case 'all':
        return primaryColor;
      default:
        return greyColor;
    }
  }

  IconData _iconFor(String cat) {
    switch (cat.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'drink':
        return Icons.local_drink;
      case 'dessert':
        return Icons.cake;
      case 'bento':
        return Icons.lunch_dining;
      case 'topping':
        return Icons.emoji_food_beverage;
      case 'all':
        return Icons.grid_view;
      default:
        return Icons.category;
    }
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    final selected = _selectedCategory;
    setState(() {
      _filtered.clear();
      final base = soraList.where((s) {
        if (selected != 'All' &&
            (s.category ?? '').toLowerCase() != selected.toLowerCase()) {
          return false;
        }
        if (query.isEmpty) return true;
        final name = s.name?.toLowerCase() ?? '';
        final cat = s.category?.toLowerCase() ?? '';
        final desc = s.description?.toLowerCase() ?? '';
        return name.contains(query) ||
            cat.contains(query) ||
            desc.contains(query);
      }).toList();
      _filtered.addAll(base);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // derive categories from the full sora data (keep 'All' first)
    final Set<String> _cats = {};
    for (final s in soraList) {
      if (s.category != null && s.category!.trim().isNotEmpty)
        _cats.add(s.category!.trim());
    }
    final List<String> categories = ['All', ..._cats.toList()];

    return Scaffold(
      backgroundColor: Colors.white,
      // floating shopping button
      floatingActionButton: ValueListenableBuilder<int>(
        valueListenable: Cart.instance.count,
        builder: (context, value, _) {
          if (value <= 0) return const SizedBox.shrink();
          final first = Cart.instance.firstItem();
          return FloatingActionButton(
            backgroundColor: secondaryColor,
            onPressed: () {
              // navigate to receipt using first cart item as source
              if (first == null) return;
              final sora = first['sora'] as dynamic;
              final variant = first['variant'] as String?;
              final variantPrice = first['variantPrice'] as int? ?? 0;
              final packagingPrice = first['packagingPrice'] as int? ?? 0;
              final packagingLabel = first['packagingLabel'] as String?;
              final quantity = first['quantity'] as int? ?? 1;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ReceiptPage(
                    sora: sora,
                    selectedVariant: variant,
                    basePrice:
                        int.tryParse(
                          (sora?.price ?? '0').toString().replaceAll('.', ''),
                        ) ??
                        0,
                    variantPrice: variantPrice,
                    packagingPrice: packagingPrice,
                    packagingLabel: packagingLabel,
                    quantity: quantity,
                    itemName: sora?.name,
                  ),
                ),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Center(
                  child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
                ),
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '$value',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // top green header with search and categories
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3.8,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // small circular logo placeholder
                            Container(
                              width: MediaQuery.of(context).size.width / 8,
                              child: Image.asset(
                                'assets/images/maskotsoramenn.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // larger centered search pill
                            Expanded(
                              child: Container(
                                height: 54,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Row(
                                  children: [
                                    // green circle magnifier
                                    const Icon(
                                      Icons.search,
                                      color: primaryColor,
                                      size: 30,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        controller: _searchController,
                                        style: bodytwoRegular.copyWith(
                                          color: Colors.grey.shade700,
                                        ),
                                        decoration: InputDecoration.collapsed(
                                          hintText: 'Cari produk..',
                                          hintStyle: bodytwoRegular.copyWith(
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (_isLoading) ...[
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // vertical three white dots
                            Container(
                              width: 28,
                              height: 44,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // category tabs (derived from filtered soraList)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 16),
                          child: Row(
                            children: [
                              const SizedBox(width: 4),
                              for (final cat in categories) ...[
                                HeaderCategory(
                                  icon: _iconFor(cat == 'All' ? 'all' : cat),
                                  label: cat,
                                  color: _colorFor(cat == 'All' ? 'all' : cat),
                                  selected:
                                      _selectedCategory.toLowerCase() ==
                                      cat.toLowerCase(),
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = cat;
                                      _isLoading = true;
                                    });
                                    // apply filters immediately (with small delay to show spinner briefly)
                                    Future.delayed(
                                      const Duration(milliseconds: 80),
                                      () {
                                        _applyFilters();
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(width: 14),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),
                    ],
                  ),
                ),

                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        bottom: 0,
                        left: 215,
                        right: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: ListView.separated(
                          itemCount: _filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 5),
                          itemBuilder: (context, index) {
                            return CategoryItem(_filtered[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
