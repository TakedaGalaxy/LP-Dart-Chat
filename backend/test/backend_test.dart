import 'package:backend/dbconnection.dart';
import 'package:backend/user.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    User user = User('teste', '123mudar');

    test('Construtor de usuário JSON', () {
      User userJson =
          User.fromJSON('[{"name":"TesteJSON","password":"123mudar"}]');
      expect(userJson.name, 'TesteJSON');
      expect(userJson.password, '123mudar');
    });

    test('Usuário deveria ser criado normalmente', () {
      expect(user.name, 'teste');
      expect(user.password, '123mudar');
    });

    test('Usuário deveria ser atualizado normalmente', () {
      user.name = "Testado";
      expect(user.name, 'Testado');
      expect(user.password, '123mudar');
    });

    test('Usuário deveria ser serializado normalmente', () {
      expect('[{"name":"Testado"},{"password":"123mudar"}]', user.toJSON());
    });
  });

  group('DBConnection', () {
    late DBConnection dbConnection;

    setUp(() {
      dbConnection = DBConnection();
    });

    test('insertUser should add a new user to the database', () {
      // Arrange
      final user = User("test\\_u'se'r", "password123");

      // Act
      dbConnection.insertUser(user);

      // Assert
      final selectedUser = dbConnection.selectUser(user.name);
      expect(selectedUser.name, user.name);
      expect(selectedUser.password, user.password);
    });
  });
}
