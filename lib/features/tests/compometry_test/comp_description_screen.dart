import 'package:flutter/material.dart';
import 'counter.dart';

class CampimetryDescriptionScreen extends StatefulWidget {
  const CampimetryDescriptionScreen({super.key});

  @override
  State<CampimetryDescriptionScreen> createState() =>
      _CampimetryDescriptionScreenState();
}

class _CampimetryDescriptionScreenState
    extends State<CampimetryDescriptionScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  void _goToTest() {
    retryCounter = 1;
    debugPrint("User are going to finish test");
    Navigator.pushNamedAndRemoveUntil(
        context, '/campimetryTest', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Компьютерная кампиметрия',
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
                  'Внимательно прочитайте задание',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 207, 52, 187), 
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '''Описание теста: \nНа первом этапе нужно нажимать кнопку "Добавить оттенок" пока силуэт не 
                  станет полностью видимым. После этого нужно выбрать силуэт. На втором этапе нужно нажимать 
                  кнопку "Убавить оттенок", пока силуэт не станет полностью невидимым, и когда решите, 
                  что больше не видите, нажимайте "Не вижу". Для Корректного результата необходимо пройти тест
                   \nКАК МИНИМУМ 7 РАЗ.\n Попытка №1
                  ''',
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
