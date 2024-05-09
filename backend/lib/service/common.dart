class ServiceResponseMessage {
  final String message;

  ServiceResponseMessage({required this.message});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
