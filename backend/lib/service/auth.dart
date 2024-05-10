import 'package:backend/database/database.dart';
import 'package:backend/model/user.dart';
import 'package:backend/service/common.dart';
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

      return ServiceResponseMessage(
          success: true, message: "Log in com sucesso !");
    } catch (error) {
      return ServiceResponseMessage(
          success: false, message: "Error logIn $error");
    }
  }
}
