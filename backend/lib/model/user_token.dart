import 'dart:convert';

class ModelUserToken {
  late String _userName, _tokeid;
  late int _revoke;

  ModelUserToken(String userName, String tokeid, [int revoke = 0]) {
    if (userName == "" || userName.length > 20) {
      throw Exception("UserName inválido");
    }

    if (tokeid == "") {
      throw Exception("TokenId inválido");
    }

    _userName = userName;
    _tokeid = tokeid;
    _revoke = revoke;
  }

  ModelUserToken.fromJsonString(String str) {
    final json = jsonDecode(str);
    final userName = json['userName'];
    final tokeid = json['tokeid'];

    if (userName == "" || userName.length > 20) {
      throw Exception("Usuário inválido");
    }

    if (tokeid == "") {
      throw Exception("Token inválido");
    }

    _userName = userName;
    _tokeid = tokeid;
    _revoke = 0;
  }

  String get userName => _userName;
  String get tokeid => _tokeid;
  int get revoke => _revoke;

  set userName(String userName) {
    if (userName == "" || userName.length > 20) {
      throw Exception("Usuário inválido");
    }

    _userName = userName;
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

  Map<String, dynamic> toJson() {
    return {'user': _userName, 'tokeid': _tokeid, 'revoke': _revoke};
  }
}
