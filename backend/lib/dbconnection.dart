import 'package:sqlite3/sqlite3.dart';
import 'user.dart';
import 'user_token.dart';

class DBConnection {
  late Database _db;

  DBConnection() {
    try {
      _db = sqlite3.openInMemory();
      _createUser();
      _createUserToken();
    } catch (err) {
      print('Error: $err');
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
      CREATE TABLE User(
        user VARCHAR(50),
        tokeid VARCHAR(100) NOT NULL,
        revoke INTEGER NOT NULL,
        PRIMARY KEY(user, tokeid),
        FOREIGN KEY (user) REFERENCES User(name)
      );
      ''');
  }

  void createUser(User user) {
    _db.execute('INSERT INTO User(name, password) VALUES(?, ?)',
        [user.name, user.password]);
  }

  void createUserToken(UserToken userToken) {
    _db.execute('INSERT INTO UserToken(user, tokeid, revoke) VALUES(?, ?, ?)',
        [userToken.user, userToken.tokeid, userToken.revoke]);
  }

  void logout(UserToken userToken) {
    _db.execute(
        'UPDATE UserToken SET revoke = 1 WHERE tokeid = ?', [userToken.tokeid]);
  }

  User getUserByName(String name) {
    if (name == "" || name.length > 20) {
      throw Exception("Usuároi inválido");
    }

    final ResultSet set =
        _db.select("SELECT * FROM User WHERE name = ?", [name]);

    if (set.isNotEmpty) {
      final Row row = set.first;
      return User(row['name'], row['password']);
    }
    throw Exception("Usuário não encontrado");
  }

  UserToken getUserTokenById(String tokeid) {
    if (tokeid == "") {
      throw Exception("Token inválido");
    }

    final ResultSet set =
        _db.select("SELECT * FROM UserToken WHERE tokeid = ?", [tokeid]);

    if (set.isNotEmpty) {
      final Row row = set.first;
      return UserToken(row['usuario'], row['tokeid'], row['revoke']);
    }

    throw Exception("Token não encontrado");
  }
}
