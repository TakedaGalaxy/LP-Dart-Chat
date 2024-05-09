import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashString(String str) {
  var bytes = utf8.encode(str);
  var digest = sha256.convert(bytes);
  return digest.toString();
}
