import 'package:flutter/material.dart';

class CartItemsProvider extends ChangeNotifier {
  List<dynamic> cartItems = [];

  int get itemCount => cartItems.length;

  void addToCart(dynamic product) {
    final item = {
      'id': product['id'], // Adicione o ID do produto
      'product': product, // Adicione o produto
    };
    cartItems.add(item);
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }
}
