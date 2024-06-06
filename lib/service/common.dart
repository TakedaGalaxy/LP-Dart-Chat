import 'dart:convert';

class ServiceResponseMessage {
  final bool success;
  final String message;

  ServiceResponseMessage({required this.success, required this.message});

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
