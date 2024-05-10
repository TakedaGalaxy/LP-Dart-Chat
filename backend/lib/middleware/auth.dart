import 'package:backend/database/database.dart';
import 'package:backend/service/common.dart';
import 'package:backend/utils/jwt.dart';
import 'package:shelf/shelf.dart';

Middleware middlewareAuth(DatabaseConnection databaseConnection) {
  return (Handler innerHandler) {
    return (Request request) async {
      var token = request.headers["Authorization"];

      if (token == null) {
        return Response.forbidden(ServiceResponseMessage(
                success: false, message: "Token de autorização não encontrado")
            .toJsonString());
      }

      if (token.startsWith("Bearer ")) {
        token = token.replaceFirst("Bearer ", "");
      }

      try {
        final payload = decodeAccessToken(token);

        final userTokent = databaseConnection.getUserTokenById(payload.tokenId);

        if (userTokent.revoke == 1) {
          return Response.forbidden(
              ServiceResponseMessage(success: false, message: "Token revogado")
                  .toJsonString());
        }

        final updatedRequest = request.change(context: {
          "userName": payload.userName,
          "tokenId": payload.tokenId
        });

        return await innerHandler(updatedRequest);
      } catch (error) {
        print(error);
        return Response.forbidden(ServiceResponseMessage(
                success: false, message: "Error MiddlewareAuth $error")
            .toJsonString());
      }
    };
  };
}
