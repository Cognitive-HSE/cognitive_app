import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class MunstTestScreen extends StatefulWidget {
  const MunstTestScreen({super.key});

  @override
  State<MunstTestScreen> createState() => _MunstTestScreenState();
}

class _MunstTestScreenState extends State<MunstTestScreen> {
  // Символы и выделенные индексы
  final _formKey = GlobalKey<FormState>();
  List<String> characters = [];
  List<int> selectedIndexes = [];
  List<String> dictionary = [
    'ДОМ',
    'ГОРН',
    'ПОПКОРН',
    'КРАБ',
    'РАБ',
    'БАБУШКА',
    'ИНФУЗОРИЯ',
    'БАСНЯ',
    'БАЯН',
    'ВАХТА',
    'ГУСЬ',
    'ДЕНЬ',
    'ЗАКАТ',
    'ИНДЕЙКА',
    'ЛИЛИЯ',
    'САПЕР',
    'ОЗЕРО',
    'ЗИМА',
    'ПАДЕЖ',
    'ПОЛЕТ',
    'ПУЛЯ',
    'ПУТЬ',
    'РУЖЬЕ',
    'РЕМЕСЛО',
    'УЛИТКА',
    'ХЛЕБ',
    'ЦАРЬ',
    'ЦЕВЬЕ',
    'ХАМАМ',
    'ПЛАТЬЕ',
    'ПОЛОТЕНЦЕ',
    'СОЛНЦЕ',
    'ОДЕЯЛО',
    'ОБУВЬ',
    'ПОДОШВА',
    'ОДЕЖДА',
    'ЗАЯЦ',
    'СИРЕНЬ',
    'СТАНЦИЯ',
    'БЕГЛЕЦ',
    'АЗАРТ',
    'БОРОДА',
    'ЧУЧЕЛО',
    'БОГАТСТВО',
    'ОДЕКОЛОН',
    'БАЗАР',
    'РАССУДОК',
    'ГРЯЗЬ',
    'ОБЛАКО',
    'ЗАГАДКА',
    'ЗАДАЧА',
    'ЦЕЛЬ',
    'ПУТЬ',
    'СОЗВЕЗДИЕ',
    'ОБЛИК',
    'ЗНАК',
    'КОНФИГУРАЦИЯ',
    'ПУСТОТА',
    'ЗАМКНУТОСТЬ',
    'СИНГУЛЯРНОСТЬ',
    'ОБРЫВ',
    'ОГРАНИЧЕНИЕ',
    'УГРОЗА',
    'ОБЩЕСТВО',
    'РИНГ',
    'КЛУБ',
    'БОЕЦ',
    'КАРАТЭ',
    'ОБЕЗЬЯНА',
    'СОВЕСТЬ',
    'СЛОВО',
    'ЧЕСТЬ',
    'ВРЕМЯ',
    'СКОРОСТЬ',
    'МАНЕВР',
    'ОБГОН',
    'ПОВОРОТ',
    'ПРИБЫЛЬ',
    'УБЫТОК',
    'НЕДОСТАЧА',
    'УЧЕТ',
    'ЗАМЕТКА',
    'ПОЛОСТЬ',
    'ДЫРА',
    'БОБЕР',
    'СОВА'
  ]; // Список слов, которые нужно найти
  List<String> wordsToFind = [];
  int seconds = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _generateCharacters(200);
    seconds = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
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
    int foundWords = 0;
    for (int i = 0; i < characters.length; ++i) {
      if (selectedIndexes.contains(i)) {
        if (List.generate(wordsToFind.length, (int k) => wordsToFind[k][0])
            .contains(characters[i])) {
          for (int j = 0; j < wordsToFind.length; ++j) {
            if (characters.sublist(i, i + wordsToFind[j].length).join() ==
                wordsToFind[j]) {
              if (selectedIndexes.toSet().containsAll(
                  List.generate(wordsToFind[j].length, (int m) => i + m))) {
                if (!(selectedIndexes.contains(i + wordsToFind[j].length) ||
                    selectedIndexes.contains(i - 1))) {
                  foundWords++;
                  break;
                }
              }
            }
          }
        }
      }
    }
    timer.cancel(); // stop timer when results shown
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Text("Найдено слов: $foundWords\nВремя в секундах: $seconds"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/testList', (route) => false);
              },
              child: const Text('OK'))
        ],
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
          return wordsToFind[i++];
        }
      }
      return String.fromCharCode(1040 +
          randomCharacter.nextInt(32) % 32); // Псевдослучайные русские буквы
    }).expand((s) => s.split("")).toList();
    setState(() {});
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
        title: const Text('Тест Мюнстерберга'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
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
                        color: selectedIndexes.contains(index)
                            ? Colors.green
                            : Colors.white,
                        child: Text(characters[index],
                            style: const TextStyle(fontSize: 24)),
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
              onPressed: _checkWords,
              child: const Text('Результаты'),
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