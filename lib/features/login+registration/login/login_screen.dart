import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cognitive/features/login+registration/widgets/widgets.dart';
import 'package:postgres/postgres.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final name = _nameController.text;
    final password = _passwordController.text;

    // Добавить логику авторизации пользователя в будущем
    debugPrint('Name: $name, Password: $password');

    AuthManager.setUserLoggedIn(true);
    final isLoggedIn = AuthManager.isUserLoggedIn();
    debugPrint('Флаг isLoggedIn: $isLoggedIn');

    Navigator.of(context).pushNamed(
      '/successLogin',
    );
  }

  void _goToRegisterScreen() {
    Navigator.of(context).pushNamed('/registration');
  }

  Future<void> operation() async {
  try {
    // Попытка подключения к базе данных
    final conn = await Connection.open(
      Endpoint(
        host: '79.137.204.140',
        port: 5000,
        database: 'cognitive_dev',
        username: 'cognitive_developer',
        password: 'cognitive_developer',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );

    // Если соединение установлено, выводим сообщение
    debugPrint('Подключение к бд успешно!');
    
  } catch (e) {
    // Обработка ошибок
    debugPrint('Ошибка подключения к бд: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    // Подключаемся к бд
    operation();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hintText: 'Введите никнейм',
              controller: _nameController,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              hintText: 'Введите пароль',
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Войти!'),
            ),
            const SizedBox(height: 20.0),
            RichText(
              text: TextSpan(
                text: 'Нет аккаунта? ',
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Зарегистрироваться',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 117, 57, 208),
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _goToRegisterScreen,
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
