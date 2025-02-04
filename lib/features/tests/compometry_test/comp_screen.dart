import 'package:flutter/material.dart';
import 'dart:math';

class CampimetryScreen extends StatefulWidget {
  @override
  _CampimetryScreenState createState() => _CampimetryScreenState();
}

class _CampimetryScreenState extends State<CampimetryScreen> with TickerProviderStateMixin {
  // Параметры для первого этапа
  int _tapCountStage1 = 0;
  Color _silhouetteColorStage1 = Colors.grey;
  Color _backgroundColor = Colors.grey;
  DateTime? _startTimeStage1;
  Duration? _durationStage1;
  bool _stage1Completed = false;
  String _selectedSilhouette = '';
  late AnimationController _timerControllerStage1;

  // Параметры для второго этапа
  int _correctTapCountStage2 = 0;
  int _tapCountStage2 = 0;
  Color _silhouetteColorStage2 = Colors.grey;
  DateTime? _startTimeStage2;
  Duration? _durationStage2;
  int _expectedTapsStage2 = 0;
  int _deviation = 0;
  late AnimationController _timerControllerStage2;

  // Общие параметры
  final double _silhouetteSize = 200.0;
  final List<String> _availableSilhouettes = ['cat', 'dog', 'bird'];
  final Map<String, String> _silhouetteNames = {
    'cat': 'кошка',
    'dog': 'собака',
    'bird': 'птица'
  };
  String _currentSilhouette = 'cat';
  final List<Color> _availableColors = [
     Color(0xFF8B0000), // Dark red
    Color(0xFF006400), // Dark green
    Color(0xFF00008B), // Dark blue
    Color(0xFF800080), // Purple
  ];
  bool _stage2Started = false;
  bool _colorsAreSame = false;


