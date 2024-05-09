import 'package:backend/model/user.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async {
  // Criando um servidor Shelf para lidar com requisições HTTP e WebSocket

  final app = Router();

  app.get("/", (Request request) {
    return Response.ok("Servidor rodando !");
  });

  app.post("/user", (Request request) async {
    ModelUser user = ModelUser.fromJsonString(await request.readAsString());
    print(user.toJson().toString());

    return Response.ok("Servidor rodando !");
  });

  app.all("/websocket", (Request request) {
    // Se não for HTTP, passa para o tratamento de WebSocket
    return webSocketHandler((WebSocketChannel webSocket) {
      webSocket.stream.listen((message) {
        // Recebeu uma mensagem do cliente WebSocket
        print('Mensagem do cliente WebSocket: $message');

        // Envia uma resposta de volta para o cliente WebSocket
        webSocket.sink.add('Recebido: $message');
      });
    })(request);
  });

  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(app.call);

  // Cria o servidor HTTP e WebSocket na mesma porta
  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Servidor rodando em http://${server.address.host}:${server.port}');
}
