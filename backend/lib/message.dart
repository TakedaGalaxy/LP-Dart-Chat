enum MessageType { text, image }

String messageTypeToString(MessageType type) {
  switch (type) {
    case MessageType.text:
      return "text";
    case MessageType.image:
      return "image";
    default:
      throw Exception("Tipo de mensagem inválido");
  }
}

MessageType messageTypeFromString(String type) {
  switch (type) {
    case "test":
      return MessageType.text;
    case "image":
      return MessageType.image;
    default:
      throw Exception("Tipo de mensagem inválido");
  }
}

class Message {
  late String _user, _text;
  late MessageType _type;
  late DateTime _timestamp;

  Message(String user, MessageType type, String text) {
    if (user == "") throw FormatException("Nome de usuário inválido");

    _user = user;
    _text = text;
    _type = type;
    _timestamp = DateTime.now();
  }

  String get user => _user;
  String get text => _text;
  MessageType get type => _type;
  DateTime get timestamp => _timestamp;

  set user(String user) {
    if (user == "") throw FormatException("Nome de usuário inválido");

    _user = user;
  }

  set text(String text) {
    if (text == "") throw FormatException("Texto inválido");

    _text = text;
  }

  set type(MessageType type) {
    _type = type;
  }

  set timestamp(DateTime unixepoch) {
    _timestamp = unixepoch;
  }
}
