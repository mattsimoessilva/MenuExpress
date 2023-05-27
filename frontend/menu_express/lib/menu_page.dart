import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product_details_page.dart';
import 'cart_page.dart';
import 'order_tracking_page.dart';
import 'bottom_navigation_bar.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<dynamic> products = [];
  List<dynamic> cartItems = [];
  int _currentIndex = 0;

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/products/'));
    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);
      });
    }
  }

  void addToCart(dynamic product) {
    setState(() {
      cartItems.add(product);
    });
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += double.parse(item['price']);
    }
    return totalPrice;
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final aspectRatio = screenWidth / screenHeight;

    final crossAxisCount = aspectRatio > 1.41 ? 4 : 3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: const Text('Menu'),
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(product: product),
                ),
              );
            },
            child: Container(
              // Restante do código
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderTrackingPage()),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(cartItems: cartItems),
            ),
          );
        },
        backgroundColor: Colors.red.shade900,
        icon: const Icon(Icons.shopping_cart),
        label: Text('Cart (${cartItems.length})'),
      ),
    );
  }
}
