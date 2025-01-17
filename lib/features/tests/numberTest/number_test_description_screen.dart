import 'package:flutter/material.dart';

class NumberTestDescriptionScreen extends StatefulWidget {
  const NumberTestDescriptionScreen({super.key});

  @override
  State<NumberTestDescriptionScreen> createState() => _NumberTestDescriptionScreenState();
}

class _NumberTestDescriptionScreenState extends State<NumberTestDescriptionScreen> {
  
  @override
  void dispose() {
    super.dispose();
  }

  void _goToFinishTest() {
    debugPrint("User are going to finish test");
        Navigator.pushNamedAndRemoveUntil(
      context, 
      '/numberTest', 
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
          'Описание теста: \nВам будут показаны числа. Запомните их и впишите в соответствующие поля.',
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
