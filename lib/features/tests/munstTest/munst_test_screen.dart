import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import 'package:postgres/postgres.dart';

class MunstTestScreen extends StatefulWidget {
  const MunstTestScreen({super.key});

  @override
  State<MunstTestScreen> createState() => _MunstTestScreenState();
}

class _MunstTestScreenState extends State<MunstTestScreen> {
  // Символы и выделенные индексы
  final testId = 1;
  final _formKey = GlobalKey<FormState>();
  List<String> characters = [];
  List<int> selectedIndexes = [];
  List<String> dictionary = [
    'ДОМ',
    'ГОРН',
    'ПОПКОРН',
    'КРАБ',
    'РАБ',
    'БАБУШКА',
    'ИНФУЗОРИЯ',
    'БАСНЯ',
    'БАЯН',
    'ВАХТА',
    'ГУСЬ',
    'ДЕНЬ',
    'ЗАКАТ',
    'ИНДЕЙКА',
    'ЛИЛИЯ',
    'САПЕР',
    'ОЗЕРО',
    'ЗИМА',
    'ПАДЕЖ',
    'ПОЛЕТ',
    'ПУЛЯ',
    'ПУТЬ',
    'РУЖЬЕ',
    'РЕМЕСЛО',
    'УЛИТКА',
    'ХЛЕБ',
    'ЦАРЬ',
    'ЦЕВЬЕ',
    'ХАМАМ',
    'ПЛАТЬЕ',
    'ПОЛОТЕНЦЕ',
    'СОЛНЦЕ',
    'ОДЕЯЛО',
    'ОБУВЬ',
    'ПОДОШВА',
    'ОДЕЖДА',
    'ЗАЯЦ',
    'СИРЕНЬ',
    'СТАНЦИЯ',
    'БЕГЛЕЦ',
    'АЗАРТ',
    'БОРОДА',
    'ЧУЧЕЛО',
    'БОГАТСТВО',
    'ОДЕКОЛОН',
    'БАЗАР',
    'РАССУДОК',
    'ГРЯЗЬ',
    'ОБЛАКО',
    'ЗАГАДКА',
    'ЗАДАЧА',
    'ЦЕЛЬ',
    'ПУТЬ',
    'СОЗВЕЗДИЕ',
    'ОБЛИК',
    'ЗНАК',
    'КОНФИГУРАЦИЯ',
    'ПУСТОТА',
    'ЗАМКНУТОСТЬ',
    'СИНГУЛЯРНОСТЬ',
    'ОБРЫВ',
    'ОГРАНИЧЕНИЕ',
    'УГРОЗА',
    'ОБЩЕСТВО',
    'РИНГ',
    'КЛУБ',
    'БОЕЦ',
    'КАРАТЭ',
    'ОБЕЗЬЯНА',
    'СОВЕСТЬ',
    'СЛОВО',
    'ЧЕСТЬ',
    'ВРЕМЯ',
    'СКОРОСТЬ',
    'МАНЕВР',
    'ОБГОН',
    'ПОВОРОТ',
    'ПРИБЫЛЬ',
    'УБЫТОК',
    'НЕДОСТАЧА',
    'УЧЕТ',
    'ЗАМЕТКА',
    'ПОЛОСТЬ',
    'ДЫРА',
    'БОБЕР',
    'СОВА'
  ]; // Список слов, которые нужно найти
  List<String> wordsToFind = [];
  int seconds = 0;
  int foundWords = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _generateCharacters(200);
    seconds = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        seconds++;
      });
    });
  }

// Выделенные буквы
  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
  }

