import 'package:backend/user.dart';
import 'package:backend/message.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    User user = User('teste', '123mudar');

    test('Construtor do usuário', () {
      expect(user.name, 'teste');
      expect(user.password, '123mudar');
    });

    test('Setters de usuário', () {
      user.name = "Testado";
      expect(user.name, 'Testado');
      expect(user.password, '123mudar');
    });

    test('Serialização de JSON', () {
      expect('[{"name":"Testado"},{"password":"123mudar"}]', user.toJSON());
    });

    test('Construtor JSON', () {
      User userJson =
          User.fromJSON('[{"name":"TesteJSON","password":"123mudar"}]');
      expect(userJson.name, 'TesteJSON');
      expect(userJson.password, '123mudar');
    });
  });

  group('Message', () {
    DateTime date = DateTime(-14182916000000);
    Message message = Message('teste', date, MessageType.text, "Mensagem");

    test('Construtor comum', () {
      expect(message.user, "teste");
      expect(message.timestamp, date);
      expect(messageTypeToString(message.type), "text");
      expect(message.body, "Mensagem");
    });

    test('Construtor de usuário JSON', () {
      Message messageJson = Message.fromJSON(
          '[{"user":"TesteJSON","timestamp":-14182916000000,"type":"text","body":"Mensagem"}]');

      expect(messageJson.user, "TesteJSON");
      expect(messageJson.timestamp, date);
      expect(messageTypeToString(messageJson.type), "text");
      expect(messageJson.body, "Mensagem");
    });
  });
}
