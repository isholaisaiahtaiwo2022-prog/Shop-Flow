import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  final Set<int> favoriteIds = {};
  final Map<int, int> cartItems = {};

  AppState() {
    load();
  }

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final favoriteJson = preferences.getStringList('favoriteIds') ?? [];
    final cartJson = preferences.getString('cartItems');

    favoriteIds
      ..clear()
      ..addAll(favoriteJson.map(int.parse));

    cartItems.clear();
    if (cartJson != null && cartJson.isNotEmpty) {
      final decoded = jsonDecode(cartJson) as Map<String, dynamic>;
      decoded.forEach((key, value) {
        cartItems[int.parse(key)] = value as int;
      });
    }

    notifyListeners();
  }

  Future<void> toggleFavorite(int productId) async {
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }

    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      'favoriteIds',
      favoriteIds.map((id) => id.toString()).toList(),
    );
  }

  Future<void> addToCart(int productId) async {
    cartItems.update(productId, (quantity) => quantity + 1, ifAbsent: () => 1);
    await _saveCart();
  }

  Future<void> removeOneFromCart(int productId) async {
    if (!cartItems.containsKey(productId)) return;

    if (cartItems[productId]! <= 1) {
      cartItems.remove(productId);
    } else {
      cartItems.update(productId, (quantity) => quantity - 1);
    }

    await _saveCart();
  }

  Future<void> removeFromCart(int productId) async {
    cartItems.remove(productId);
    await _saveCart();
  }

  Future<void> clearCart() async {
    cartItems.clear();
    await _saveCart();
  }

  Future<void> _saveCart() async {
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      'cartItems',
      jsonEncode(
        cartItems.map((key, value) => MapEntry(key.toString(), value)),
      ),
    );
  }

  int get cartCount {
    return cartItems.values.fold(0, (total, quantity) => total + quantity);
  }
}
