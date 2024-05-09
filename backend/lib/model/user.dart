import "dart:convert";
import 'package:backend/utils/utils.dart';

class ModelUser {
  late String _name, _password;

  ModelUser(String name, String password) {
    if (name == "" || name.length > 20) {
      throw FormatException("Nome de usuário inválido");
    }

    if (password == "" || password.length < 8) {
      throw FormatException("Senha inválida");
    }

    _name = name;
    _password = hashString(password);
  }

  ModelUser.fromJsonString(String str) {
    final instance = jsonDecode(str);
    final name = instance['name'];
    final password = instance['password'];

    if (name == "" || name.length > 20) {
      throw FormatException("Nome de usuário inválido");
    }

    if (password == "" || password.length < 8) {
      throw FormatException("Senha inválida");
    }

    _name = name;
    _password = hashString(password);
  }

  String get name => _name;
  String get password => _password;

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

    _password = hashString(password);
  }

  Map<String, dynamic> toJson() {
    return {'name': _name, 'password': _password};
  }
}
