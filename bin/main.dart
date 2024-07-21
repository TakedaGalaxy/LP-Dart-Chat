import 'dart:io';

import 'package:backend/database/database.dart';
import 'package:backend/utils/utils.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/router/auth.dart';
import 'package:backend/router/user.dart';
import 'package:backend/router/websocket.dart';

void main() async {
  final certificate = File("security/cert.pem").readAsBytesSync();
  final privateKey = File("security/key.pem").readAsBytesSync();

  final securityContext = SecurityContext()
    ..useCertificateChainBytes(certificate)
    ..usePrivateKeyBytes(privateKey);

  // ### Criando instancia do banco de dados ###
  final databaseConnection = DatabaseConnection();
  //  ### END ###

  // ### Configurando serviço ###
  final routerMain = Router();

  // ### Arquivos estaticos ###

  routerMain.get(
      "/",
      (Request request) async =>
          await getFile("public/index.html", "text/html"));

  routerMain.get(
      "/main.js",
      (Request request) async =>
          await getFile("public/main.js", "text/javascript"));

  // ### Adicionando rotas ###

  routerMain.mount("/api/user", routerUser(databaseConnection).call);
  routerMain.mount("/api/auth", routerAuth(databaseConnection).call);
  routerMain.mount("/api/websocket", routerWebsocket(databaseConnection).call);

  final handler = const Pipeline()
      //.addMiddleware(middlewareCors())
      .addMiddleware(logRequests())
      .addHandler(routerMain.call);

  final server = await shelf_io.serve(handler, 'localhost', 443,
      securityContext: securityContext);

  print('Servidor rodando em https://${server.address.host}:${server.port}');
  // ### END ###
}
