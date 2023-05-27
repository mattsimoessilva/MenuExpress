import 'package:flutter/material.dart';
import 'package:menu_express/checkout_page.dart';

class CartPage extends StatelessWidget {
  final List<dynamic> cartItems;

  const CartPage({super.key, required this.cartItems});

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += double.parse(item['price'].toString());
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.red.shade900,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('\$${item['price']}'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${calculateTotalPrice().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutPage(total: calculateTotalPrice(), cartItems: cartItems)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900, // Definir a cor de fundo como vermelho
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white, // Definir a cor do texto como branco
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
