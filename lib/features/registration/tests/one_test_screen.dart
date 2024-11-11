import 'package:flutter/material.dart';

class OneTestScreen extends StatefulWidget {

  const OneTestScreen({
    super.key
    });

  @override
  State<OneTestScreen> createState() => _OneTestScreenState();
}

class _OneTestScreenState extends State<OneTestScreen> {


  @override
  void dispose() {

    super.dispose();
  }

  void _finish() {
    debugPrint("User wants to finish test");
    Navigator.of(context).pushNamed(
      '/successReg/testList'
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
  
          children: [
            const Text(
              'Тут будет правда будет тест'
            ),
            ElevatedButton(
              onPressed: _finish,
              child: const Text('Завершить'),
            ),
          ],
        ),
      ),
    );
  }
}