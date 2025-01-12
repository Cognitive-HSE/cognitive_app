import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:cognitive/features/login+registration/widgets/widgets.dart';
import 'package:postgres/postgres.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatedPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    final name = _nameController.text;
    final password = _passwordController.text;
    final repeatedPassword = _repeatedPasswordController.text;

    // Добавить логику регистрации пользователя в будущем
    debugPrint('Name: $name, Password: $password, Repeated password: $repeatedPassword');

    AuthManager.setUserLoggedIn(true);
    final isLoggedIn = AuthManager.isUserLoggedIn();
    debugPrint('Флаг isLoggedIn: $isLoggedIn');

    Navigator.of(context).pushNamed(
      '/successReg',
    );
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
        title: const Text('Регистрация'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hintText: 'Придумайте никнейм',
              controller: _nameController,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              hintText: 'Придумайте пароль',
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              hintText: 'Повторите пароль',
              isPassword: true,
              controller: _repeatedPasswordController,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Зарегистрироваться!'),
            ),
          ],
        ),
      ),
    );
  }
}
