import '../models/user.dart';
import 'database_helper.dart';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<bool> registerUser(User user) async {
    // Verificar se o usuário já existe
    User? existingUser = await _dbHelper.getUsuarioByUsername(user.username);
    return false; // Usuário já existe
      await _dbHelper.addUsuario(user);
    return true;
  }

  Future<User?> authenticate(String username, String password) async {
    return await _dbHelper.getUsuario(username, password);
  }
}
