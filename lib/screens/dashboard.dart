import 'package:flutter/material.dart';
import 'package:jordan/model/product.dart';
import 'package:jordan/screens/cart_screen.dart';
import 'package:jordan/screens/product_detail_screen.dart';
import 'package:jordan/services/app_state.dart';
import 'package:jordan/services/product_service.dart';
import 'package:jordan/widget/circle_icon_button.dart';
import 'package:jordan/widget/product_card.dart';
import 'package:jordan/widget/search_bar.dart' as app_widgets;

class Dashboard extends StatefulWidget {
  final AppState appState;

  const Dashboard({super.key, required this.appState});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final ProductService _productService = ProductService();

  final TextEditingController _searchController = TextEditingController();

  late AnimationController _animationController;

  List<Product> _products = [];
  List<Product> _filteredProduct = [];

  bool _isLoading = true;
  String _selectedCategory = 'All';
  String _sortOption = 'Default';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1000),
    );

    _loadProducts();
    widget.appState.addListener(_onAppStateChanged);
  }

  void _onAppStateChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadProducts() async {
    final products = await _productService.getProducts();

    if (!mounted) return;

    setState(() {
      _products = products;
      _filteredProduct = products;
      _isLoading = false;
    });

    _animationController.forward();
  }

  void _searchProducts(String query) {
    _applyFilters(query);
  }

  void _applyFilters([String? searchQuery]) {
    final query = (searchQuery ?? _searchController.text).toLowerCase().trim();

    final filtered = _products.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == 'All' ||
          product.name.toLowerCase().contains(
            _selectedCategory.toLowerCase(),
          ) ||
          (_selectedCategory == 'Adidas' &&
              product.name.toLowerCase().contains('addidas'));
      return matchesSearch && matchesCategory;
    }).toList();

    if (_sortOption == 'Price: Low to High') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortOption == 'Price: High to Low') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortOption == 'Name') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    setState(() {
      _filteredProduct = filtered;
    });
  }

  @override
  void dispose() {
    widget.appState.removeListener(_onAppStateChanged);
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [
            SliverToBoxAdapter(child: _buildSearchSection()),

            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_filteredProduct.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No Product Found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),

                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = _filteredProduct[index];

                    return _AnimatedProductCard(
                      product: product,
                      index: index,
                      animation: _animationController,
                      appState: widget.appState,
                    );
                  }, childCount: _filteredProduct.length),

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.67,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: app_widgets.SearchBar(
              controller: _searchController,
              onChanged: _searchProducts,
            ),
          ),
          const SizedBox(width: 12),
          CircleIconButton(
            size: 62,
            icon: Icons.tune_rounded,
            onTap: _showFilterSheet,
          ),
          const SizedBox(width: 12),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleIconButton(
                size: 62,
                icon: Icons.shopping_bag_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartScreen(
                        appState: widget.appState,
                        products: _products,
                      ),
                    ),
                  );
                },
              ),
              if (widget.appState.cartCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(
                      color: Color(0xFF149B58),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${widget.appState.cartCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter and sort',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Category',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', 'Nike', 'Adidas', 'Puma', 'New Balance']
                        .map((category) {
                          final selected = _selectedCategory == category;
                          return ChoiceChip(
                            label: Text(category),
                            selected: selected,
                            onSelected: (_) {
                              setSheetState(() {
                                _selectedCategory = category;
                              });
                            },
                          );
                        })
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Sort',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _sortOption,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items:
                        const [
                          'Default',
                          'Price: Low to High',
                          'Price: High to Low',
                          'Name',
                        ].map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setSheetState(() {
                        _sortOption = value;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _applyFilters();
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _AnimatedProductCard extends StatelessWidget {
  final Product product;
  final int index;
  final Animation<double> animation;
  final AppState appState;

  const _AnimatedProductCard({
    required this.product,
    required this.index,
    required this.animation,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.10).clamp(0.0, 0.6);

    final end = (start + 0.4).clamp(0.0, 1.0);

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: ProductCard(
          product: product,
          isFavorite: appState.favoriteIds.contains(product.id),
          onFavoriteTap: () => appState.toggleFavorite(product.id),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProductDetailScreen(product: product, appState: appState),
              ),
            );
          },
        ),
      ),
    );
  }
}
