// main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'telas/login.dart';
import 'telas/principal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Função para verificar o token
  Future<Widget> _getInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      return const Principal();
    }
    return const Login();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de Contatos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Tela de carregamento
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              // Em caso de erro, mostrar a tela de login
              return const Login();
            }
          }
        },
      ),
    );
  }
}
