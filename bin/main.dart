import 'package:backend/database/database.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/middleware/cors.dart';
import 'package:backend/router/auth.dart';
import 'package:backend/router/user.dart';
import 'package:backend/router/websocket.dart';
import 'package:shelf_static/shelf_static.dart';

void main() async {
  // ### Criando instancia do banco de dados ###
  final databaseConnection = DatabaseConnection();
  //  ### END ###

  // ### Configurando serviço ###
  final routerMain = Router();

  final staticHandler =
      createStaticHandler('public', defaultDocument: 'index.html');

  routerMain.get("/", (Request request) => staticHandler(request));

  routerMain.mount("/api/user", routerUser(databaseConnection).call);
  routerMain.mount("/api/auth", routerAuth(databaseConnection).call);
  routerMain.mount("/api/websocket", routerWebsocket().call);

  routerMain.get("/click", (Request request) {
    return Response.ok('<p>You clicked the button!</p>');
  });

  final handler = const Pipeline()
      .addMiddleware(middlewareCors())
      .addMiddleware(logRequests())
      .addHandler(routerMain.call);

  final server = await shelf_io.serve(handler, 'localhost', 8080);

  print('Servidor rodando em http://${server.address.host}:${server.port}');
  // ### END ###
}
