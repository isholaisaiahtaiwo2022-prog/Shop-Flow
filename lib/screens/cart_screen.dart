import 'package:flutter/material.dart';
import 'package:jordan/model/product.dart';
import 'package:jordan/screens/checkout_screen.dart';
import 'package:jordan/services/app_state.dart';

class CartScreen extends StatelessWidget {
  final AppState appState;
  final List<Product> products;

  const CartScreen({super.key, required this.appState, required this.products});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        final cartProducts = products
            .where((product) => appState.cartItems.containsKey(product.id))
            .toList();
        final total = cartProducts.fold<double>(
          0,
          (sum, product) =>
              sum + product.price * appState.cartItems[product.id]!,
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF8F8F8),
          appBar: AppBar(
            title: const Text(
              'My Cart',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          body: cartProducts.isEmpty
              ? const Center(
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartProducts.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final product = cartProducts[index];
                          final quantity = appState.cartItems[product.id] ?? 0;

                          return Container(
                            height: 112,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(18),
                                  ),
                                  child: Image.network(
                                    product.imageUrl,
                                    width: 112,
                                    height: 112,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '\$${product.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: Color(0xFF149B58),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            _QuantityButton(
                                              icon: Icons.remove,
                                              onTap: () =>
                                                  appState.removeOneFromCart(
                                                    product.id,
                                                  ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              child: Text(
                                                '$quantity',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            _QuantityButton(
                                              icon: Icons.add,
                                              onTap: () => appState.addToCart(
                                                product.id,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      appState.removeFromCart(product.id),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutScreen(
                                  appState: appState,
                                  total: total,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Checkout  \$${total.toStringAsFixed(0)}',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F1F1),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Icon(icon, size: 18),
      ),
    );
  }
}
