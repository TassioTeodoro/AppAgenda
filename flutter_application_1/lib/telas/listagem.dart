import 'package:flutter/material.dart';
import '../repository/contatos_repository.dart';
import '../models/contato.dart';
import 'cadastro.dart';

class Listagem extends StatefulWidget {
  final ContatosRepository contatos;

  Listagem({required this.contatos});

  @override
  State<Listagem> createState() => _ListagemState(contatos: contatos);
}

class _ListagemState extends State<Listagem> {
  final ContatosRepository contatos;

  _ListagemState({required this.contatos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
      ),
      body: ListView.builder(
        itemCount: contatos.getContatos().length,
        itemBuilder: (context, index) {
          Contato c = contatos.getContatos()[index];
          return ListTile(
            title: Text(c.nome),
            subtitle: Text('Tel: ${c.telefone}\nEmail: ${c.email}'),
            leading: CircleAvatar(
              child: Text(c.nome[0]), // Exibe a primeira letra do nome
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Cadastro(
                        contatos: contatos,
                        index: index,
                        contato: c,
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      contatos.removeContato(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