//сколько выделено слов
  void _checkWords() {
    // int foundWords = 0;
    for (int i = 0; i < characters.length; ++i) {
      if (selectedIndexes.contains(i)) {
        if (List.generate(wordsToFind.length, (int k) => wordsToFind[k][0])
            .contains(characters[i])) {
          for (int j = 0; j < wordsToFind.length; ++j) {
            if (characters.sublist(i, i + wordsToFind[j].length).join() ==
                wordsToFind[j]) {
              if (selectedIndexes.toSet().containsAll(
                  List.generate(wordsToFind[j].length, (int m) => i + m))) {
                if (!(selectedIndexes.contains(i + wordsToFind[j].length) ||
                    selectedIndexes.contains(i - 1))) {
                  foundWords++;
                  break;
                }
              }
            }
          }
        }
      }
    }

    //результаты теста в бд
    //resultsToDB();

    timer.cancel(); // stop timer when results shown
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Text("Найдено слов: $foundWords\nВремя в секундах: $seconds"),
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700], // Цвет кнопки
                  foregroundColor: Colors.white, // Цвет текста кнопки
                  minimumSize: const Size(200, 50), // Размер кнопки
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Скругленные углы
                  ),
                ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/testList', (route) => false);
              },
              child: const Text('OK'))
        ],
      ),
    );
  }

  Future<bool> resultsToDB() async {
  try {
    
    final conn = await Connection.open(
      Endpoint(
        host: '79.137.204.140',
        port: 5000,
        database: 'cognitive_dev',
        username: 'cognitive_developer',
        password: 'cognitive_developer',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );

    debugPrint('Подключение к бд из resultsToDB успешно');

    final secodsInterval = formatToInterval(seconds);
    //final userName = AuthManager.getUsername();

    //request processing
    final sendResults = await conn.execute(
    Sql.named('''
    SELECT cognitive."f\$test_results__write2"(
    vp_user_name => @vp_user_name, 
    vp_test_id => @vp_test_id,
    vp_number_all_answers => @vp_number_all_answers,
    vp_number_correct_answers => @vp_number_correct_answers,
    vp_complete_time => @vp_complete_time
    )'''
    ),
    parameters: {
      //'vp_user_name': '$userName', 
      'vp_test_id': testId,
      'vp_number_all_answers': wordsToFind.length,
      'vp_number_correct_answers': foundWords,
      'vp_complete_time': secodsInterval,
      
    },
  );
  debugPrint('$sendResults');
  final result = sendResults.isEmpty == true;

  conn.close();
  return result;
    
  } catch (e) {
    debugPrint('Ошибка подключения к бд из resultsToDB: $e');
    return false;
    }
  }

//генерация случайного ряда русских букв
  void _generateCharacters(int numberOfChar) {
    int i = 0;
    var randomCharacter = Random();
    wordsToFind = List.generate(
        8, (int k) => dictionary[Random().nextInt(dictionary.length)]);
    var indices = List.generate(wordsToFind.length,
        (int k) => randomCharacter.nextInt(199 - wordsToFind[i].length));
    characters = List.generate(numberOfChar, (index) {
      // Генерируем случайные буквы, вставляя слова
      if (i < wordsToFind.length) {
        if (indices.contains(index) && !indices.contains(index + 1)) {
          return wordsToFind[i++];
        }
      }
      return String.fromCharCode(1040 +
          randomCharacter.nextInt(32) % 32); // Псевдослучайные русские буквы
    }).expand((s) => s.split("")).toList();
    setState(() {});
  }

  String formatToInterval(int secs) {
  int hours = secs ~/ 3600; // Часы
  int minutes = (secs % 3600) ~/ 60; // Минуты
  int seconds = secs % 60; // Секунды

  // Форматируем с ведущими нулями
  String hoursStr = hours.toString().padLeft(2, '0');
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = seconds.toString().padLeft(2, '0');

  return '$hoursStr:$minutesStr:$secondsStr';
}

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Тест Мюнстерберга',
          style: TextStyle(color: Colors.white), // Белый цвет текста
        ),
        backgroundColor: Color(0xFF373737), 
        centerTitle: true,
      ),
      body: Form(
        
        key: _formKey,
        child: Column(
          children: [
            const Text('Выделите слова'),
            Text('Прошло $seconds секунд'),
            const SizedBox(
              height: 30,
            ),

            // Прокручиваемая область для символов
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  children: List.generate(characters.length, (index) {
                    return GestureDetector(
                      onTap: () => _toggleSelection(index),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: selectedIndexes.contains(index)
                            ? Colors.green
                            : Colors.white,
                        child: Text(characters[index],
                            style: const TextStyle(fontSize: 24)),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700], // Цвет кнопки
                  foregroundColor: Colors.white, // Цвет текста кнопки
                  minimumSize: const Size(200, 50), // Размер кнопки
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Скругленные углы
                  ),
                ),
              onPressed: _checkWords,
              child: const Text('Результаты'),
            ),

            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}