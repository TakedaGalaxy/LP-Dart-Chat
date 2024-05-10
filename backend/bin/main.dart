import 'package:backend/router/auth.dart';
import 'package:backend/router/user.dart';
import 'package:backend/router/websocket.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final app = Router();

  app.get("/", (Request request) => Response.ok("Servidor rodando !"));

  app.mount("/user", routerUser().call);
  app.mount("/auth", routerAuth().call);
  app.mount("/websocket", routerWebsocket().call);

  final handler = const Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addHandler(app.call);

  final server = await shelf_io.serve(handler, 'localhost', 8080);
  
  print('Servidor rodando em http://${server.address.host}:${server.port}');
}

Middleware corsHeaders() {
  return (Handler innerHandler) {
    return (Request request) async {
      var response = await innerHandler(request);
      response = response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers':
            'Origin, Content-Type, Accept, Authorization',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Max-Age': '86400',
      });
      return response;
    };
  };
}
