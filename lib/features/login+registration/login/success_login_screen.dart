import 'package:flutter/material.dart';

class SuccessLoginScreen extends StatefulWidget {

  const SuccessLoginScreen({
    super.key
    });

  @override
  State<SuccessLoginScreen> createState() => _SuccessLoginScreenState();
}

class _SuccessLoginScreenState extends State<SuccessLoginScreen> {


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
              'Вы успешно вошли в свой аккаунт!',
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