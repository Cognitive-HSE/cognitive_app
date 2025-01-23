import 'dart:async';
import 'dart:math';

import 'package:cognitive/cognitive_app.dart';
import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class BirdtestScreen extends StatefulWidget {
  const BirdtestScreen({super.key});

  @override
  State<BirdtestScreen> createState() => _BirdtestScreenState();
}

class _BirdtestScreenState extends State<BirdtestScreen> {

  int testId = 2;

  Map birdDirections = {0: 'Up', 1: 'Right', 2: 'Down', 3: 'Left'};
  Map birdColors = {0: 'blue', 1: 'red'};
  Map birdLabels = {'blue': 'Куда летит ласточка?', 'red': 'Откуда летит ласточка?'};
  var birdColor = Random().nextInt(2);
  var birdDirection = Random().nextInt(4);
  String birdImage = '';
  String birdLabel = '';
  String birdDirectionStr = '';
  var allAnswers = 0;
  var rightAnswers = 0;
  var heartsCount = 3;

  int testDuration = 60; //test duration
  int timerSeconds = 60; // seconds for remaining
  late Timer timer;

  Map<int, bool> buttonPressed = {0: false, 1: false, 2: false, 3: false};
  


  void changeBirdImage(String newImage) {
    setState(() {
      birdImage = newImage;
    });
  }

  void changeBirdLabel() {
    setState(() {
      birdLabel = birdLabels[getBirdStrColor()];
    });
  }

  void generateNewBirdColor() {
    birdColor = Random().nextInt(2);
  }

  void generateNewDirection() {
    birdDirection = Random().nextInt(4);
  }

  void showNewBirdImage() {
    var color = getBirdStrColor();
    var direction = getBirdStrDirection();
    var image = 'assets/birdTest/$color''Bird$direction.png';
    setState(() {
      birdImage = image;
    });
  }

  void continueTest() {
    generateNewBirdColor();
    generateNewDirection();
    showNewBirdImage();
    changeBirdLabel();
  }

  void takeLife() {
    setState(() {
      heartsCount--;
    });
    if (heartsCount <= 0) {
      timer.cancel();
      showGameOverScreen();
    }
  }

  void showGameOverScreen() {
    var accuracy = 0;
    if (allAnswers != 0) {
    accuracy = (rightAnswers/allAnswers * 100).round();
    } 

    //результат в бд
    resultsToDB();

    showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            content: Text(
              "Тест завершен!\nПравильно: $rightAnswers из $allAnswers\nТочность: $accuracy%"
              ),
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
                      context,
                       '/testList',
                        (route) => false
                      );
                     },
                  child: const Text('Вернуться к тестам'),
              ),
            ],
          ),
        );
  }

    void onButtonPressed(int index) {
    setState(() {
      buttonPressed[index] = true;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        buttonPressed[index] = false;
      });
    });

    var boolAnswer = checkRightAnswer(index);
    allAnswers++;
    if (!boolAnswer) {
      takeLife();
    }
    continueTest();
  }

  bool checkRightAnswer(int arrowIndex) {
    if (birdColor == 0 && birdDirection == arrowIndex) {
      rightAnswers += 1;
      return true;
    } else if (birdColor == 1 && birdDirection == (arrowIndex+2) % 4) {
        rightAnswers += 1;
        return true;
      }
    return false;
  }

  String getBirdStrColor() {
    return birdColors[birdColor];
  }

  String getBirdStrDirection() {
    return birdDirections[birdDirection];
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

    final secodsInterval = formatToInterval(testDuration - timerSeconds);
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
    )'''
    ),
    parameters: {
      'vp_user_id': userId, 
      'vp_test_id': testId,
      'vp_number_all_answers': allAnswers,
      'vp_number_correct_answers': rightAnswers,
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

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

//set start bird and label
  @override
  void initState() {
    super.initState();
    //set start bird color + start bird direction
    final startBirdColor = getBirdStrColor();
    final startBirdDirection = getBirdStrDirection();
    birdImage = 'assets/birdTest/$startBirdColor''Bird$startBirdDirection.png';
    //set start label
    final startBirdLabel = getBirdStrColor(); //label key = color value 
    birdLabel = birdLabels[startBirdLabel];
    //setup timer
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timerSeconds == 1) {
        timer.cancel();
        showGameOverScreen();
      }
      setState(() {
        timerSeconds--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final birdWidth = 0.5 * (screenSize.width * 0.45 + screenSize.height * 0.45);
    final arrowSize = birdWidth * 0.23;
    final iconSize = 0.5 * (screenSize.width * 0.05 + screenSize.height * 0.05);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Задний фон с картинкой
          Positioned.fill(
            child: Image.asset(
              'assets/birdTest/skyBackground.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Основная вертикальная колонка
          SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: 
                  Row(
                    children: [
                      Image.asset(
                        "assets/birdTest/clockIcon.png",
                        width: iconSize,
                        height: iconSize,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$timerSeconds',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: 
                  Row(
                    children: [
                      const Text(
                        'Жизней:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                      const SizedBox(width: 5),
                      if (heartsCount > 0)
                        ...List.generate(heartsCount, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Image.asset(
                              "assets/birdTest/heartIcon.png",
                              width: iconSize,
                              height: iconSize,
                            ),
                          );
                        }),
                    ],
                  ),
                  ),

                  //птиц отгадано
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: 
                  Row(
                    children: [
                      Text(
                        'Правильно: $rightAnswers',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                  ),
                  
              
                  SizedBox(height: screenSize.height * 0.05),
                  FittedBox(
                    child: Text(
                      birdLabel,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.05),

                  Image.asset(
                    birdImage,
                    width: birdWidth,
                    height: birdWidth,
                    key: ValueKey(birdImage), // force to show image
                  ),
                ],
              ),
            
            
          ),

          // Кнопки-стрелки фиксируются в нижней части экрана
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => onButtonPressed(0),
                  child: AnimatedScale(
                    scale: buttonPressed[0]! ? 0.9 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Image.asset(
                      'assets/birdTest/testUpArrow.png',
                      width: arrowSize,
                      height: arrowSize,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => onButtonPressed(3),
                      child: AnimatedScale(
                        scale: buttonPressed[3]! ? 0.9 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        child: Image.asset(
                          'assets/birdTest/testLeftArrow.png',
                          width: arrowSize,
                          height: arrowSize,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => onButtonPressed(2),
                      child: AnimatedScale(
                        scale: buttonPressed[2]! ? 0.9 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        child: Image.asset(
                          'assets/birdTest/testDownArrow.png',
                          width: arrowSize,
                          height: arrowSize,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => onButtonPressed(1),
                      child: AnimatedScale(
                        scale: buttonPressed[1]! ? 0.9 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        child: Image.asset(
                          'assets/birdTest/testRightArrow.png',
                          width: arrowSize,
                          height: arrowSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
