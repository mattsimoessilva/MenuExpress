import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final double total;

  final List<dynamic> cartItems;

  const CheckoutPage({required this.total, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Text('Checkout'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Scan QR Code',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Image.asset(
              'assets/images/qr_code.jpg', // substitua pelo caminho para o seu QR code
              width: 200,
              height: 200,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Coloque aqui a lógica para limpar o carrinho
                // Exemplo: chamar uma função que limpa o carrinho
                _limparCarrinho();

                // Redirecionar para a página de menu
                Navigator.pushReplacementNamed(context, '/menu');
              },
              child: Text('Confirmar pagamento'),
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


