// telas/cadastro_login.dart

import 'package:flutter/material.dart';
import '../repository/user_repository.dart';
import '../models/user.dart';

class CadastroLogin extends StatefulWidget {
  const CadastroLogin({super.key});

  @override
  State<CadastroLogin> createState() => _CadastroLoginState();
}

class _CadastroLoginState extends State<CadastroLogin> {
  final UserRepository _userRepository = UserRepository();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _errorMessage;
  String? _successMessage;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        setState(() {
          _errorMessage = 'As senhas não correspondem.';
        });
        return;
      }

      User user = User(username: username, password: password);
      bool success = await _userRepository.registerUser(user);
      if (success) {
        setState(() {
          _successMessage = 'Usuário registrado com sucesso!';
          _errorMessage = null;
        });
        // Opcional: Navegar de volta para a tela de login
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        setState(() {
          _errorMessage = 'Nome de usuário já está em uso.';
          _successMessage = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro'),
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
                if (_successMessage != null)
                  Text(
                    _successMessage!,
                    style: const TextStyle(color: Colors.green),
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
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme a senha.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ));
  }
}
