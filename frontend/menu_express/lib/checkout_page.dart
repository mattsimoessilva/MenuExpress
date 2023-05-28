import 'package:flutter/material.dart';
import 'menu_page.dart';


class CheckoutPage extends StatelessWidget {
  final double total;

  final List<dynamic> cartItems;

  const CheckoutPage({super.key, required this.total, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: const Text('Checkout'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Scan QR Code',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/qr_code.jpeg', // substitua pelo caminho para o seu QR code
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
              ),
              onPressed: () {
                // Coloque aqui a lógica para limpar o carrinho
                // Exemplo: chamar uma função que limpa o carrinho
                _limparCarrinho();

                // Após o pagamento ser confirmado
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage()),
                  (route) => false, // Remove todas as rotas anteriores da pilha
                );
              },
              child: const Text('Confirmar pagamento'),
            ),
          ],
        ),
      ),
    );
  }

  void _limparCarrinho() {
    cartItems.clear();
  }
}


