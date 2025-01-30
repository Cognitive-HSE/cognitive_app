import 'package:flutter/material.dart';

class MunstTestDescriptionScreen extends StatefulWidget {
  const MunstTestDescriptionScreen({super.key});

  @override
  State<MunstTestDescriptionScreen> createState() =>
      _MunstTestDescriptionScreenState();
}

class _MunstTestDescriptionScreenState
    extends State<MunstTestDescriptionScreen> {
  int testIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void _goToFinishTest() {
    debugPrint("User are going to finish test");
    Navigator.pushNamedAndRemoveUntil(context, '/munstTest', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Тест Мюнстерберга',
          style: TextStyle(color: Colors.white), // Белый цвет текста
        ),
        backgroundColor: Color(0xFF373737),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Color(0xFF373737), // Фон страницы
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Описание теста:\n\n'
                  'Среди буквенного текста имеются слова. Ваша задача - просматривая строку за строкой, как можно быстрее найти эти слова и выделить их нажатием на каждую букву из найденного слова',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Белый цвет текста
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700], // Цвет кнопки
                  foregroundColor: Colors.white, // Цвет текста кнопки
                  minimumSize: const Size(200, 50), // Размер кнопки
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Скругленные углы
                  ),
                ),
                onPressed: _goToFinishTest,
                child: const Text('Начать тест'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
