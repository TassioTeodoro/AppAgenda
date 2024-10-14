import 'package:flutter/material.dart';
import '../repository/contatos_repository.dart';
import '../models/contato.dart';
import 'cadastro.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          "Agenda de Contatos",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _contatosList.length,
        itemBuilder: (context, index) {
          Contato c = _contatosList[index];
          return ListTile(
            title: Text(c.nome),
            subtitle: Text('Telefone: ${c.telefone}\nEmail: ${c.email}'),
            leading: CircleAvatar(
              child: Text(c.nome[0]), // Exibe a primeira letra do nome
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Botão para editar o contato
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editarContato(index, c); // Chama a função de editar
                  },
                ),
                // Botão para remover o contato
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _removerContato(c.id!); // Chama a função de remover
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
