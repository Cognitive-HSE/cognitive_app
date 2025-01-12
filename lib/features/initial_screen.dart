import 'package:flutter/material.dart';
import 'package:cognitive/features/login+registration/utils/auth_manager.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

void _checkLoginStatus() {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final isLoggedIn = AuthManager.isUserLoggedIn();
    debugPrint('isLoggedIn в InitialScreen: $isLoggedIn');
    
    if (isLoggedIn) {
      debugPrint('Пользователь авторизован, переход на /testList');
      Navigator.pushReplacementNamed(context, '/testList');
    } else {
      debugPrint('Пользователь не авторизован, переход на /registration');
      Navigator.pushReplacementNamed(context, '/login');
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Отображение индикатора загрузки
      ),
    );
  }
}
