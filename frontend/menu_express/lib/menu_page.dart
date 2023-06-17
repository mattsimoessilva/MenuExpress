import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product_details_page.dart';
import 'cart_page.dart';
import 'checkout_page.dart';
import 'order_tracking_page.dart';
import 'bottom_navigation_bar.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<dynamic> products = [];
  List<dynamic> cartItems = [];

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
      final item = {
        'id': product['id'], // Adicione o ID do produto
        'product': product, // Adicione o produto
      };
      cartItems.add(item);
    });
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      final product = item['product'];
      totalPrice += double.parse(product['price'].toString());
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
        title: Text('Cardápio'),
        automaticallyImplyLeading: false, // Oculta a seta de navegação
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.60,
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        product['image_path'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '\$${product['price']}',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Item adicionado ao carrinho'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text(
                        'Adicionar ao Carrinho',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/order_tracking');
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final updatedCartItems = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(cartItems: cartItems),
            ),
          );
          if (updatedCartItems != null) {
            setState(() {
              cartItems = updatedCartItems;
            });
          }
        },
        backgroundColor: Colors.red.shade900,
        icon: Icon(Icons.shopping_cart),
        label: Text('Carrinho (${cartItems.length})'),
      ),
    );
  }
}
