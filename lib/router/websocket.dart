import 'dart:convert';

import 'package:backend/database/database.dart';
import 'package:backend/service/common.dart';
import 'package:backend/utils/jwt.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class UserConection {
  final String _userName;
  final WebSocketChannel _webSocketChannel;

  UserConection(this._userName, this._webSocketChannel);

  String getUserName() {
    return _userName;
  }

  void sendMessage(String message) {
    _webSocketChannel.sink.add(message);
  }
}

class ListUserConnection {
  final List<UserConection> _connections = [];

  ListUserConnection();

  void add(UserConection connection) {
    _connections.add(connection);
  }

  void remove(UserConection connection) {
    _connections.remove(connection);
  }

  void sendBroadCast(String message, String? excludeUserName) {
    for (var connection in _connections) {
      if (excludeUserName != null &&
          connection.getUserName() == excludeUserName) {
        continue;
      }

      connection.sendMessage(message);
    }
  }

  List<String> getListUsersOnline(String? excludeUserName) {
    final returnValue = <String>[];

    for (var conneciton in _connections) {
      String userName = conneciton.getUserName();

      if (excludeUserName != null && userName == excludeUserName) {
        continue;
      }

      returnValue.add(userName);
    }

    return returnValue;
  }
}

Router routerWebsocket(DatabaseConnection databaseConnection) {
  final routerUser = Router();

  final listUserConnection = ListUserConnection();

  routerUser.mount("/chat", (Request request) {
    return webSocketHandler((WebSocketChannel webSocket) {
      UserConection? connection;

      webSocket.stream.listen((message) {
        String? token = "";
        String? command = "";
        String? data = "";

        PayloadAccessToken? payload;

        try {
          // Extraindo dados da mensagem

          final jsonMessage = JsonDecoder().convert(message);
          token = jsonMessage["accessToken"];
          command = jsonMessage["command"];
          data = jsonMessage["data"];

          // Verificando token

          payload = decodeAccessToken(token!);

          final userTokent =
              databaseConnection.getUserTokenById(payload.tokenId);

          if (userTokent.revoke == 1) {
            throw ServiceResponseMessage(
                    success: false, message: "Token revogado")
                .toJsonString();
          }

          // Adicionadno a conexão como valída e enviando que novo usuario conectou

          if (connection == null) {
            connection = UserConection(payload.userName, webSocket);
            listUserConnection.sendBroadCast(
                jsonEncode({
                  "command": "logIn",
                  "data": {"userName": connection?.getUserName()}
                }),
                null);
            listUserConnection.add(connection!);
            print("[${connection?.getUserName()}] Online");
            return;
          }
        } catch (error) {
          print(error);
          webSocket.sink.close();
          return;
        }

        switch (command) {
          case "message":
            listUserConnection.sendBroadCast(
                jsonEncode({
                  "command": "message",
                  "data": {
                    "userName": connection!.getUserName(),
                    "message": data
                  }
                }),
                null);
            break;

          case "userInput":
            listUserConnection.sendBroadCast(
                jsonEncode({
                  "command": "userInput",
                  "data": {"userName": connection!.getUserName(), "input": data}
                }),
                connection!.getUserName());
            break;

          case "usersOnline":
            connection!.sendMessage(jsonEncode({
              "command": "usersOnline",
              "data": listUserConnection
                  .getListUsersOnline(connection!.getUserName())
            }));
            break;

          case "img":
            break;

          default:
            print("Comand Not Found !");
            break;
        }
      }, onDone: () {
        if (connection != null) {
          listUserConnection.remove(connection!);

          listUserConnection.sendBroadCast(
              jsonEncode({
                "command": "logOut",
                "data": {"userName": connection!.getUserName()}
              }),
              null);

          print("[${connection!.getUserName()}] Offline");
        }
      });
    })(request);
  });

  return routerUser;
}
