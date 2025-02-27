import 'package:cognitive/cognitive_app.dart';
import 'package:cognitive/features/database_config.dart';
import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:postgres/postgres.dart';

class StrupTestScreen extends StatefulWidget {
  const StrupTestScreen({super.key});

  @override
  _StrupTestScreenState createState() => _StrupTestScreenState();
}

class _StrupTestScreenState extends State<StrupTestScreen> {
  final testId = 5;
  int currentStage = 1;
  int currentQuestion = 0;
  int correctAnswers = 0;
  int timerSeconds = 3;
  Timer? _timer;
  List<Color> shuffledOptions = [];
  bool isButtonDisabled = false;

  final List<Color> allColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple
  ];

  List<Map<String, dynamic>> stage1Questions = [];
  List<Map<String, dynamic>> stage2Questions = [];
  List<Map<String, dynamic>> stage3Questions = [];

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
    _resetStage();
  }

  void _initializeQuestions() {
    // Этап 1: Цвет текста совпадает с названием
    stage1Questions = allColors.map((color) => _createQuestion(
      _colorName(color),
      color,
      correctColor: color,
    )).toList();

    // Этап 2: Цвет текста НЕ совпадает с названием
    stage2Questions = allColors.map((color) {
      final textColor = _getDifferentColor(color);
      return _createQuestion(
        _colorName(color),
        textColor,
        correctColor: textColor,
      );
    }).toList();

    // Этап 3: Название цвета не совпадает с цветом текста
    stage3Questions = allColors.map((color) {
      final colorName = _getDifferentColorName(color);
      return _createQuestion(
        colorName,
        color,
        correctColor: _colorFromName(colorName),
      );
    }).toList();
  }

  Map<String, dynamic> _createQuestion(String word, Color color, {required Color correctColor}) {
    return {
      'word': word,
      'color': color,
      'correctColor': correctColor,
    };
  }

  Color _getDifferentColor(Color original) {
    final available = List<Color>.from(allColors)..remove(original);
    return available[Random().nextInt(available.length)];
  }

  String _getDifferentColorName(Color original) {
    final available = allColors
        .map((c) => _colorName(c))
        .where((n) => n != _colorName(original))
        .toList();
    return available[Random().nextInt(available.length)];
  }

  String _colorName(Color color) {
    return {
      Colors.red: 'Красный',
      Colors.green: 'Зеленый',
      Colors.blue: 'Синий',
      Colors.yellow: 'Желтый',
      Colors.orange: 'Оранжевый',
      Colors.purple: 'Фиолетовый',
    }[color]!;
  }

  Color _colorFromName(String name) {
    return {
      'Красный': Colors.red,
      'Зеленый': Colors.green,
      'Синий': Colors.blue,
      'Желтый': Colors.yellow,
      'Оранжевый': Colors.orange,
      'Фиолетовый': Colors.purple,
    }[name]!;
  }

  List<Map<String, dynamic>> get _currentQuestions {
    switch (currentStage) {
      case 1: return stage1Questions;
      case 2: return stage2Questions;
      case 3: return stage3Questions;
      default: return stage1Questions;
    }
  }

  void _resetStage() {
    if (!mounted) return;
    _timer?.cancel();
    setState(() {
      currentQuestion = 0;
      isButtonDisabled = false;
      timerSeconds = 3;
      shuffledOptions = List.from(allColors)..shuffle(Random());
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          _nextQuestion();
        }
      });
    });
  }

  void _nextQuestion() {
    if (!mounted) return;
    _timer?.cancel();
    
    if (currentQuestion < _currentQuestions.length - 1) {
      setState(() {
        currentQuestion++;
        timerSeconds = 3;
        isButtonDisabled = false;
        shuffledOptions.shuffle(Random());
      });
      _startTimer();
    } else {
      _handleStageCompletion();
    }
  }

  void _handleStageCompletion() {
    if (currentStage < 3) {
      _showNextStageDialog();
    } else {
      _showResult();
    }
  }

  String _getResultComment(int correctAnswers) {
    if (correctAnswers <= 6) {
      return "Не расстраивайтесь! Немного практики, и все получится!";
    } else if (correctAnswers <= 12) {
      return "Неплохо! Попробуйте ещё раз, чтобы достичь лучшего результата!";
    } else if (correctAnswers <= 16) {
      return "Отличный результат! Вы показываете хорошие способности!";
    } else {
      return "Превосходно! Вы мастер теста Струпа!";
    }
  }

  void _showResult() {
    resultsToDB();
    String resultComment = _getResultComment(correctAnswers);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text("Тест завершен!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Правильных ответов: $correctAnswers из 18", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text(
                resultComment,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
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
                  (route) => false,
                );
              },
              child: const Text("Вернуться к тестам"),
            ),
          ],
        ),
      ),
    );
  }

  void _showNextStageDialog() {
    String instruction;
    switch (currentStage) {
      case 1:
        instruction = 'Этап 2: Цвет слова НЕ совпадает с его значением\n\n'
            'Выбирайте ответ по ЦВЕТУ ТЕКСТА, игнорируя значение слова';
        break;
      case 2:
        instruction = 'Этап 3: Цвет слова НЕ совпадает с его значением\n\n'
            'Выбирайте ответ по ЗНАЧЕНИЮ ТЕКСТА, игнорируя цвет слова';
        break;
      default:
        instruction = '';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Этап $currentStage завершен!"),
          
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Перейдите к следующему этапу:"),
              const SizedBox(height: 20),
              Text(
                instruction,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey,
                ),
              ),
            ],
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
              onPressed: () => _proceedToNextStage(),
              child: const Text("Продолжить"),
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToNextStage() {
    Navigator.pop(context);
    setState(() {
      currentStage++;
      _resetStage();
    });
  }

  void _checkAnswer(Color selectedColor) {
    if (isButtonDisabled) return;
    
    setState(() {
      isButtonDisabled = true;
      final correctColor = _currentQuestions[currentQuestion]['correctColor'];
      if (selectedColor == correctColor) {
        correctAnswers++;
      }
    });
    _nextQuestion();
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
      'vp_number_all_answers': 18,
      'vp_number_correct_answers': correctAnswers,
      'vp_complete_time': null,
      
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

  Widget _buildAnswerButton(Color color) {
    return ElevatedButton(
      onPressed: isButtonDisabled ? null : () => _checkAnswer(color),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(120, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const SizedBox.shrink(),
    );
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
          'Тест Струпа',
          style: TextStyle(color: Colors.white), // Белый цвет текста
        ),
        backgroundColor: Color(0xFF373737), 
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentQuestions[currentQuestion]['word'],
              style: TextStyle(
                fontSize: 40,
                color: _currentQuestions[currentQuestion]['color'],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2,
              ),
              itemCount: shuffledOptions.length,
              itemBuilder: (context, index) => _buildAnswerButton(shuffledOptions[index]),
            ),
            const SizedBox(height: 30),
            Text(
              'Оставшееся время: $timerSeconds',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Этап: $currentStage',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}