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
        //title: const Text('Test Description'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Возвращает пользователя на предыдущий экран
          },
        ),
      ),
      body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [

      SizedBox(
        width: 300, // Ограничение ширины текста
        child: const Text(
          '''Описание теста: \n
          Пятнашки — это головоломка на поле 4x4, состоящая из 15 костяшек и одной пустой клетки.
          \nЦель игры: упорядочить костяшки по возрастанию, начиная с левого верхнего угла. Нажимайте на костяшки рядом с пустой клеткой, чтобы перемещать их. Задача — собрать головоломку за наименьшее количество ходов.
          \nДля таких игр характерно большое количество комбинаций. Чтобы успешно решить задачу, просчитывайте ходы на несколько шагов вперёд, развивая критическое мышление. 
          \nУдачи!
          ''',
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 20), // Добавление отступа
      ElevatedButton(
        onPressed: _goToFinishTest,
        child: const Text('Начать тест'),
      ),
    ],
  ),
),

    );
  }
}
