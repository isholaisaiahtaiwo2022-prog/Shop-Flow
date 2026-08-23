import 'package:flutter/material.dart';
import 'package:jordan/model/product.dart';
import 'package:jordan/services/product_service.dart';
import 'package:jordan/widget/circle_icon_button.dart';
import 'package:jordan/widget/product_card.dart';
import 'package:jordan/widget/search_bar.dart' as app_widgets;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

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

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1000),
    );

    _loadProducts();
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
    final searchQuery = query.toLowerCase().trim();

    setState(() {
      _filteredProduct = _products.where((product) {
        return product.name.toLowerCase().contains(searchQuery) ||
            product.description.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  void dispose() {
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
            onTap: VoidCallbackAction(),
          ),
        ],
      ),
    );
  }
}

class _AnimatedProductCard extends StatelessWidget {
  final Product product;
  final int index;
  final Animation<double> animation;

  const _AnimatedProductCard({
    required this.product,
    required this.index,
    required this.animation,
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
        child: ProductCard(product: product),
      ),
    );
  }
}
