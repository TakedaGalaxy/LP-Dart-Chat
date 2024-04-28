class User {
  late String _name, _password;

  User(String name, String password) {
    if (name == "") throw FormatException("Nome de usuário inválido");

    if (password == "") throw FormatException("Senha inválida");

    _name = name;
    _password = password;
  }

  String get name => _name;
  String get password => _password;

  set name(String name) {
    if (name == "") throw FormatException("Nome de usuário inválido");

    _name = name;
  }

  set password(String password) {
    if (password == "") throw FormatException("Senha inválida");

    _password = password;
  }
}
