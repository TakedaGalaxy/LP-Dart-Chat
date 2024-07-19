import 'dart:convert';

import 'package:backend/database/database.dart';
import 'package:backend/service/common.dart';
import 'package:backend/utils/jwt.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Router routerWebsocket(DatabaseConnection databaseConnection) {
  final activeConnections = <WebSocketChannel>[];

  final routerUser = Router();

  routerUser.mount("/chat", (Request request) {
    // Se não for HTTP, passa para o tratamento de WebSocket
    return webSocketHandler((WebSocketChannel webSocket) {
      bool authenticate = false;

      webSocket.stream.listen((message) {
        try {
          final data = JsonDecoder().convert(message);

          final token = data["accessToken"];
          final userMessage = data["message"];

          try {
            final payload = decodeAccessToken(token);

            final userTokent =
                databaseConnection.getUserTokenById(payload.tokenId);

            if (userTokent.revoke == 1) {
              throw ServiceResponseMessage(
                      success: false, message: "Token revogado")
                  .toJsonString();
            }

            if (!authenticate) {
              authenticate = true;
              activeConnections.add(webSocket);
            }

            if (userMessage == null) return;

            final userName = payload.userName;

            for (var connection in activeConnections) {
              connection.sink
                  .add('{"user": "$userName", "message" : "$userMessage"}');
            }
          } catch (error) {
            print(error);
            webSocket.sink.close(
                500,
                ServiceResponseMessage(
                        success: false, message: "Error MiddlewareAuth $error")
                    .toJsonString());
          }
        } catch (_) {
          webSocket.sink.close(500, "Not authenticate !");
        }
      }, onDone: () {
        // Remover a conexão da lista quando for fechada
        activeConnections.remove(webSocket);
      });
    })(request);
  });

  return routerUser;
}
