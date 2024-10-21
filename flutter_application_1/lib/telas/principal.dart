import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/contatos_repository.dart';
import '../models/contato.dart';
import 'cadastro.dart';
import 'login.dart'; // Importar a tela de login

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final ContatosRepository contatos = ContatosRepository();
  List<Contato> _contatosList = [];

  @override
  void initState() {
    super.initState();
    _carregarContatos();
  }

  void _carregarContatos() async {
    List<Contato> contatosList = await contatos.getContatos();
    setState(() {
      _contatosList = contatosList;
    });
  }

  void _adicionarContato() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Cadastro(contatos: contatos),
      ),
    ).then((_) => _carregarContatos());
  }

  void _editarContato(int index, Contato contato) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Cadastro(
          contatos: contatos,
          index: index,
          contato: contato,
        ),
      ),
    ).then((_) => _carregarContatos());
  }

  void _removerContato(int id) async {
    await contatos.removeContato(id); // Remove do banco de dados
    _carregarContatos(); // Atualiza a lista após remover
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Contatos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _contatosList.length,
        itemBuilder: (context, index) {
          Contato c = _contatosList[index];
          return ListTile(
            title: Text(c.nome),
            subtitle: Text('Tel: ${c.telefone}\nEmail: ${c.email}'),
            leading: CircleAvatar(
              child: Text(c.nome[0]),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Cadastro(
                          contatos: contatos,
                          index: c.id!,
                          contato: c,
                        ),
                      ),
                    ).then((_) => _carregarContatos());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await contatos.removeContato(c.id!);
                    _carregarContatos();
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarContato,
        child: const Icon(Icons.add),
      ),
    );
  }
}
