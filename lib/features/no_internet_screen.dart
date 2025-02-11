import 'package:flutter/material.dart';

class NoInternetScreen extends StatefulWidget {

  const NoInternetScreen({
    super.key
    });

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF373737), // Темный фон
      appBar: AppBar(
        automaticallyImplyLeading: false, // Скрыть стрелку "Назад"
        title: const Text(
          'Ошибка',
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
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Уважаемый пользователь, приложение не может работать без интернета.\nПожалуйста подключитесь к сети и перезапустите приложение, чтобы проходить тесты.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Белый цвет текста
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}