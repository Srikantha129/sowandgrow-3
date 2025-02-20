import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems.toList();

  double get totalCartPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  void addToCart(CartItem item) {
    final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity++;
    } else {
      _cartItems.add(item.copyWith(quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _cartItems.removeWhere((cartItem) => cartItem.id == item.id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void updateQuantity(String id, int newQuantity) {
    final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.id == id);
    if (existingIndex >= 0) {
      // Update quantity only if it's a valid value (non-negative)
      if (newQuantity >= 0) {
        _cartItems[existingIndex].quantity = newQuantity;
      }
    }
    notifyListeners();
  }
}
