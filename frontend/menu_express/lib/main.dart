import 'package:flutter/material.dart';
import 'package:menu_express/menu_page.dart';
import 'package:menu_express/login_page.dart'; // Importe a página de login

void main() {
  runApp(const MenuExpressApp());
}

class MenuExpressApp extends StatelessWidget {
  const MenuExpressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MenuExpress',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Montserrat',
      ),
      initialRoute: '/', // Defina a rota inicial como '/'
      routes: {
        '/': (context) => const HomePage(), // Defina a rota para a página inicial
        '/menu': (context) => const MenuPage(),
        '/login': (context) => LoginPage(), // Adicione a rota para a página de login
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Estende o conteúdo atrás da AppBar
      appBar: AppBar(
        title: const Text(
          'MenuExpress',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Define a cor de fundo como transparente
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_image.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black.withOpacity(0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Bem-vindo ao MenuExpress',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Redirecione para a página de login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900, // Define um tom de vermelho escuro
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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
