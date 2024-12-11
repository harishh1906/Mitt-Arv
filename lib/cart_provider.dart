import 'package:flutter/material.dart';
import 'cart_provider.dart';
import 'home_page.dart';
import 'product.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  // Get cart items
  List<Map<String, dynamic>> get cartItems => _cartItems;

  // Add product to cart
  void addToCart(Map<String, dynamic> product) {
    _cartItems.add(product);
    notifyListeners(); // Notify listeners (like CartPage) to update UI
  }

  // Remove product from cart
  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item['id'] == productId);
    notifyListeners();
  }

  // Get total price of all products in cart
  double get totalPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item['price'];
    }
    return total;
  }
}
