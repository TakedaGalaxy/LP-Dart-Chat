import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:shelf/shelf.dart';

String hashString(String str) {
  final bytes = utf8.encode(str);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<Response> getFile(String path, String type) async {
  final file = File(path);

  if (!await file.exists()) return Response.notFound('File not found');

  final bytes = await file.readAsBytes();
  return Response.ok(
    bytes,
    headers: {'Content-Type': type},
  );
}
