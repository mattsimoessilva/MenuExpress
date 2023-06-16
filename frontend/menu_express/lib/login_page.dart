import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:menu_express/menu_page.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:provider/provider.dart';
import 'cookie_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final dio = Dio();

  @override
  Widget build(BuildContext context) {
    final cookieService = Provider.of<CookieService>(context, listen: false);
    final cookieJar = cookieService.cookieJar;
    dio.interceptors.add(CookieManager(cookieJar));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.red.shade900,
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

                var response = await dio.post(
                  'http://10.0.2.2:8000/login/',
                  data: {
                    'username': username,
                    'password': password,
                  },
                );

                // Get the cookies from the response headers
                final cookies = response.headers['set-cookie'];

                // Parse and store the cookies in the CookieJar
                if (cookies != null) {
                  for (var cookie in cookies) {
                    cookieJar.saveFromResponse(
                      Uri.parse('http://10.0.2.2:8000/'),
                      [Cookie.fromSetCookieValue(cookie)],
                    );
                  }
                }

                if (response.statusCode == 200) {
                  final uri = Uri.parse('http://10.0.2.2:8000/');
                  final cookies = await cookieJar.loadForRequest(uri);
                  final sessionCookie = cookies.firstWhereOrNull(
                    (cookie) => cookie.name == 'sessionid',
                  );

                  if (sessionCookie != null) {
                    print('Cookie de sessão: ${sessionCookie.value}');
                  } else {
                    print('Cookie de sessão não encontrado');
                  }

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MenuPage()),
                    (route) => false,
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title:
                          const Text('Erro de autenticação'),
                      content:
                          const Text('Nome de usuário ou senha inválidos.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child:
                              const Text('Fechar'),
                        ),
                      ],
                    ),
                  );
                }
              },
              style:
                  ElevatedButton.styleFrom(primary: Colors.red.shade900),
              child:
                  const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
