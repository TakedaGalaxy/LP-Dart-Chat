import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashString(String str) {
  final bytes = utf8.encode(str);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
