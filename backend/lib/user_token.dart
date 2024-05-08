import 'dart:convert';

class UserToken {
  late String _user, _tokeid;
  late int _revoke;

  UserToken(String user, String tokeid, [int revoke = 0]) {
    if (user == "" || user.length > 20) {
      throw Exception("Usuário inválido");
    }

    if (tokeid == "") {
      throw Exception("Token inválido");
    }

    _user = user;
    _tokeid = tokeid;
    _revoke = revoke;
  }

  UserToken.fromJSON(String json) {
    var instance = jsonDecode(json);
    var user = instance[0]['user'];
    var tokeid = instance[0]['tokeid'];
    var revoke = instance[0]['revoke'];

    if (user == "" || user.length > 20) {
      throw Exception("Usuário inválido");
    }

    if (tokeid == "") {
      throw Exception("Token inválido");
    }

    if (revoke != 0 && revoke != 1) {
      throw Exception("Revoke com valor inválido: $revoke");
    }

    _user = user;
    _tokeid = tokeid;
    _revoke = revoke;
  }

  String get user => _user;
  String get tokeid => _tokeid;
  int get revoke => _revoke;

  set user(String user) {
    if (user == "" || user.length > 20) {
      throw Exception("Usuário inválido");
    }

    _user = user;
  }

  set tokeid(String tokeid) {
    if (tokeid == "") {
      throw Exception("Token ID inválido");
    }

    _tokeid = tokeid;
  }

  set revoke(int revoke) {
    if (revoke != 0 && revoke != 1) {
      throw Exception("Revoke inválido");
    }

    _revoke = revoke;
  }

  String toJSON() {
    return jsonEncode([
      {'user': _user, 'tokeid': _tokeid, 'revoke': _revoke}
    ]);
  }
}
