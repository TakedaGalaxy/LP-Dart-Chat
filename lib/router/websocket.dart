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
  final activeUsers = <String>[];

  final routerUser = Router();

  routerUser.mount("/chat", (Request request) {
    return webSocketHandler((WebSocketChannel webSocket) {
      String userName = "";
      bool authenticate = false;

      webSocket.stream.listen((message) {
        try {
          final jsonMessage = JsonDecoder().convert(message);

          final token = jsonMessage["accessToken"];
          final command = jsonMessage["command"];
          final data = jsonMessage["data"];

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
              userName = payload.userName;
              activeUsers.add(userName);
              activeConnections.add(webSocket);
            }

            switch (command) {
              case "message":
                for (var connection in activeConnections) {
                  connection.sink.add(
                      '{"command":"message","data": {"userName":"$userName","message" : "$data"}}');
                }
                break;

              case "userInput":
                for (var connection in activeConnections) {
                  connection.sink.add(
                      '{"command":"userInput","data": {"userName":"$userName","input" : "$data"}}');
                }
                break;

              case "usersOnline":
                final activeUserString = jsonEncode(activeUsers);
                webSocket.sink.add('{"command": "usersOnline", "data": $activeUserString}');
                break;

              case "img":
                break;

              case "logIn":
                print("[$userName] Online");
                break;

              default:
                print("Comand Not Found !");
                break;
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
        activeUsers.remove(userName);

        for (var connection in activeConnections) {
          connection.sink
              .add('{"command":"logOut","data": {"userName":"$userName"}}');
        }
      });
    })(request);
  });

  return routerUser;
}
