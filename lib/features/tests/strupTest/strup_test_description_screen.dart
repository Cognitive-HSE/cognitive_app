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
        title: const Text(
          'Тест "Струпа"',
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
                  '''Описание теста:\nТест Струпа:\nТест проходит в 3 этапа. На 1 этапе вам предстоит выбрать показанный цвет
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