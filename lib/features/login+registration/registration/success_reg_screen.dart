import 'package:flutter/material.dart';

class SuccessRegScreen extends StatefulWidget {

  const SuccessRegScreen({
    super.key
    });

  @override
  State<SuccessRegScreen> createState() => _SuccessRegScreenState();
}

class _SuccessRegScreenState extends State<SuccessRegScreen> {


  @override
  void dispose() {
    super.dispose();
  }

  void _goToTests() {
    debugPrint("User are going to tests");
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/testList', 
      (route) => false
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
              'Вы успешно зарегистрировались!',
            ),

            const SizedBox(height: 15.0),

            ElevatedButton(
              onPressed: _goToTests,
              child: const Text('Выбрать тест'),
            ),
          ],
        ),
      ),
    );
  }
}