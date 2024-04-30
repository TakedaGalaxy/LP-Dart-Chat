import 'dart:convert';

enum MessageType { text, image }

String messageTypeToString(MessageType type) {
  switch (type) {
    case MessageType.text:
      return 'text';
    case MessageType.image:
      return 'image';
    default:
      throw ArgumentError("Tipo de mensagem inválida");
  }
}

MessageType messageTypeFromString(String messageType) {
  switch (messageType) {
    case 'text':
      return MessageType.text;
    case 'image':
      return MessageType.image;
    default:
      throw ArgumentError("Tipo de mensagem inválida");
  }
}

class Message {
  late String _user, _body;
  late MessageType _type;
  late DateTime _timestamp;

  Message(this._user, this._timestamp, this._type, this._body);

  Message.fromJSON(String json) {
    var instance = jsonDecode(json);
    _user = instance[0]['user'];
    _timestamp = DateTime((instance[0]['timestamp']));
    _type = messageTypeFromString(instance[0]['type']);
    _body = instance[0]['body'];
  }

  String get user => _user;
  DateTime get timestamp => _timestamp;
  MessageType get type => _type;
  String get body => _body;

  set user(String user) => _user = user;
  set timestamp(DateTime timestamp) => _timestamp = timestamp;
  set type(MessageType type) => _type = type;
  set body(String body) => _body = body;

  String toJSON() {
    return jsonEncode([
      {'user': _user},
      {'timestamp': _timestamp.toString()},
      {'type': messageTypeToString(_type)},
      {'body': _body},
    ]);
  }
}
