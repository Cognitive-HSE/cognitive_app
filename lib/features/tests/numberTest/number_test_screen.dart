import 'dart:async';
import 'dart:math';
import 'package:cognitive/cognitive_app.dart';
import 'package:cognitive/features/database_config.dart';
import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgres/postgres.dart';

class NumberTestScreen extends StatefulWidget {
  const NumberTestScreen({Key? key}) : super(key: key);

  @override
  State<NumberTestScreen> createState() => _NumberTestScreenState();
}

class _NumberTestScreenState extends State<NumberTestScreen> {
  int testId = 3;
  int startNumberCount = 4;
  int finishNumberCount = 7;
  int rightAnswers = 0;
  int allAnswers = 0;
  List<int> numbersToRemember = [];
  String userSequence = '';
  bool showNumbers = false;
  bool testCompleted = false;

  @override
  void initState() {
    super.initState();
    allAnswers = finishNumberCount - startNumberCount + 1;
    generateNumbers();
  }

  void generateNumbers() {
    numbersToRemember = List.generate(startNumberCount, (index) => Random().nextInt(10));
    userSequence = '';
    setState(() {
      showNumbers = true;
      testCompleted = false;
    });

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
      setState(() {
        showNumbers = false;
      });
      }
    });
  }

  void checkAnswer() {
    setState(() {
      testCompleted = true;
    });
  }

  void goToNextTest() {
    List<int> userAnswer = userSequence.split('').map(int.parse).toList();

    // Проверка ответа до увеличения startNumberCount
    if (userAnswer.toString() == numbersToRemember.toString()) {
      rightAnswers++;
    }

    // Если тест еще не завершен, переходим к следующему этапу
    if (startNumberCount < finishNumberCount) {
      setState(() {
        startNumberCount++;
        testCompleted = false;
      });
      generateNumbers();
    } else {
      // Если тест завершен, показываем сообщение
      finishTestMessage();
    }
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
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );

      debugPrint('Подключение к бд из resultsToDB успешно');

      final userId = AuthManager.getUserId();

      final sendResults = await conn.execute(
        Sql.named('''
          SELECT cognitive."f\$test_results__write"(
          vp_user_id => @vp_user_id, 
          vp_test_id => @vp_test_id,
          vp_number_all_answers => @vp_number_all_answers,
          vp_number_correct_answers => @vp_number_correct_answers,
          vp_complete_time => @vp_complete_time
          )'''
        ),
        parameters: {
          'vp_user_id': userId,
          'vp_test_id': testId,
          'vp_number_all_answers': allAnswers,
          'vp_number_correct_answers': rightAnswers,
          'vp_complete_time': null,
        },
      );
      debugPrint('$sendResults');
      final result = sendResults.isEmpty == true;

      await conn.close();
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
        backgroundColor: const Color.fromARGB(255, 227, 49, 37),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void finishTestMessage() {
    resultsToDB();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Text("Количество правильных ответов: $rightAnswers"),
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[700],
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/testList', (route) => false);
            },
            child: const Text('Вернуться к тестам'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
          'Тест на запоминание чисел',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF373737),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showNumbers)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Text(
                    numbersToRemember.join(' '),
                    style: TextStyle(fontSize: screenWidth * 0.1, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (!showNumbers && !testCompleted)
              Column(
                children: [
                  SizedBox(height: 200),
                  Text('Введите числа в правильном порядке без запятой\n(увидели 1,2,3 - введите 123):', style: TextStyle(fontSize: screenWidth * 0.05)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      onChanged: (value) {
                        userSequence = value;
                      },
                      decoration: const InputDecoration(labelText: 'Числа'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: checkAnswer,
                    child: const Text('Проверить'),
                  ),
                ],
              ),
            if (testCompleted)
              Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 200),
                  Text(
                    'Результаты:',
                    style: TextStyle(fontSize: screenWidth * 0.06),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ваш ответ:',
                    style: TextStyle(fontSize: screenWidth * 0.06),
                    textAlign: TextAlign.center,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: screenWidth * 0.08, color: Colors.black),
                      children: _buildAnswerTextSpans(userSequence, numbersToRemember),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Правильный ответ:',
                    style: TextStyle(fontSize: screenWidth * 0.06),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    numbersToRemember.join(),
                    style: TextStyle(fontSize: screenWidth * 0.08),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userSequence.split('').map(int.parse).toList().toString() == numbersToRemember.toString()
                        ? 'Правильно!'
                        : 'Неправильно!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      color: userSequence.split('').map(int.parse).toList().toString() == numbersToRemember.toString()
                          ? Colors.green
                          : Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: goToNextTest,
                    child: Text(startNumberCount < finishNumberCount ? 'Следующий этап' : 'Вернуться к тестам', textAlign: TextAlign.center),
                  ),
                ],
              ),
              )
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildAnswerTextSpans(String userSequence, List<int> correctNumbers) {
    List<TextSpan> textSpans = [];
    List<int> userAnswer = userSequence.split('').map(int.parse).toList();

    for (int i = 0; i < userAnswer.length; i++) {
      if ((i < correctNumbers.length && userAnswer[i] != correctNumbers[i]) || (i >= correctNumbers.length)) {
        textSpans.add(
          TextSpan(
            text: userAnswer[i].toString(),
            style: const TextStyle(color: Colors.red),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: userAnswer[i].toString(),
            style: const TextStyle(color: Colors.black),
          ),
        );
      }
    }

    return textSpans;
  }
}