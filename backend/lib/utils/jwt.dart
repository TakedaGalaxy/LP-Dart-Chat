import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class PayloadAccessToken {
  final String userName;
  final String tokenId;

  PayloadAccessToken({required this.userName, required this.tokenId});

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "tokenId": tokenId,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

String generateAccessToken(PayloadAccessToken payload) {
  final jwt = JWT(payload.toJson());

  return jwt.sign(SecretKey("SEGREDO"));
}

PayloadAccessToken decodeAccessToken(String token) {
  try {
    final jwt = JWT.verify(token, SecretKey("SEGREDO"));

    return PayloadAccessToken(
        userName: jwt.payload["userName"], tokenId: jwt.payload["tokenId"]);
  } on JWTExpiredException {
    throw "Token expirado !";
  } on JWTException catch (_) {
    throw "Token Invalido !";
  }
}
