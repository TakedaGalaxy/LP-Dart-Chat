import 'package:backend/database/database.dart';
import 'package:backend/model/user.dart';
import 'package:backend/service/common.dart';
import 'package:backend/utils/utils.dart';

class ServiceUser {
  final DatabaseConnection databaseConnection;

  ServiceUser({required this.databaseConnection});

  Future<ServiceResponseMessage> create(String userJsonString) async {
    try {
      final user = ModelUser.fromJsonString(userJsonString);

      user.password = hashString(user.password);

      databaseConnection.createUser(user);

      return ServiceResponseMessage(
          success: true, message: "Usuario criado com sucesso !");
    } catch (error) {
      return ServiceResponseMessage(
          success: false, message: "Error ao criar usuario");
    }
  }
}
