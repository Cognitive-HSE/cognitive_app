import 'package:flutter/material.dart';

class TagTestDescriptionScreen extends StatefulWidget {
  const TagTestDescriptionScreen({super.key});

  @override
  State<TagTestDescriptionScreen> createState() => _TagTestDescriptionScreenState();
}

class _TagTestDescriptionScreenState extends State<TagTestDescriptionScreen> {
  
  @override
  void dispose() {
    super.dispose();
  }

  void _goToFinishTest() {
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/tagTest', 
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Тест "Пятнашки"',
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
                  '''Описание теста: \n
                  Пятнашки — это головоломка на поле 4x4, состоящая из 15 костяшек и одной пустой клетки.
                  \nЦель игры: упорядочить костяшки по возрастанию, начиная с левого верхнего угла. Нажимайте на костяшки рядом с пустой клеткой, чтобы перемещать их. Задача — собрать головоломку за наименьшее количество ходов.
                  \nДля таких игр характерно большое количество комбинаций. Чтобы успешно решить задачу, просчитывайте ходы на несколько шагов вперёд, развивая критическое мышление. 
                  \nУдачи!
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