import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';

class TestsListScreen extends StatefulWidget {
  const TestsListScreen({super.key});

  @override
  State<TestsListScreen> createState() => _TestsListScreenState();
}

class _TestsListScreenState extends State<TestsListScreen> {
  Map tests = {
    0: "Тест Мюнстерберга",
    1: "Тест \"Ласточка\"",
    2: "Тест \"Запоминание чисел\"",
    3: "Тест \"Пятнашки\"",
    4: "Тест \"Струпа\"", 
    //5: "Тест \"Струпа оттенки\"", 
  };

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
    if (testIndex == 4) {
      Navigator.of(context).pushNamed(
        '/testList/stroopColorTestDescription', // Замените на ваш путь
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF373737), // Цвет фона как на фото
      appBar: AppBar(
        backgroundColor: const Color(0xFF373737), // Цвет AppBar в тон фона
        title: const Text(
          'Подборка тестов', // Заголовок как на фото
          style: TextStyle(color: Colors.white), // Белый цвет текста
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white, // Белый цвет иконки logout
            ),
            onPressed: () {
              //AuthManager.setUserLoggedIn(false); // Раскомментируйте, если нужно
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: ListView.builder( // Используем ListView.builder для более гибкой настройки отступов
        itemCount: tests.length,
        itemBuilder: (context, i) {
          final index = tests.keys.elementAt(i);
          final test = tests[index];

          return Padding( // Добавляем отступы вокруг карточки
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4A4A4A), // Цвет карточки как на фото
                borderRadius: BorderRadius.circular(10.0), // Скругление углов
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Отступы внутри ListTile
                title: Text(
                  '$test', // Убрали индекс, как на фото
                  style: const TextStyle(color: Colors.white, fontSize: 18), // Белый цвет текста и размер
                ),
                subtitle: const Text( // Добавляем subtitle
                  'Когнитивный тест',
                  style: TextStyle(color: Colors.grey, fontSize: 14), // Стиль для subtitle
                ),
                trailing: ClipRRect( // Оборачиваем Image.asset в ClipRRect
                  borderRadius: BorderRadius.circular(10.0), // Радиус скругления углов
                  child: Image.asset(
                    'assets/test_design/test${index + 1}.png',
                    width: 120, // Можно задать размеры, если нужно
                    height: 120,
                    fit: BoxFit.cover, // Важно для корректного отображения внутри ClipRRect
                  ),
                ),
                onTap: () {
                  _goToChosenTest(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}