import 'package:get_storage/get_storage.dart';

class AuthManager {
  static final _storage = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  static bool isUserLoggedIn() {
    return _storage.read('isLoggedIn') ?? false;
  }

  static void setUserLoggedIn(bool value) {
    _storage.write('isLoggedIn', value);
  }

  static void logout() {
    _storage.remove('isLoggedIn');
    _storage.remove('username');
    _storage.remove('userId');
  }

  // Сохранение имени пользователя
  static Future<void> setUsername(String username) async {
    await _storage.write('username', username);
  }

  // Получение id пользователя
  static String? getUsername() {
    return _storage.read('username');
  }

  // Сохранение id пользователя
  static Future<void> setUserId(int userId) async {
    await _storage.write('userId', userId);
  }

  // Получение имени пользователя
  static int? getUserId() {
    return _storage.read('userId');
  }
}
