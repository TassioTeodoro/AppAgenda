import '../models/contato.dart';
import 'database_helper.dart';

class ContatosRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Contato>> getContatos() async {
    return await _dbHelper.getContatos();
  }

  Future<void> addContato(Contato contato) async {
    await _dbHelper.addContato(contato);
  }

  Future<void> updateContato(Contato contato) async {
    await _dbHelper.updateContato(contato);
  }

  Future<void> removeContato(int id) async {
    await _dbHelper.deleteContato(id);
  }
}
