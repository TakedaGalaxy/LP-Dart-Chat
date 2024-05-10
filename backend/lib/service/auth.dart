import 'dart:convert';

import 'package:backend/database/database.dart';
import 'package:backend/model/user.dart';
import 'package:backend/model/user_token.dart';
import 'package:backend/utils/jwt.dart';
import 'package:backend/utils/utils.dart';

class ServiceResponseLogIn {
  bool success;
  String message;
  String accessToken;

  ServiceResponseLogIn(
      {required this.success,
      required this.message,
      required this.accessToken});

  Map<String, dynamic> toJson() {
    if (success) return {"sucess": success, "accessToken": accessToken};

    return {"sucess": success, "message": message};
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

class ServiceAuth {
  DatabaseConnection databaseConnection;

  ServiceAuth({required this.databaseConnection});

  ServiceResponseLogIn logIn(String jsonLogIn) {
    try {
      final user = ModelUser.fromJsonString(jsonLogIn);
      user.password = hashString(user.password);

      final userTarget = databaseConnection.getUserByName(user.name);

      if (user.password != userTarget.password) {
        return ServiceResponseLogIn(
            success: false, message: "Senha incorreta !", accessToken: "");
      }

      int timestamp = DateTime.now().millisecondsSinceEpoch;
      String tokenId = "${user.name}_$timestamp";

      final payload = PayloadAccessToken(userName: user.name, tokenId: tokenId);

      String token = generateAccessToken(payload);

      databaseConnection.createUserToken(ModelUserToken(user.name, tokenId));

      return ServiceResponseLogIn(
          success: true, message: "", accessToken: token);
    } catch (error) {
      return ServiceResponseLogIn(
          success: false, message: "Error logIn $error", accessToken: "");
    }
  }
}
