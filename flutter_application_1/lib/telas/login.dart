// telas/login.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/user_repository.dart';
import '../models/user.dart';
import 'principal.dart';
import 'cadastro_login.dart'; // Tela de cadastro específica para usuários

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final UserRepository _userRepository = UserRepository();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      User? user = await _userRepository.authenticate(username, password);
      if (user != null) {
        // Salvar o token no SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user.username);

        // Navegar para a tela principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Principal()),
        );
      } else {
        setState(() {
          _errorMessage = 'Nome de usuário ou senha inválidos.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nome de Usuário'),
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome de usuário.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Senha'),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a senha.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Entrar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CadastroLogin()),
                    );
                  },
                  child: const Text('Não tem uma conta? Cadastre-se'),
                ),
              ],
            ),
          ),
        ));
  }
}
