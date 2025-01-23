import 'package:flutter/material.dart';

class SuccessLoginScreen extends StatefulWidget {

  const SuccessLoginScreen({
    super.key
    });

  @override
  State<SuccessLoginScreen> createState() => _SuccessLoginScreenState();
}

class _SuccessLoginScreenState extends State<SuccessLoginScreen> {


  @override
  void dispose() {
    super.dispose();
  }

  void _goToTests() {
    debugPrint("User are going to tests");
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/testList', 
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF373737), // Темный фон
      appBar: AppBar(
        title: const Text(
          'Успешный вход',
          style: TextStyle(color: Colors.white), // Белый цвет текста
        ),
        backgroundColor: const Color(0xFF373737),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Вы успешно вошли в свой аккаунт!',
               style: TextStyle(color: Colors.white), // Белый цвет текста
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: _goToTests,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A4A4A), //  цвет кнопки
                  foregroundColor: Colors.white, // цвет текста кнопки
                ),
              child: const Text('Выбрать тест'),
            ),
          ],
        ),
      ),
    );
  }
}