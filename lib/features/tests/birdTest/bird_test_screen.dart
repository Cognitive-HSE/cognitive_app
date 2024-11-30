import 'dart:async';
import 'dart:math';

import 'package:cognitive/router/router.dart';
import 'package:flutter/material.dart';

class BirdtestScreen extends StatefulWidget {
  const BirdtestScreen({super.key});

  @override
  State<BirdtestScreen> createState() => _BirdtestScreenState();
}

class _BirdtestScreenState extends State<BirdtestScreen> {
  Map birdDirections = {0: 'Up', 1: 'Right', 2: 'Down', 3: 'Left'}; //up, right, down, left
  Map birdColors = {0: 'blue', 1: 'red'}; //blue, red
  Map birdLabels = {'blue': 'Куда летит ласточка?', 'red': 'Откуда летит ласточка?'};
  var birdColor = Random().nextInt(2);
  var birdDirection = Random().nextInt(4);
  String birdImage = '';
  String birdLabel = '';
  String birdDirectionStr = '';
  var rightAnswers = 0;

  int timerSeconds = 60;
  late Timer timer;
  


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

  void checkRightAnswer(int arrowIndex) {
    if (birdColor == 0 && birdDirection == arrowIndex) {
      rightAnswers += 1;
    } else if (birdColor == 1 && birdDirection == (arrowIndex+2) % 4) {
        rightAnswers += 1;
      }
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

  void handleTimeout() {

  }

  String getBirdStrColor() {
    return birdColors[birdColor];
  }

  String getBirdStrDirection() {
    return birdDirections[birdDirection];
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
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (timerSeconds == 1) {
        timer.cancel();
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text("Тест завершен!\nВаш результат: $rightAnswers"),
            actions: [
              TextButton(
                  onPressed: () {
                     Navigator.pushNamedAndRemoveUntil(
                      context,
                       '/successReg/testList',
                        (route) => false
                      );
                     },
                  child: const Text('Вернуться к тестам'),
              ),
            ],
          ),
        );
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
                      ...List.generate(3, (index) {
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
                        'Счет: $rightAnswers',
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
            bottom: 20, // Отступ от нижнего края
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    var arrowIndex = 0;
                    checkRightAnswer(arrowIndex);                
                    continueTest();
                  },
                  child: Image.asset(
                    'assets/birdTest/testUpArrow.png',
                    width: arrowSize,
                    height: arrowSize,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        var arrowIndex = 3;
                        checkRightAnswer(arrowIndex);                
                        continueTest();
                      },
                      child: Image.asset(
                        'assets/birdTest/testLeftArrow.png',
                        width: arrowSize,
                        height: arrowSize,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        var arrowIndex = 2;
                        checkRightAnswer(arrowIndex);                
                        continueTest();
                      },
                      child: Image.asset(
                        'assets/birdTest/testDownArrow.png',
                        width: arrowSize,
                        height: arrowSize,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        var arrowIndex = 1;
                        checkRightAnswer(arrowIndex);                
                        continueTest();
                      },
                      child: Image.asset(
                        'assets/birdTest/testRightArrow.png',
                        width: arrowSize,
                        height: arrowSize,
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
