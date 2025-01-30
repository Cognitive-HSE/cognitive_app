import 'package:flutter/material.dart';

class ColorBlindTestDescriptionScreen extends StatefulWidget {
  const ColorBlindTestDescriptionScreen({super.key});

  @override
  State<ColorBlindTestDescriptionScreen> createState() => _ColorBlindTestDescriptionScreenState();
}

class _ColorBlindTestDescriptionScreenState extends State<ColorBlindTestDescriptionScreen> {

  @override
  void dispose() {
    super.dispose();
  }

    void _goToTest() {
    debugPrint("User are going to finish test");
        Navigator.pushNamedAndRemoveUntil(
      context,
      '/stroupHardTest',
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Тест Струпа усложненный',
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
                  'Описание теста:\n\nНа экране появится животное, цвет которого будет близок к фону. Нажимайте кнопку "Еще раз", пока картинка не станет почти невидимой, и когда решите, что больше не видите, нажимайте "Не вижу".',
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
                onPressed: _goToTest,
                child: const Text('Начать тест'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}