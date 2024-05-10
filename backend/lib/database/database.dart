import 'package:sqlite3/sqlite3.dart';
import '../model/user.dart';
import '../model/user_token.dart';

class DatabaseConnection {
  late Database _db;

  DatabaseConnection() {
    try {
      _db = sqlite3.openInMemory();
      _createUser();
      _createUserToken();
    } catch (err) {
      print("[DATABASE]: Erro em criar conexão ($err)");
      return;
    }
  }

  void _createUser() {
    _db.execute('''
      CREATE TABLE User(
        name VARCHAR(50) PRIMARY KEY,
        password VARCHAR(50) NOT NULL
      );
      ''');
  }

  void _createUserToken() {
    _db.execute('''
      CREATE TABLE UserToken(
        user VARCHAR(50),
        tokeid VARCHAR(100) NOT NULL,
        revoke INTEGER NOT NULL,
        PRIMARY KEY(user, tokeid),
        FOREIGN KEY (user) REFERENCES User(name)
      );
      ''');
  }

  void createUser(ModelUser user) {
    _db.execute('INSERT INTO User(name, password) VALUES(?, ?)',
        [user.name, user.password]);
  }

  void createUserToken(ModelUserToken userToken) {
    _db.execute(
        'UPDATE UserToken SET revoke = 1 WHERE user = ?', [userToken.userName]);
    _db.execute('INSERT INTO UserToken(user, tokeid, revoke) VALUES(?, ?, ?)',
        [userToken.userName, userToken.tokeid, userToken.revoke]);
  }

  void revokeUserToken(String tokeid) {
    _db.execute('UPDATE UserToken SET revoke = 1 WHERE tokeid = ?', [tokeid]);
  }

  ModelUser getUserByName(String name) {
    if (name == "" || name.length > 20) {
      throw Exception("Usuároi inválido");
    }

    final ResultSet set =
        _db.select("SELECT * FROM User WHERE name = ?", [name]);

    if (set.isNotEmpty) {
      final Row row = set.first;
      return ModelUser(row['name'], row['password']);
    }
    throw Exception("Usuário não encontrado");
  }

  ModelUserToken getUserTokenById(String tokeid) {
    if (tokeid == "") {
      throw Exception("Token inválido");
    }

    final ResultSet set =
        _db.select("SELECT * FROM UserToken WHERE tokeid = ?", [tokeid]);
        
    if (set.isNotEmpty) {
      final Row row = set.first;
      return ModelUserToken(row['user'], row['tokeid'], row['revoke']);
    }

    throw Exception("Token não encontrado");
  }
}
