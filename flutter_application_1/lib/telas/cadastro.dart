import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart'; // Para a máscara de telefone
import '../repository/contatos_repository.dart';
import '../models/contato.dart';

class Cadastro extends StatefulWidget {
  final ContatosRepository contatos;
  final int? index;
  final Contato? contato;

  const Cadastro({super.key, required this.contatos, this.index, this.contato});

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
  final _formKey = GlobalKey<FormState>(); // Para validação do formulário
  String? erroContatoExistente; // Para exibir mensagem de erro se o contato já existir

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

  
  // Verifica se o contato já existe pelo nome ou e-mail
Future<bool> _contatoJaExiste(String nome, String email) async {
  List<Contato> todosContatos = await contatos.getContatos(); 

  for (Contato c in todosContatos) {
    if ((c.nome == nome || c.email == email) && (index == null || c.id != contato!.id)) {
      return true; 
    }
  }
  return false; 
}


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(index == null ? 'Cadastrar Contato' : 'Editar Contato'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey, // Chave do formulário para validação
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nome'),
              controller: nomeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O nome não pode ficar em branco';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Telefone'),
              controller: telefoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [MaskedInputFormatter('(##) #####-####')], // Máscara para telefone
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O telefone não pode ficar em branco';
                }
                if (value.length < 15) { // Verifica se está no formato (xx) xxxxx-xxxx
                  return 'Telefone inválido. Use o formato (xx) xxxxx-xxxx';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O email não pode ficar em branco';
                }
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) {
                  return 'Email inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            if (erroContatoExistente != null)
              Text(
                erroContatoExistente!,
                style: const TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String nome = nomeController.text;
                  String telefone = telefoneController.text;
                  String email = emailController.text;

                  // Verifica se o contato já existe no banco de dados
                  bool contatoExiste = await _contatoJaExiste(nome, email);

                  if (contatoExiste) {
                    setState(() {
                      erroContatoExistente = 'Erro: Contato já existe com mesmo nome ou email.';
                    });
                  } else {
                    erroContatoExistente = null;
                    if (index == null) {
                      // Adicionar contato no banco de dados
                      await contatos.addContato(Contato(
                        nome: nome,
                        telefone: telefone,
                        email: email,
                      ));
                    } else {
                      // Atualizar contato no banco de dados
                      await contatos.updateContato(Contato(
                        id: contato!.id, // Mantém o id original
                        nome: nome,
                        telefone: telefone,
                        email: email,
                      ));
                    }
                    Navigator.pop(context); // Volta para a tela anterior após salvar
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    ),
  );
}
}