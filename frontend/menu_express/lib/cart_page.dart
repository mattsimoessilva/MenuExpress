import 'package:flutter/material.dart';
import 'package:menu_express/checkout_page.dart';

class CartPage extends StatefulWidget {
  final List<dynamic> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in widget.cartItems) {
      final product = item['product'];
      totalPrice += double.parse(product['price'].toString());
    }
    return totalPrice;
  }

  void clearCart() {
    setState(() {
      widget.cartItems.clear();
    });

    final updatedCartItems = <dynamic>[];
    Navigator.pop(context, updatedCartItems); // Retorna a lista vazia ao limpar o carrinho
  }

  @override
  Widget build(BuildContext context) {
    final hasItemsInCart = widget.cartItems.isNotEmpty;
    final isCartEmpty = !hasItemsInCart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        backgroundColor: Colors.red.shade900,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final item = widget.cartItems[index]['product'];
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
              Row(
                children: [
                  ElevatedButton(
                    onPressed: isCartEmpty ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            total: calculateTotalPrice(),
                            cartItems: widget.cartItems.map((item) {
                              return {
                                'product': item['product'],
                                'quantity': widget.cartItems.length,
                              };
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCartEmpty ? Colors.grey : Colors.red.shade900,
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: hasItemsInCart ? clearCart : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCartEmpty ? Colors.grey : Colors.red.shade900,
                    ),
                    child: const Text(
                      'Limpar Carrinho',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
