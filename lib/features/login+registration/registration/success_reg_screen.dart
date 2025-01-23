import 'package:flutter/material.dart';

class SuccessRegScreen extends StatefulWidget {
  const SuccessRegScreen({super.key});

  @override
  State<SuccessRegScreen> createState() => _SuccessRegScreenState();
}

class _SuccessRegScreenState extends State<SuccessRegScreen> {

@override
  void dispose() {
    super.dispose();
  }

  void _goToTests() {
    debugPrint("User are going to tests");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/testList',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF373737), // Темный фон
      appBar: AppBar(
        automaticallyImplyLeading: false, // Скрыть стрелку "Назад"
        title: const Text(
          'Успешная регистрация',
          style: TextStyle(color: Colors.white),
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
              'Вы успешно зарегистрировались!',
              style: TextStyle(color: Colors.white),
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