import 'package:bcrypt/bcrypt.dart';
import 'package:cognitive/features/database_config.dart';
import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isButtonDisabled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void showSnackBar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text(message),
      backgroundColor: Color.fromARGB(255, 227, 49, 37),
      duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _login() async {
    if (!mounted) return;
    //block button
    setState(() {
      isButtonDisabled = true;
    });

    // Сброс блокировки кнопки через 3 секунды
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
      setState(() {
        isButtonDisabled = false;
      });
      }
    });

    final name = _nameController.text;
    final password = _passwordController.text;

    if (name.isNotEmpty && password.isNotEmpty) {
      final userIdIfLoggin = await tryLogin(name, password);
      debugPrint('$userIdIfLoggin');
      if (userIdIfLoggin is int) {
        AuthManager.setUserLoggedIn(true);
        AuthManager.setUsername(name);
        AuthManager.setUserId(userIdIfLoggin);

        debugPrint('Successful auth with Name: $name, Password: $password');

        if (mounted) {
        Navigator.of(context).pushNamed(
          '/successLogin',
        );
        }

      } else {
        debugPrint("Не удалось войти");
        if (mounted) showSnackBar("Не удалось войти");
      }
    } else {
        debugPrint("Заполнены не все поля");
        if (mounted) showSnackBar("Заполнены не все поля");
    }
  }

  String hashPassword(password) {

    final salt = r"$2a$10$qSMMbDD.1nFRJVUQxfi9ye";
    final passwordHash = BCrypt.hashpw(password, salt);

    return passwordHash;
  }

  Future<int?> tryLogin(login, password) async {
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

    debugPrint('Подключение к бд из tryLogin успешно');

    final passwordHash = hashPassword(password);

    //request processing
    final authorizeUser = await conn.execute(
    Sql.named('SELECT cognitive."f\$users__auth"(vp_username => @vp_username, vp_password_hash => @vp_password_hash)'),
    parameters: {
      'vp_username': '$login', 
      'vp_password_hash': passwordHash
    },
  );
  final result = authorizeUser.first.first as int?;

  conn.close();
  return result;
    
  } catch (e) {
    debugPrint('Ошибка подключения к бд из tryLogin: $e');
    return null;
    }
  }

  void _goToRegisterScreen() {
    Navigator.of(context).pushNamed('/registration');
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF373737), // Фон как на скрине
      appBar: AppBar(
        title: const Text(
          'Вход',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF373737),
        centerTitle: true,
        elevation: 0, // Убираем тень от AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CustomTextField
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4A4A4A),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    hintText: 'Введите логин',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                
              ),
            ),
             const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4A4A4A),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                 decoration: const InputDecoration(
                    hintText: 'Введите пароль',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
               
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: isButtonDisabled ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A4A4A), //  цвет кнопки
                  foregroundColor: Colors.white, // цвет текста кнопки
                ),
              child: const Text('Войти!'),
            ),
            const SizedBox(height: 20.0),
            RichText(
              text: TextSpan(
                text: 'Нет аккаунта? ',
                style: const TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: 'Зарегистрироваться',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 205, 140, 227),
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap =_goToRegisterScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
