import 'dart:async';
import 'package:cognitive/cognitive_app.dart';
import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class TagTestScreen extends StatefulWidget {
  const TagTestScreen({super.key});

  @override
  State<TagTestScreen> createState() => _TagTestScreenState();
}

class _TagTestScreenState extends State<TagTestScreen> {
  final testId = 4;
  List<String> _tiles = [];
  int _moves = 0;
  int _timeElapsed = 0;
  Timer? _timer;
  bool _gameStarted = false;
  bool _gameEnded = false;
  String _endMessage = '';
  int isSolved = 0;
  Color _endMessageColor = Colors.green.shade100; // Добавляем цвет фона сообщения

  String get formattedTime {
    final minutes = (_timeElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timeElapsed % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get motivationalMessage {
    if (_moves <= 50) return 'Продолжайте тренироваться, чтобы улучшить свой результат!';
    if (_moves <= 150) return 'Отличная работа! Вы проявили аналитическое мышление.';
    if (_moves <= 300) return 'Хорошо! Немного практики, и результат улучшится.';
    return 'Вы сделали это! Продолжайте тренироваться для улучшения навыков.';
  }

  @override
  void initState() {
    super.initState();
    _initializeTiles();
  }

  void _initializeTiles() {
    _tiles = List.generate(15, (index) => (index + 1).toString())..add('');
    _shuffleTiles();
  }

  void _shuffleTiles() {
    _tiles.shuffle();
  }

  bool _isSolved() {
    return _tiles.join('') == '123456789101112131415';
  }

  void _moveTile(int index) {
    if (!_gameStarted || _gameEnded) return;

    final emptyIndex = _tiles.indexOf('');
    final validMoves = [emptyIndex - 1, emptyIndex + 1, emptyIndex - 4, emptyIndex + 4];

    if (validMoves.contains(index)) {
      setState(() {
        final temp = _tiles[emptyIndex];
        _tiles[emptyIndex] = _tiles[index];
        _tiles[index] = temp;
        _moves++;
      });
      if (_isSolved()) _endGame(true);
    }
  }

  void _startGame() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    setState(() {
      _timeElapsed = 0;
      _moves = 0;
      _gameStarted = true;
      _gameEnded = false;
      _initializeTiles();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _timeElapsed++;
        });
      }
    });
  }

  void _endGame(bool success) {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    setState(() {
      _gameEnded = true;
            _endMessage = success
          ? 'Поздравляем! Вы успешно собрали головоломку!'
          : 'Игра завершена.';
      _endMessageColor = success ? Colors.green.shade100 : Colors.red.shade100; // Устанавливаем цвет
    });
  }

  void _testVictory() {
    resultsToDB();
    setState(() {
      if (!_gameStarted) {
        _moves = 0;
        _timeElapsed = 0;
      }
    });

    if (_isSolved()) {
      _endGame(true);
    } else {
        if (_timer != null) {  // Остановка таймера
          _timer!.cancel();
          _timer = null;
        }
      setState(() {
        _gameEnded = true;
        _endMessage = 'Не вышло, попробуйте ещё раз!';
        _endMessageColor = Colors.red.shade100;
      });
    }
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

    final secodsInterval = formatToInterval(_timeElapsed);
    final userId = AuthManager.getUserId();

    if (_isSolved()) {
      isSolved = 1;
    }

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
      'vp_number_all_answers': 1,
      'vp_number_correct_answers': isSolved,
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
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Тест Пятнашки',
          style: TextStyle(color: Colors.white), // Белый цвет текста
        ),
        backgroundColor: Color(0xFF373737), 
        centerTitle: true,
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: _tiles.length,
              itemBuilder: (context, index) {
                final tile = _tiles[index];
                return InkWell(
                  onTap: () => _moveTile(index),
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: tile == '' ? Colors.grey[300] : Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        tile,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ходы: $_moves'),
                  const SizedBox(width: 20.0),
                  Text('Время: $formattedTime'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _startGame(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
                    ),
                    child: Text(
                        _gameStarted ? 'Перезапуск' : 'Начать игру'),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () => _testVictory(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    ),
                    child: const Text('Проверить победу'),
                  ),
                ],
              ),
            ),
            if (_gameEnded)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: _endMessageColor, // Используем переменную для цвета
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    Text(
                      _endMessage,
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text('Количество ходов: $_moves'),
                    Text('Время на решение: $formattedTime'),
                    Text(motivationalMessage),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/testList', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 208, 71, 61),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      ),
                      child: const Text('Назад к тестам'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}



