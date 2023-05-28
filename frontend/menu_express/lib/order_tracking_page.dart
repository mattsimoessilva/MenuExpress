import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';

class OrderTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Text('Order Tracking'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Order Tracking Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // Navegar para outras telas com base no índice selecionado
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/menu');
          }
        },
      ),
    );
  }
}

