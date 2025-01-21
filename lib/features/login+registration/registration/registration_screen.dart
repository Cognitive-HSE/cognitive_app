import 'package:bcrypt/bcrypt.dart';
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

  Future<void> _register() async {

    //block button
    setState(() {
      isButtonDisabled = true;
    });

    // Сброс блокировки кнопки через 3 секунды
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isButtonDisabled = false;
      });
    });

    final name = _nameController.text;
    final passwordHash = hashPassword(_passwordController.text);

    Navigator.of(context).pushNamed(
      '/successReg',
    );

    // if (name.isNotEmpty && passwordHash.isNotEmpty) {
    //   if (_passwordController.text == _repeatedPasswordController.text) {
    //     if (await tryRegister(name, passwordHash)) {
    //       AuthManager.setUserLoggedIn(true);

    //       debugPrint('Successful reg with Name: $name, Password: $passwordHash');

    //     if (mounted) {
    //     Navigator.of(context).pushNamed(
    //       '/successReg',
    //     );
    //     }
        
    //     } else {
    //       debugPrint("Не удалось зарегистрироваться");
    //       showSnackBar("Не удалось зарегистрироваться");
    //     }
    //   } else {
    //       debugPrint("Пароли не совпадают");
    //       showSnackBar("Пароли не совпадают");
    //   }
    // } else {
    //     debugPrint("Заполнены не все поля");
    //     showSnackBar("Заполнены не все поля");
    // }
  }

    String hashPassword(password) {

    final salt = r"$2a$10$qSMMbDD.1nFRJVUQxfi9ye";
    final passwordHash = BCrypt.hashpw(password, salt);

    return passwordHash;
  }

  // Future<bool> tryRegister(login, passwordHash) async {
  // try {
    
  //   final conn = await Connection.open(
  //     Endpoint(
  //       host: '79.137.204.140',
  //       port: 5000,
  //       database: 'cognitive_dev',
  //       username: 'cognitive_developer',
  //       password: 'cognitive_developer',
  //     ),
  //     settings: ConnectionSettings(sslMode: SslMode.disable),
  //   );

  //   debugPrint('Подключение к бд из tryRegister успешно');

  //   //request processing
  //   final authorizeUser = await conn.execute(
  //   Sql.named('SELECT cognitive."f\$users__register"(vp_username => @vp_username, vp_password_hash => @vp_password_hash)'),
  //   parameters: {
  //     'vp_username': '$login', 
  //     'vp_password_hash': '$passwordHash'
  //   },
  // );
  // final result = authorizeUser.first.first == null;
  // debugPrint('Result of reg: $result');

  // conn.close();
  // return result;
    
  // } catch (e) {
  //   debugPrint('Ошибка подключения к бд из tryRegister: $e');
  //   return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {

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
              onPressed: isButtonDisabled ? null : _register,
              child: const Text('Зарегистрироваться!'),
            ),
          ],
        ),
      ),
    );
  }
}
