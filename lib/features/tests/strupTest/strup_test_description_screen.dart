import 'package:flutter/material.dart';

class StrupTestDescriptionScreen extends StatefulWidget {
  const StrupTestDescriptionScreen({super.key});

  @override
  State<StrupTestDescriptionScreen> createState() => _StrupTestDescriptionScreenState();
}

class _StrupTestDescriptionScreenState extends State<StrupTestDescriptionScreen> {
  
  @override
  void dispose() {
    super.dispose();
  }

  void _goToFinishTest() {
    debugPrint("User are going to finish test");
        Navigator.pushNamedAndRemoveUntil(
      context, 
      '/strupTest', 
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
          'Описание теста: \nТест Струпа.',
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