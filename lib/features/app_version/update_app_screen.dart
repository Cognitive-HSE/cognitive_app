import 'package:flutter/material.dart';

class UpdateAppScreen extends StatefulWidget {

  const UpdateAppScreen({
    super.key
    });

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {


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
                  'Уважаемый пользователь, ваша версия приложения устарела.\nПожалуйста, обновите ее для того, чтобы и дальше проходить тесты.',
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