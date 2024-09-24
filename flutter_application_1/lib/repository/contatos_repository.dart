import '../models/contato.dart';

class ContatosRepository {
  final List<Contato> contatos = [];

  void addContato(Contato contato) {
    contatos.add(contato);
  }

  void removeContato(int index) {
    contatos.removeAt(index);
  }

  void updateContato(int index, Contato contato) {
    contatos[index] = contato;
  }

  List<Contato> getContatos() {
    return contatos;
  }
}
