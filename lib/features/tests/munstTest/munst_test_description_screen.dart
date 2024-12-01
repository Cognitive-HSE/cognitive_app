import 'package:flutter/material.dart';

class MunstTestDescriptionScreen extends StatefulWidget {
  const MunstTestDescriptionScreen({super.key});

  @override
  State<MunstTestDescriptionScreen> createState() => _MunstTestDescriptionScreenState();
}

class _MunstTestDescriptionScreenState extends State<MunstTestDescriptionScreen> {
  
  int testIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void _goToFinishTest() {
    debugPrint("User are going to finish test");
        Navigator.pushNamedAndRemoveUntil(
      context, 
      '/munstTest', 
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
            const Text('Описание теста: \nНайдите и выделите слова'),
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
