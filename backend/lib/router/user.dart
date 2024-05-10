import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router routerUser() {
  final routerUser = Router();

  routerUser.post("/", (Request request) async {
    return Response.ok("Ok");
  });

  return routerUser;
}
