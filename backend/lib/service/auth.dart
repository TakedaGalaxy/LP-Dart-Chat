import 'package:backend/database/database.dart';
import 'package:backend/model/user.dart';
import 'package:backend/model/user_token.dart';
import 'package:backend/service/common.dart';
import 'package:backend/utils/jwt.dart';
import 'package:backend/utils/utils.dart';

class ServiceAuth {
  DatabaseConnection databaseConnection;

  ServiceAuth({required this.databaseConnection});

  ServiceResponseMessage logIn(String jsonLogIn) {
    try {
      final user = ModelUser.fromJsonString(jsonLogIn);
      user.password = hashString(user.password);

      final userTarget = databaseConnection.getUserByName(user.name);

      if (user.password != userTarget.password) {
        return ServiceResponseMessage(
            success: false, message: "Senha incorreta !");
      }

      int timestamp = DateTime.now().millisecondsSinceEpoch;
      String tokenId = "${user.name}_$timestamp";

      final payload = PayloadAccessToken(userName: user.name, tokenId: tokenId);

      String token = generateAccessToken(payload);

      databaseConnection.createUserToken(ModelUserToken(user.name, tokenId));

      return ServiceResponseMessage(success: true, message: token);
    } catch (error) {
      return ServiceResponseMessage(
          success: false, message: "Error logIn $error");
    }
  }
}
