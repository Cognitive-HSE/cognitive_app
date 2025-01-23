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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                  width: 300,
                child: Text(
                  'Описание теста: \nНа экране появится животное, цвет которого будет близок к фону. Нажимайте кнопку "Еще раз", пока картинка не станет почти невидимой, и когда решите, что больше не видите, нажимайте "Не вижу".',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
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