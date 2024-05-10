import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router routerAuth() {
  final routerAuth = Router();

  routerAuth.post("/", (Request request) async {
    return Response.ok("Ok");
  });

  routerAuth.delete("/", (Request request) async {
    return Response.ok("Ok");
  });

  return routerAuth;
}
