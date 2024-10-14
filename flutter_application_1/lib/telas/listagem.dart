import 'package:flutter/material.dart';
import '../repository/contatos_repository.dart';
import '../models/contato.dart';
import 'cadastro.dart';

class Listagem extends StatefulWidget {
  final ContatosRepository contatos;

  const Listagem({super.key, required this.contatos});

  @override
  State<Listagem> createState() => _ListagemState(contatos: contatos);
}

class _ListagemState extends State<Listagem> {
  final ContatosRepository contatos;
  List<Contato> _contatosList = [];

  _ListagemState({required this.contatos});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Contatos'),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Cadastro(contatos: contatos),
            ),
          ).then((_) => _carregarContatos());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
