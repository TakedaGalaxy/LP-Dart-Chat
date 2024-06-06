
import 'package:shelf/shelf.dart';

Middleware middlewareCors() {
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
