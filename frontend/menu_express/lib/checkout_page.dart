import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:menu_express/menu_page.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:provider/provider.dart';
import 'cookie_service.dart';
import 'dart:io';
import 'package:collection/collection.dart';

class CheckoutPage extends StatelessWidget {
  final double total;
  final List<dynamic> cartItems;

  final dio = Dio();

  CheckoutPage({
    Key? key,
    required this.total,
    required this.cartItems,
  }) : super(key: key);

  Future<int> getCustomerId(BuildContext context) async {
    final cookieService = Provider.of<CookieService>(context, listen: false);
    final cookieJar = cookieService.cookieJar;

    final uri = Uri.parse('http://10.0.2.2:8000/');
    final cookies = await cookieJar.loadForRequest(uri);
    final sessionCookie = cookies.firstWhereOrNull(
      (cookie) => cookie.name == 'sessionid',
    );
    final sessionId = sessionCookie?.value ?? 'N/A';
    print('Session ID: $sessionId');

    final url = Uri.parse('http://10.0.2.2:8000/current_customer_id/');
    
    final options = Options(
      headers: {'Cookie': 'sessionid=$sessionId'}, // Inserir o sessionId no header "Cookie"
    );
    
    final response = await dio.get(
      url.toString(),
      options: options,
    );

    print('Request headers: ${response.requestOptions.headers}');
    print('Request URL: ${response.requestOptions.uri}');

    final data = response.data;
    return data['customer_id'];
  }

  Future<void> registerOrder(BuildContext context) async {
    final customerId = await getCustomerId(context);
    final url = Uri.parse('http://10.0.2.2:8000/orders/');

    final orderData = {
      'customer': customerId,
      'status': 'PENDING', // Defina o status inicial como "PENDING"
      // Outros campos do pedido, se houver
    };

    try {
      final response = await dio.post(
        url.toString(),
        data: json.encode(orderData),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        // Pedido registrado com sucesso
        final responseData = json.decode(response.data);
        final orderId = responseData['id'];
        print('Pedido registrado com sucesso. ID do pedido: $orderId');
      } else {
        // Houve um erro ao registrar o pedido
        print('Erro ao registrar o pedido. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      // Houve um erro ao enviar a solicitação
      print('Erro ao enviar a solicitação: $e');
    }
}

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
              'assets/images/qr_code.jpeg',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
              ),
              onPressed: () async {
                await registerOrder(context);
                cartItems.clear(); // Limpa o carrinho
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage()),
                  (route) => false,
                );
              },
              child: const Text('Confirmar pagamento'),
            ),
          ],
        ),
      ),
    );
  }
}
