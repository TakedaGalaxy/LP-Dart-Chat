import 'package:backend/database/database.dart';
import 'package:backend/model/user.dart';
import 'package:backend/service/user.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router routerUser(DatabaseConnection databaseConnection) {
  final serviceUser = ServiceUser(databaseConnection: databaseConnection);

  final routerUser = Router();

  routerUser.post("/", (Request request) async {
    final response = await serviceUser.create(await request.readAsString());

    if (response.success) return Response.ok(response.toJsonString());

    return Response.internalServerError(body: response.toJsonString());
  });

  return routerUser;
}
