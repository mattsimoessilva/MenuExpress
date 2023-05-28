import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'menu_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.red.shade900, // Cor vermelha da barra superior
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Nome de usuário',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String username = usernameController.text;
                String password = passwordController.text;

                var response = await http.post(
                  Uri.parse('http://10.0.2.2:8000/login/'),
                  body: {
                    'username': username,
                    'password': password,
                  },
                );

                if (response.statusCode == 200) {
                  // Após a autenticação do usuário
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MenuPage()),
                    (route) => false, // Remove todas as rotas anteriores da pilha
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Erro de autenticação'),
                      content: const Text('Nome de usuário ou senha inválidos.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Fechar'),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red.shade900, // Cor vermelha do botão
              ),
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}

