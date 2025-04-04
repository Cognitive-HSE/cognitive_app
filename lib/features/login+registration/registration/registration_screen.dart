import 'package:bcrypt/bcrypt.dart';
import 'package:cognitive/features/database_config.dart';
import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';
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

    if (name.isNotEmpty && passwordHash.isNotEmpty) {
      if (_passwordController.text == _repeatedPasswordController.text) {
        final userIdIfRegister = await tryRegister(name, passwordHash);
        if (userIdIfRegister is int) {
          AuthManager.setUsername(name);
          AuthManager.setUserId(userIdIfRegister);
                 
          debugPrint('Successful reg with Name: $name, Password: $passwordHash');

        if (mounted) {

        Navigator.of(context).pushNamed(
          '/surveyScreen',
        );
        }
        
        } else {
          debugPrint("Не удалось зарегистрироваться");
          showSnackBar("Не удалось зарегистрироваться");
        }
      } else {
          debugPrint("Пароли не совпадают");
          showSnackBar("Пароли не совпадают");
      }
    } else {
        debugPrint("Заполнены не все поля");
        showSnackBar("Заполнены не все поля");
    }
  }

    String hashPassword(password) {

    final salt = r"$2a$10$qSMMbDD.1nFRJVUQxfi9ye";
    final passwordHash = BCrypt.hashpw(password, salt);

    return passwordHash;
  }

  Future<int?> tryRegister(login, passwordHash) async {
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

    debugPrint('Подключение к бд из tryRegister успешно');

    //request processing
    final registerUser = await conn.execute(
    Sql.named('SELECT cognitive."f\$users__register"(vp_username => @vp_username, vp_password_hash => @vp_password_hash)'),
    parameters: {
      'vp_username': '$login', 
      'vp_password_hash': passwordHash
    },
  );
  final result = registerUser.first.first as int?;

  conn.close();
  return result;
    
  } catch (e) {
    debugPrint('Ошибка подключения к бд из tryRegister: $e');
    return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF373737), // Фон
      appBar: AppBar(
        title: const Text(
          'Регистрация',
          style: TextStyle(color: Colors.white), // Белый цвет текста
        ),
        backgroundColor: const Color(0xFF373737),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4A4A4A),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    hintText: 'Придумайте логин',
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
                    hintText: 'Придумайте пароль',
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
                controller: _repeatedPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    hintText: 'Повторите пароль',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: isButtonDisabled ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A4A4A), //  цвет кнопки
                  foregroundColor: Colors.white, // цвет текста кнопки
                ),
              child: const Text('Зарегистрироваться!'),
            ),
          ],
        ),
      ),
    );
  }
}