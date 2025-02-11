import 'package:cognitive/cognitive_app.dart';
import 'package:cognitive/features/database_config.dart';
import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dictionary.dart';

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
  List<int> resIndexes = [];
  List<String> wordsToFind = [];
  bool isButtonDisabled = true;
  bool isOver = false;
  int seconds = 0;
  int foundWords = 0;
  int startIndex = 0;
  int endIndex = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _generateCharacters(200);
    seconds = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (seconds == 120) {
        timer.cancel();
        _checkWords();
      }
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
      if (List.generate(wordsToFind.length, (int k) => wordsToFind[k][0])
          .contains(characters[i])) {
        for (int j = 0; j < wordsToFind.length; ++j) {
          if (wordsToFind[j].length < characters.length - i) {
            if (characters.sublist(i, i + wordsToFind[j].length).join() ==
                wordsToFind[j]) {
              if (selectedIndexes.toSet().containsAll(
                  List.generate(wordsToFind[j].length, (int m) => i + m))) {
                if (!(selectedIndexes.contains(i + wordsToFind[j].length) ||
                    selectedIndexes.contains(i - 1))) {
                  foundWords++;
                  break;
                }
              } else {
                resIndexes.addAll(
                    List.generate(wordsToFind[j].length, (int m) => i + m));
              }
            }
          }
        }
      }
    }

    //результаты теста в бд
    resultsToDB();

    timer.cancel(); // stop timer when results shown

    isButtonDisabled = false;
    isOver = true;

    setState(() {});
  }

  void _dialog() {
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
          host: DatabaseConfig.host,
          port: DatabaseConfig.port,
          database: DatabaseConfig.database,
          username: DatabaseConfig.username,
          password: DatabaseConfig.password,
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );

      debugPrint('Подключение к бд из resultsToDB успешно');

      final secodsInterval = formatToInterval(seconds);
      final userId = AuthManager.getUserId();

      //request processing
      final sendResults = await conn.execute(
        Sql.named('''
    SELECT cognitive."f\$test_results__write"(
    vp_user_id => @vp_user_id, 
    vp_test_id => @vp_test_id,
    vp_number_all_answers => @vp_number_all_answers,
    vp_number_correct_answers => @vp_number_correct_answers,
    vp_complete_time => @vp_complete_time
    )'''),
        parameters: {
          'vp_user_id': userId,
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
      _showDatabaseError('Не удалось сохранить результаты теста');
      return false;
    }
  }

  void _showDatabaseError(String errorMessage) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Color.fromARGB(255, 227, 49, 37),
        duration: const Duration(seconds: 3),
      ),
    );
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
          indices = List.generate(wordsToFind.length - i,
              (int k) => randomCharacter.nextInt(199 - index) + index + 2);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/testList', // Название экрана, на который нужно перейти
                (route) => false, // Удаляет все предыдущие экраны из стека
              );
            },
          ),
        ],
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
            const SizedBox(
              height: 10,
            ),
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
                        color: resIndexes.contains(index)
                            ? Colors.red
                            : selectedIndexes.contains(index)
                                ? Colors.green
                                : Colors.white,
                        child: Text(
                          characters[index],
                          style: const TextStyle(fontSize: 24),
                        ),
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
              onPressed: isButtonDisabled ? null : _dialog,
              child: const Text('Результаты'),
            ),
            const SizedBox(
              height: 10,
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
              onPressed: isOver ? null : _checkWords,
              child: const Text('Подтвердить'),
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