  @override
  void initState() {
    super.initState();
    _currentSilhouette = _availableSilhouettes[Random().nextInt(_availableSilhouettes.length)];
    _backgroundColor = _generateRandomColor();
    _silhouetteColorStage1 = _backgroundColor;

    _timerControllerStage1 = AnimationController(
      duration: Duration(hours: 1),
      vsync: this,
    );

    _timerControllerStage2 = AnimationController(
      duration: Duration(hours: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _timerControllerStage1.dispose();
    _timerControllerStage2.dispose();
    super.dispose();
  }

  // Метод для генерации случайного цвета
  Color _generateRandomColor() {
    final Random random = Random();
    return _availableColors[random.nextInt(_availableColors.length)];
  }


  // Метод для увеличения оттенка силуэта (первый этап)
  void _addShadeStage1() {
    setState(() {
      _tapCountStage1++;
      _silhouetteColorStage1 = Color.fromRGBO(        max(0, min(255, _silhouetteColorStage1.red + 2)),                max(0, min(255, _silhouetteColorStage1.green + 2)),
        max(0, min(255, _silhouetteColorStage1.blue + 2)),
        1.0,
      );
    });
  }


  // Метод для выбора силуэта (первый этап)
  void _selectSilhouette(String selected) {
    if (_startTimeStage1 != null) {
      setState(() {
        _stage1Completed = true;
        _selectedSilhouette = selected;
        _durationStage1 = DateTime.now().difference(_startTimeStage1!);
      });
      _timerControllerStage1.stop();
      _showStage1ResultDialog(selected); // Показываем диалог с результатом
    }
  }

  // Метод для отображения диалога с результатами первого этапа
    Future<void> _showStage1ResultDialog(String selected) async {
    bool isCorrect = selected == _currentSilhouette;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF373737), // Фон диалога
          title: Text(
            isCorrect ? 'Отлично!' : 'Увы!',
            style: const TextStyle(color: Colors.white), // Цвет текста заголовка
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  isCorrect ? 'Вы верно распознали животное.' : 'Ваш выбор неверный.',
                  style: const TextStyle(color: Colors.white), // Цвет текста контента
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Цвет текста кнопки
              ),
              child: const Text('Далее', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                _startStage2();
              },
            ),
          ],
        );
      },
    );
  }
  void _startStage2() {
    if (!_stage2Started) {
      setState(() {
        _stage2Started = true;
        _correctTapCountStage2 = _tapCountStage1 + Random().nextInt(5) + 3;
        _expectedTapsStage2 = _correctTapCountStage2; // Сохраняем правильный ответ
        _tapCountStage2 = 0;
        _startTimeStage2 = DateTime.now();
        _silhouetteColorStage2 = _calculateSilhouetteColorStage2();
        _deviation = 0;
           _colorsAreSame = false;
        _timerControllerStage2.reset();
        _timerControllerStage2.forward(); // Запускаем таймер второго этапа
      });
    }
  }


  // Метод для вычисления начального цвета силуэта на втором этапе
  Color _calculateSilhouetteColorStage2() {        return Color.fromRGBO(      max(0, min(255, _silhouetteColorStage1.red + (_correctTapCountStage2) * 2)),
      max(0, min(255, _silhouetteColorStage1.green + (_correctTapCountStage2) * 2)),
      max(0, min(255, _silhouetteColorStage1.blue + (_correctTapCountStage2) * 2)),
      1.0,
    );
  }


   // Метод для уменьшения оттенка силуэта (второй этап)
  void _subtractShadeStage2() {
      setState(() {
      if (!_colorsAreSame) {
        if (_silhouetteColorStage2.red > _backgroundColor.red ||
          _silhouetteColorStage2.green > _backgroundColor.green ||
          _silhouetteColorStage2.blue > _backgroundColor.blue)
          {
            _tapCountStage2++;
              _silhouetteColorStage2 = Color.fromRGBO(
              max(0, min(255, _silhouetteColorStage2.red - 2)),
              max(0, min(255, _silhouetteColorStage2.green - 2)),
              max(0, min(255, _silhouetteColorStage2.blue - 2)),
              1.0,
          );
          }
        } else {
           _tapCountStage2++; // Увеличиваем счетчик, если цвета уже одинаковые
        }
           _checkIfColorsAreSame();
    });

  }
  void _checkIfColorsAreSame() {
     if (_silhouetteColorStage2.red <= _backgroundColor.red &&
            _silhouetteColorStage2.green <= _backgroundColor.green &&
            _silhouetteColorStage2.blue <= _backgroundColor.blue)
            {
               _colorsAreSame = true;
            }
      else {_colorsAreSame = false;
      }
    }

  void _completeStage2() {
    if (_startTimeStage2 != null) {
      setState(() {
        _durationStage2 = DateTime.now().difference(_startTimeStage2!);
        _deviation = _tapCountStage2 - _correctTapCountStage2;
      });
      _timerControllerStage2.stop();
      _showResultsDialog(context);
    }
  }

  // Метод для отображения диалога с результатами
  Future<void> _showResultsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF373737), // Фон диалога
          title: const Text(
              'Результаты',
              style: TextStyle(color: Colors.white), // Цвет текста заголовка
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (_stage1Completed)
                   const Text('Этап 1:', style: TextStyle(color: Colors.white),),
                Text('Нажатий: $_tapCountStage1', style: const TextStyle(color: Colors.white)),
                Text('Время: ${_durationStage1?.inSeconds ?? 0} секунд', style: const TextStyle(color: Colors.white)),
                Text('Силуэт: ${_silhouetteNames[_selectedSilhouette] ?? _selectedSilhouette}', style: const TextStyle(color: Colors.white)),

                if (_stage2Started)
                   const Text('\nЭтап 2:', style: TextStyle(color: Colors.white)),
                Text('Время: ${_durationStage2?.inSeconds ?? 0} секунд', style: const TextStyle(color: Colors.white)),
                Text('Нажатий: $_tapCountStage2', style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
               style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Цвет текста кнопки
              ),
              child: const Text('Вернуться к тестам', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                _goToTestList();
              },
            ),
          ],
        );
      },
    );
  }

  void _restartTest() {
    setState(() {
      _tapCountStage1 = 0;
      _silhouetteColorStage1 = _backgroundColor;
      _backgroundColor = _generateRandomColor();
      _startTimeStage1 = null;
      _durationStage1 = null;
      _stage1Completed = false;
      _selectedSilhouette = '';
      _correctTapCountStage2 = 0;
      _tapCountStage2 = 0;
      _expectedTapsStage2 = 0;
      _silhouetteColorStage2 = Colors.grey;
      _startTimeStage2 = null;
      _durationStage2 = null;
      _deviation = 0;
      _stage2Started = false;
      _currentSilhouette = _availableSilhouettes[Random().nextInt(_availableSilhouettes.length)];
          _colorsAreSame = false;
    });
    _timerControllerStage1.reset();
    _timerControllerStage2.reset();
  }

  void _goToTestList() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text(
          'Тест "Кампиметрия"',
          style: TextStyle(color: Colors.white), // Белый цвет текста
        ),
        backgroundColor: Color(0xFF373737),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: _backgroundColor,
         child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Container(
                width: _silhouetteSize,
                height: _silhouetteSize,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/CompTest/$_currentSilhouette.png'),
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(_stage2Started ? _silhouetteColorStage2 : _silhouetteColorStage1, BlendMode.srcIn)
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Выводим время, если таймер запущен
              if (_timerControllerStage1.isAnimating) Text('Время: ${_timerControllerStage1.value > 0 ? _timerControllerStage1.lastElapsedDuration?.inSeconds : 0} секунд', style: const TextStyle(color: Colors.white),),
              if (_timerControllerStage2.isAnimating)
                Text('Время: ${_timerControllerStage2.value > 0 ? _timerControllerStage2.lastElapsedDuration?.inSeconds : 0} секунд', style: const TextStyle(color: Colors.white)),

              // Кнопки и текст в зависимости от этапа
              if (!_stage1Completed)
                Column(
                  children: [
                     Text('Нажатий:$_tapCountStage1', style: const TextStyle(color: Colors.white)),

                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700], // Цвет кнопки
                          foregroundColor: Colors.white, // Цвет текста кнопки
                          minimumSize: const Size(200, 50), // Размер кнопки
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Скругленные углы
                          ),
                        ),
                      onPressed: () {
                        if (_startTimeStage1 == null) {
                          _startTimeStage1 = DateTime.now();
                          _timerControllerStage1.forward(); // Запускаем таймер первого этапа
                        }
                        _addShadeStage1();
                      },
                      child: const Text('Добавить оттенок'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Выберите силуэт:', style: TextStyle(color: Colors.white),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _availableSilhouettes.map((silhouette) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700], // Цвет кнопки
                                foregroundColor: Colors.white, // Цвет текста кнопки
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Скругленные углы
                                ),
                                ),
                              onPressed: () => _selectSilhouette(silhouette),
                              child: Text(_silhouetteNames[silhouette]!) // Используем _silhouetteNames для отображения русских названий на кнопках
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              if (_stage2Started)
                Column(
                  children: [
                      Text('Нажатий: $_tapCountStage2',  style: const TextStyle(color: Colors.white),),

                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700], // Цвет кнопки
                          foregroundColor: Colors.white, // Цвет текста кнопки
                          minimumSize: const Size(200, 50), // Размер кнопки
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Скругленные углы
                          ),
                        ),
                      onPressed: _subtractShadeStage2,
                      child: const Text('Убавить оттенок'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                         style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700], // Цвет кнопки
                           foregroundColor: Colors.white, // Цвет текста кнопки
                           minimumSize: const Size(200, 50), // Размер кнопки
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10), // Скругленные углы
                           ),
                         ),
                        onPressed: (){
                           setState(() {
                             if (_colorsAreSame) {
                               _tapCountStage2++;
                             }
                           });
                              _completeStage2(); // Завершаем этап в любом случае
                          },
                      child: const Text('Не вижу'),
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
