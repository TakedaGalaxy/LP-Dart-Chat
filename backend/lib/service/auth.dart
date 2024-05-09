import 'package:backend/service/common.dart';

class ServiceAuth {
  ServiceResponseMessage signIn(
      {required String name, required String password}) {


    return ServiceResponseMessage(message: "Conta criada com sucesso !");
  }
}
