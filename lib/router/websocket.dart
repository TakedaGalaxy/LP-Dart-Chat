import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Router routerWebsocket() {
  final routerUser = Router();

  routerUser.mount("/", (Request request) {
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

  return routerUser;
}
