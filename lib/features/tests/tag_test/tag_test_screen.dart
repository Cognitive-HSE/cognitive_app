import 'dart:async';
import 'package:flutter/material.dart';

class TagTestScreen extends StatefulWidget {
  const TagTestScreen({super.key});

  @override
  State<TagTestScreen> createState() => _TagTestScreenState();
}

class _TagTestScreenState extends State<TagTestScreen> {
  List<String> _tiles = [];
  int _moves = 0;
  int _timeElapsed = 0;
  Timer? _timer;
  bool _gameStarted = false;
  bool _gameEnded = false;
  String _endMessage = '';
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



