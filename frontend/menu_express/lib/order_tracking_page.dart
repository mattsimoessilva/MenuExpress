import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:provider/provider.dart';
import 'cookie_service.dart';
import 'package:collection/collection.dart';

import 'bottom_navigation_bar.dart';

class OrderTrackingPage extends StatefulWidget {
  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  List<dynamic> orders = [];

  final dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchUserOrders();
  }

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
      headers: {'Cookie': 'sessionid=$sessionId'},
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

  Future<void> fetchUserOrders() async {
    final customerId = await getCustomerId(context);
    print('customerId: ${customerId}');
    final url = Uri.parse('http://10.0.2.2:8000/user_orders/$customerId/');

    final response = await Dio().get(url.toString());

    print('Response data: ${response.data}'); // Imprime os dados da resposta

    if (response.statusCode == 200) {
      final data = response.data;
      setState(() {
        orders = data['orders'];
      });
    } else {
      print('Erro ao buscar os pedidos. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Text('Pedidos'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: orders.isNotEmpty
            ? ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index]['order'];
                  return ListTile(
                    title: Text('Pedido: ${order['id']}'),
                    subtitle: Text('Status: ${order['status']}'),
                    trailing: Text('Itens: ${orders[index]['items'].length}'),
                  );
                },
              )
            : Text(
                '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/menu');
          }
        },
      ),
    );
  }
}
