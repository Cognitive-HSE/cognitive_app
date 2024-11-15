import 'package:flutter/material.dart';
import 'dart:math';

class OneTestScreen extends StatefulWidget {
  const OneTestScreen({super.key});

  @override
  State<OneTestScreen> createState() => _OneTestScreenState();
}

class _OneTestScreenState extends State<OneTestScreen> {
  // Символы и выделенные индексы
  List<String> characters = [];
  List<int> selectedIndexes = [];
  List<String> wordsToFind = [
    'КОТ',
    'СЛОН'
  ]; // Список слов, которые нужно найти
  @override
  void initState() {
    super.initState();
    _generateCharacters(200);
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

    for (int j = 0; j < wordsToFind.length; j++) {
      var word = wordsToFind[j];
      bool isWordFound = false;

      for (int i = 0; i < characters.length - word.length + 1; i++) {
        if (characters.sublist(i, i + word.length).join() == word) {
          if (selectedIndexes
              .toSet()
              .containsAll(List.generate(word.length, (k) => i + k))) {
            isWordFound = true;
            break;
          }
        }
      }
      if (isWordFound) {
        foundWords++;
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text("Words found: $foundWords"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

//генерация случайного ряда русских букв
  void _generateCharacters(int numberOfChar) {
    int i = 0;
    var randomCharacter = Random();
    var indices = List.generate(wordsToFind.length,
        (int k) => randomCharacter.nextInt(199 - wordsToFind[i].length));
    characters = List.generate(numberOfChar, (index) {
      // Генерируем случайные буквы, вставляя слова
      if (i < wordsToFind.length) {
        if (index == indices[i]) {
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
    super.dispose();
  }

  void _finish() {
    debugPrint("User wants to finish test");
    Navigator.of(context).pushNamed('/successReg/testList');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тест Мюнстерберга'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Выделите слова'),
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
