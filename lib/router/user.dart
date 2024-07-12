import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/database/database.dart';
import 'package:backend/service/user.dart';

Router routerUser(DatabaseConnection databaseConnection) {
  final serviceUser = ServiceUser(databaseConnection: databaseConnection);

  final routerUser = Router();

  // Sign In
  routerUser.post("/", (Request request) async {
    final body = await request.readAsString();

    final response = await serviceUser.createFromJson(body);

    if (response.success) return Response.ok(response.toJsonString());

    return Response.internalServerError(body: response.toJsonString());
  });

  return routerUser;
}
