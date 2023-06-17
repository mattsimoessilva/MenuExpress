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

    final responseData = jsonEncode(response.data);
    final data = json.decode(responseData);
    return data['customer_id'];
  }

  Future<int> createOrder(BuildContext context, int customerId) async {
    final url = Uri.parse('http://10.0.2.2:8000/orders/');

    final orderData = {
      'customer': customerId,
      'status': 'PENDING',
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
        final responseData = jsonEncode(response.data);
        final orderId = int.parse(json.decode(responseData)['id'].toString());
        print('Pedido criado com sucesso. ID do pedido: $orderId');
        return orderId;
      } else {
        print('Erro ao criar o pedido. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao enviar a solicitação: $e');
    }

    return -1;
  }

  Future<void> createOrderItems(int? orderId) async {
    if (orderId != null) {
      final url = Uri.parse('http://10.0.2.2:8000/orderitems/');

      for (var item in cartItems) {
        final orderItemData = {
          'order': orderId,
          'product': item['product']['id'],
          'quantity': cartItems.length,
        };

        print(orderItemData);

        try {
          await dio.post(
            url.toString(),
            data: json.encode(orderItemData),
            options: Options(
              headers: {'Content-Type': 'application/json'},
            ),
          );
        } catch (e) {
          print('Erro ao criar o item de pedido: $e');
        }
      }
    }
  }

  Future<void> registerOrder(BuildContext context) async {
    final customerId = await getCustomerId(context);
    final orderId = await createOrder(context, customerId);

    if (orderId != -1) {
      await createOrderItems(orderId);

      cartItems.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MenuPage()),
        (route) => false,
      );
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
              'Escaneie o QR Code',
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
              },
              child: const Text('Confirmar pagamento'),
            ),
          ],
        ),
      ),
    );
  }
}
