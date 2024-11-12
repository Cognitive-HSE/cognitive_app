import 'package:flutter/material.dart';

class TestDescriptionScreen extends StatefulWidget {

  const TestDescriptionScreen({
    super.key
    });

  @override
  State<TestDescriptionScreen> createState() => _TestDescriptionScreenState();
}

class _TestDescriptionScreenState extends State<TestDescriptionScreen> {


  @override
  void dispose() {

    super.dispose();
  }

  void _goToFinishTest() {
    debugPrint("User are going to finish test");
    Navigator.of(context).pushNamed(
        '/successReg/testList/testDescription/oneTest',
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
              'Этот тест такой крутой и посвящен бла бла бла бла бла бла бла бла бла. \n Вам всего лишь надо  бла бла бла бла бла бла бла бла бла'
            ),
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