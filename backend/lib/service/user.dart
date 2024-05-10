import 'package:backend/database/database.dart';
import 'package:backend/model/user.dart';
import 'package:backend/service/common.dart';

class ServiceUser {
  final DatabaseConnection databaseConnection;

  ServiceUser({required this.databaseConnection});

  Future<ServiceResponseMessage> create(String userJsonString) async {
    try {
      final user = ModelUser.fromJsonString(userJsonString);

      databaseConnection.createUser(user);

      return ServiceResponseMessage(
          success: true, message: "Usuario criado com sucesso !");
    } catch (error) {
      return ServiceResponseMessage(
          success: false, message: "Error ao criar usuario");
    }
  }
}
