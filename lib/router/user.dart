import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/database/database.dart';
import 'package:backend/service/user.dart';

Router routerUser(DatabaseConnection databaseConnection) {
  final serviceUser = ServiceUser(databaseConnection: databaseConnection);

  final routerUser = Router();

  routerUser.post("/sign-in", (Request request) async {
    final body = await request.readAsString();
    final params = Uri.splitQueryString(body);

    final response =
        await serviceUser.create(params["name"]!, params["password"]!);

    if (response.success) return Response.ok(response.toJsonString());

    return Response.internalServerError(body: response.toJsonString());
  });

  return routerUser;
}
