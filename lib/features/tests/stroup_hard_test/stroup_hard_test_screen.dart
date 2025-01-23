import 'package:flutter/material.dart';
import 'dart:math';

class AnimalImage extends StatelessWidget {
  final Color color;
  final double opacity;

  const AnimalImage({super.key, required this.color, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Image.asset('assets/StroupHardTest/animal_image.png', 
          color: color,
          colorBlendMode: BlendMode.srcATop,
          width: 100,
          height: 100),
    );
  }
}

class ColorGenerator {
    static Color generateRandomColor() {
        Random random = Random();
        return Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1.0,
        );
    }

    static Color generateSimilarColor(Color baseColor) {
        Random random = Random();
        int red = baseColor.red + random.nextInt(60) - 30;
        int green = baseColor.green + random.nextInt(60) - 30;
        int blue = baseColor.blue + random.nextInt(60) - 30;

        red = red.clamp(0, 255);
        green = green.clamp(0, 255);
        blue = blue.clamp(0, 255);

        return Color.fromRGBO(red, green, blue, 1.0);
    }
}

class ColorBlindTestScreen extends StatefulWidget {
  const ColorBlindTestScreen({super.key});

  @override
  _ColorBlindTestScreenState createState() => _ColorBlindTestScreenState();
}

class _ColorBlindTestScreenState extends State<ColorBlindTestScreen> {
  final testId = 6;
  late Color _backgroundColor;
  late Color _animalColor;
  int _clickCount = 0;
  double _opacity = 1.0;
  DateTime _startTime = DateTime.now();
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _generateColors();
  }

  void _generateColors() {
    _backgroundColor = ColorGenerator.generateRandomColor();
    _animalColor = ColorGenerator.generateSimilarColor(_backgroundColor);
  }

  void _onTryAgainPressed() {
    setState(() {
      _generateColors();
      _clickCount = 0;
      _opacity = 1.0;
      _startTime = DateTime.now();
      _isFinished = false;
    });
  }

  void _onTryClick() {
    setState(() {
      _clickCount++;
      _opacity -= 0.1;
      if (_opacity < 0.1) _opacity = 0.1;
    });
  }

  void _onFinished(){
    setState(() {
        _isFinished = true;
    });
  }

  String _formatDuration(Duration duration) {
      int seconds = duration.inSeconds % 60;
      int minutes = duration.inMinutes;
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

   void _goToTestList() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/testList',
      (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(
        child: _isFinished
            ? _buildResults()
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimalImage(
                  color: _animalColor,
                  opacity: _opacity,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _onTryClick,
                      child: const Text('Ещё раз'),
                    ),
                    const SizedBox(width: 20,),
                    ElevatedButton(
                      onPressed: _onFinished,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Не вижу', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                )
              ],
            ),
      ),
    );
  }
  Widget _buildResults(){
    Duration duration = DateTime.now().difference(_startTime);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Text('Вы продержались: ${_formatDuration(duration)}', style: const TextStyle(fontSize: 20, color: Colors.white),),
          const SizedBox(height: 20,),
          Text('Количество кликов: $_clickCount', style: const TextStyle(fontSize: 20, color: Colors.white)),
          const SizedBox(height: 20,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700], // Цвет кнопки
                  foregroundColor: Colors.white, // Цвет текста кнопки
                  minimumSize: const Size(200, 50), // Размер кнопки
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Скругленные углы
                  ),
                ),
            onPressed: _onTryAgainPressed, 
            child: const Text('Попробовать снова')),
          const SizedBox(height: 20,),
           ElevatedButton(
            style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700], // Цвет кнопки
                  foregroundColor: Colors.white, // Цвет текста кнопки
                  minimumSize: const Size(200, 50), // Размер кнопки
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Скругленные углы
                  ),
                ),
            onPressed: _goToTestList, // Добавлена кнопка возврата к списку тестов
             child: const Text('Вернуться к списку тестов'),
          ),
      ],
    );
  }
}
