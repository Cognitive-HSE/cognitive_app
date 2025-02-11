import 'package:cognitive/features/database_config.dart';
import 'package:cognitive/features/app_version/version_of_app.dart';
import 'package:flutter/material.dart';
import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:postgres/postgres.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatusAndAppVersion();
  }

Future<bool> isInternetConnection() async {
  return InternetConnectionChecker.instance.hasConnection;
}

Future<int?> getAppVersion() async {
  try {
    
    final conn = await Connection.open(
      Endpoint(
        host: DatabaseConfig.host,
        port: DatabaseConfig.port,
        database: DatabaseConfig.database,
        username: DatabaseConfig.username,
        password: DatabaseConfig.password,
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );

    debugPrint('Подключение к бд из getAppVersion успешно');

    //request processing
    final authorizeUser = await conn.execute(
    Sql.named('SELECT cognitive."f\$sys__get_version"()'));

  final result = authorizeUser.first.first as int?;
  conn.close();
  return result;
    
  } catch (e) {
    debugPrint('Ошибка подключения к бд из getAppVersion: $e');
    return null;
    }
  }

Future<bool> _checkAppVersion() async {
  final newestVersion = await getAppVersion();
  final currentAppVersion = VersionOfApp.verison;
  debugPrint('currentAppVersion в InitialScreen: $currentAppVersion');

  if (currentAppVersion == newestVersion) {
    debugPrint('Версия приложения актуальна');
    return true;
  } else {
    debugPrint('Версия приложения устарела');
    return false;
  }
}

void _checkLoginStatusAndAppVersion() {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final isInternetConnected = await checkInternetConnection();
    if (!isInternetConnected) {
      return;
    } else {

    final isLoggedIn = AuthManager.isUserLoggedIn();
    final isVersionActual = await _checkAppVersion();
    debugPrint('isLoggedIn в InitialScreen: $isLoggedIn');
    debugPrint('isVersionActual в InitialScreen: $isVersionActual');
    if (isVersionActual == false) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/updateAppScreen');
      }
      return;
    } else {
    if (isLoggedIn) {
      debugPrint('Пользователь авторизован, переход на /testList');
      if (mounted) {
      Navigator.pushReplacementNamed(context, '/testList');
      }
    } else {
      debugPrint('Пользователь не авторизован, переход на /registration');
      if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
      }
    }
    }
    }
  });
}

Future<bool> checkInternetConnection() async {
      final isInternetConnected = await isInternetConnection();

      if (!isInternetConnected) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/noInternetScreen');
      }
      return false;
      } 
      return true;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF373737), // Темный фон
      appBar: AppBar(
        title: const Text(
          'Вход в приложение...',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF373737),
        centerTitle: true,
        elevation: 0, // Убираем тень от AppBar
      ),
      body: Center(
        
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 205, 140, 227)),
        ), // Отображение индикатора загрузки
      ),
    );
  }
}
