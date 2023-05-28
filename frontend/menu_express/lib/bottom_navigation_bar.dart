import 'package:flutter/material.dart';
import 'order_tracking_page.dart'; // Importe o arquivo order_tracking_page.dart

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key, // Corrigido o parâmetro key
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key); // Corrigido o parâmetro key no construtor

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.red.shade900,
      selectedItemColor: Colors.white,
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.track_changes),
          label: 'Order Tracking',
        ),
      ],
      onTap: onTap,
    );
  }
}

