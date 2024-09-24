import 'package:flutter/material.dart';
import '../models/contato.dart';
import '../repository/contatos_repository.dart';

class Cadastro extends StatefulWidget {
  final ContatosRepository contatos;
  final int? index;
  final Contato? contato;

  Cadastro({required this.contatos, this.index, this.contato});

  @override
  State<Cadastro> createState() => _CadastroState(contatos: contatos, index: index, contato: contato);
}

class _CadastroState extends State<Cadastro> {
  final ContatosRepository contatos;
  final int? index;
  final Contato? contato;
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  _CadastroState({required this.contatos, this.index, this.contato});

  @override
  void initState() {
    super.initState();
    if (contato != null) {
      nomeController.text = contato!.nome;
      telefoneController.text = contato!.telefone;
      emailController.text = contato!.email;
    }
  }

  void _salvarContato() {
    if (index == null) {
      contatos.addContato(Contato(
        nome: nomeController.text,
        telefone: telefoneController.text,
        email: emailController.text,
      ));
    } else {
      contatos.updateContato(index!, Contato(
        nome: nomeController.text,
        telefone: telefoneController.text,
        email: emailController.text,
      ));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(index == null ? 'Cadastrar Contato' : 'Atualizar Contato'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Nome'),
            controller: nomeController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Telefone'),
            controller: telefoneController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Email'),
            controller: emailController,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _salvarContato,
          child: Text(index == null ? 'Salvar' : 'Atualizar'),
        ),
      ],
    );
  }
}
