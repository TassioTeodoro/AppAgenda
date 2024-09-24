import 'package:flutter/material.dart';
import '../repository/contatos_repository.dart';
import '../models/contato.dart';
import 'cadastro.dart';

class Principal extends StatefulWidget {
  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final ContatosRepository contatos = ContatosRepository();

  void _adicionarContato() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Cadastro(contatos: contatos),
      ),
    ).then((_) {
      setState(() {}); // Atualiza a lista após retornar do cadastro
    });
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
    ).then((_) {
      setState(() {}); // Atualiza a lista após editar o contato
    });
  }

  void _removerContato(int index) {
    setState(() {
      contatos.removeContato(index); // Remove o contato da lista
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          "Agenda de Contatos",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: contatos.getContatos().length,
        itemBuilder: (context, index) {
          Contato c = contatos.getContatos()[index];
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
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editarContato(index, c); // Chama a função de editar
                  },
                ),
                // Botão para remover o contato
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _removerContato(index); // Chama a função de remover
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarContato,
        child: Icon(Icons.add),
      ),
    );
  }
}
