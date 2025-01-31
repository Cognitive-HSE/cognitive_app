import 'package:flutter/material.dart';

class CampimetryDescriptionScreen extends StatefulWidget {
  const CampimetryDescriptionScreen({super.key});

  @override
  State<CampimetryDescriptionScreen> createState() => _CampimetryDescriptionScreenState();
}

class _CampimetryDescriptionScreenState extends State<CampimetryDescriptionScreen> {

  @override
  void dispose() {
    super.dispose();
  }

  void _goToTest() {
    debugPrint("User are going to finish test");
    Navigator.pushNamedAndRemoveUntil(
        context,
        '/campimetryTest',
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
                  'Описание теста: \nНа первом этапе нужно нажимать кнопку "Добавить оттенок" пока силуэт не станет полностью видимым. После этого нужно выбрать силуэт. На втором этапе нужно нажимать кнопку "Убавить оттенок", пока силуэт не станет полностью невидимым, и когда решите, что больше не видите, нажимайте "Не вижу".',
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