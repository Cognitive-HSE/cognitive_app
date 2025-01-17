import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';

class TestsListScreen extends StatefulWidget {

  const TestsListScreen({
    super.key
    });

  @override
  State<TestsListScreen> createState() => _TestsListScreenState();
}

class _TestsListScreenState extends State<TestsListScreen> {
  Map tests = {0: "Тест Мюнстерберга", 1: "Тест \"Ласточка\"", 2: "Тест \"Запоминание чисел\"",
  3: "Тест \"Пятнашки\""};


  @override
  void dispose() {
    super.dispose();
  }

  void _goToChosenTest(int testIndex) {

    debugPrint("User are going to chosen test");

    if (testIndex == 0) {
      Navigator.of(context).pushNamed(
        '/testList/munstTestDescription',
      );
    }
    if (testIndex == 1) {
      Navigator.of(context).pushNamed(
        '/testList/birdTestDescription',
      );
    }
    if (testIndex == 2) {
      Navigator.of(context).pushNamed(
        '/testList/numberTestDescription',
      );
    }
    if (testIndex == 3) {
            Navigator.of(context).pushNamed(
        '/testList/tagTestDescription',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Список тестов'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              //color: Colors.white,
            ),
            onPressed: () {
              AuthManager.setUserLoggedIn(false);
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),

      body: ListView.separated(
        itemCount: tests.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, i) { 
          // Получаем ключ и значение из словаря
          final index = tests.keys.elementAt(i);
          final test = tests[index];

          return ListTile(
            title: Text('$index) $test'),
            trailing: const Icon(Icons.keyboard_double_arrow_right),
            onTap: () {
            _goToChosenTest(index);
            },
          );
        },
      ),
    );
  }
  
}