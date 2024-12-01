import 'package:flutter/material.dart';

class BirdTestDescriptionScreen extends StatefulWidget {
  const BirdTestDescriptionScreen({super.key});

  @override
  State<BirdTestDescriptionScreen> createState() => _BirdTestDescriptionScreenState();
}

class _BirdTestDescriptionScreenState extends State<BirdTestDescriptionScreen> {

  int testIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void _goToFinishTest() {
    debugPrint("User are going to finish test");
        Navigator.pushNamedAndRemoveUntil(
      context, 
      '/birdTest', 
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
            const Text('Описание теста: \nУкажите направление ласточки'),
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
