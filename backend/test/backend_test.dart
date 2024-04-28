import 'package:backend/dbconnection.dart';
import 'package:backend/user.dart';
import 'package:test/test.dart';

void main() {
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
