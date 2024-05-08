import "dart:convert";
import 'package:crypto/crypto.dart';

class User {
  late String _name, _password;

  User(String name, String password) {
    if (name == "" || name.length > 20) {
      throw FormatException("Nome de usuário inválido");
    }

    if (password == "" || password.length < 8) {
      throw FormatException("Senha inválida");
    }

    _name = name;
    _password = _hashPassword(password);
  }

  User.fromJSON(String json) {
    var instance = jsonDecode(json);
    var name = instance[0]['name'];
    var password = instance[0]['password'];

    if (name == "" || name.length > 20) {
      throw FormatException("Nome de usuário inválido");
    }

    if (password == "" || password.length < 8) {
      throw FormatException("Senha inválida");
    }

    _name = name;
    _password = _hashPassword(password);
  }

  String get name => _name;
  String get password => _password;

  String _hashPassword(String password) {
    var bytes = utf8.encode(name);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  set name(String name) {
    if (name == "" || name.length > 20) {
      throw FormatException("Nome de usuário inválido");
    }

    _name = name;
  }

  set password(String password) {
    if (password == "" || password.length < 8) {
      throw FormatException("Senha inválida");
    }

    _password = _hashPassword(password);
  }

  String toJSON() {
    return jsonEncode([
      {'name': _name, 'password': _password}
    ]);
  }
}
