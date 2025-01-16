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
  }

    // Сохранение имени пользователя
  static Future<void> setUsername(String username) async {
    await _storage.write('username', username);
  }

  // Получение имени пользователя
  static String? getUsername() {
    return _storage.read('username');
  }
}
