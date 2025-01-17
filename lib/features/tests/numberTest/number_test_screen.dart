import 'dart:async';
import 'dart:math';
import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class NumberTestScreen extends StatefulWidget {
  const NumberTestScreen({super.key});

  @override
  State<NumberTestScreen> createState() => _NumberTestScreenState();
}

class _NumberTestScreenState extends State<NumberTestScreen> {
  int testId = 3;
  int startNumberCount = 4;
  int finishNumberCount = 7;
  int rightAnswers = 0;
  List<int> numbersToRemember = [];
  List<int> userInput = [];
  bool showNumbers = false;
  bool testCompleted = false;

  @override
  void initState() {
    super.initState();
    generateNumbers();
  }

  void generateNumbers() {
    numbersToRemember = List.generate(startNumberCount, (index) => Random().nextInt(10));
    userInput = List.filled(startNumberCount, 0);
    setState(() {
      showNumbers = true;
      testCompleted = false;
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        showNumbers = false;
      });
    });
  }

  void checkAnswer() {
    setState(() {
      testCompleted = true;
    });
  }

  void goToNextTest() {
    setState(() {
      if (startNumberCount < finishNumberCount) {
        startNumberCount++;
      }

      if (userInput.toString() == numbersToRemember.toString()) {
        rightAnswers++;
      }
      testCompleted = false;
    });
    generateNumbers();
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

    final userName = AuthManager.getUsername();

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
      'vp_user_name': '$userName', 
      'vp_test_id': testId,
      'vp_number_all_answers': finishNumberCount - startNumberCount + 1,
      'vp_number_correct_answers': rightAnswers,
      'vp_complete_time': null
      
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

  void finishTestMessage(foundWords, ) {
      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Text("Количество правильных ответов: $rightAnswers"),
        actions: [
          TextButton(
              onPressed: () {
                resultsToDB();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/testList', (route) => false);
              },
              child: const Text('Вернуться к тестам'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Тест на запоминание чисел')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Центрирование чисел
              if (showNumbers)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7, // Центрируем по высоте
                  child: Center(
                    child: Text(
                      numbersToRemember.join(', '),
                      style: TextStyle(fontSize: screenWidth * 0.1, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (!showNumbers && !testCompleted)
                Column(
                  children: [
                    Text('Введите числа в правильном порядке:', style: TextStyle(fontSize: screenWidth * 0.05)),
                    SizedBox(height: 10),
                    Column(
                      children: List.generate(startNumberCount, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                userInput[index] = int.parse(value);
                              }
                            },
                            decoration: InputDecoration(labelText: 'Число ${index + 1}'),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: checkAnswer,
                      child: Text('Проверить'),
                    ),
                  ],
                ),
              if (testCompleted)
                Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Text(
      'Результаты:',
      style: TextStyle(fontSize: screenWidth * 0.06),
      textAlign: TextAlign.center,
    ),
    SizedBox(height: 20),
    Text(
      'Ваш ответ:',
      style: TextStyle(fontSize: screenWidth * 0.06),
      textAlign: TextAlign.center,
    ),
    Text(
      userInput.toString(),
      style: TextStyle(fontSize: screenWidth * 0.08),
      textAlign: TextAlign.center,
    ),
    SizedBox(height: 10),
    Text(
      'Правильный ответ:',
      style: TextStyle(fontSize: screenWidth * 0.06),
      textAlign: TextAlign.center,
    ),
    Text(
      numbersToRemember.toString(),
      style: TextStyle(fontSize: screenWidth * 0.08),
      textAlign: TextAlign.center,
    ),
    SizedBox(height: 20),
    Text(
      userInput.toString() == numbersToRemember.toString()
          ? 'Правильно!'
          : 'Неправильно!',
      style: TextStyle(
        fontSize: screenWidth * 0.06,
        color: userInput.toString() == numbersToRemember.toString()
            ? Colors.green
            : Colors.red,
      ),
      textAlign: TextAlign.center,
    ),
    SizedBox(height: 30),
    if (startNumberCount < finishNumberCount)
      Center(
        child: ElevatedButton(
          onPressed: goToNextTest,
          child: Text('Следующий этап', textAlign: TextAlign.center),
        ),
      ),
    SizedBox(height: 10),
    if (startNumberCount == finishNumberCount)
    
      Center(
        child: ElevatedButton(
          onPressed: () {
            
            finishTestMessage(rightAnswers);
          
          },
          child: Text('Вернуться к тестам', textAlign: TextAlign.center),
        ),
      ),
  ],
),

            ],
          ),
        ),
      ),
    );
  }
}
