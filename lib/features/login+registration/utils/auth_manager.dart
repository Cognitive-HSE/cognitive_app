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
  }
}
