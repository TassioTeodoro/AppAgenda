import '../models/contato.dart';
import 'database_helper.dart';

class ContatosRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Contato>> getContatos() async {
    try {
      return await _dbHelper.getContatos();
    } catch (e) {
      // Tratar o erro de maneira adequada
      throw Exception('Erro ao obter contatos: $e');
    }
  }

  Future<void> addContato(Contato contato) async {
    try {
      await _dbHelper.addContato(contato);
    } catch (e) {
      // Tratar o erro de maneira adequada
      throw Exception('Erro ao adicionar contato: $e');
    }
  }

  Future<void> updateContato(Contato contato) async {
    try {
      await _dbHelper.updateContato(contato);
    } catch (e) {
      // Tratar o erro de maneira adequada
      throw Exception('Erro ao atualizar contato: $e');
    }
  }

  Future<void> removeContato(int id) async {
    try {
      await _dbHelper.deleteContato(id);
    } catch (e) {
      // Tratar o erro de maneira adequada
      throw Exception('Erro ao remover contato: $e');
    }
  }
}
