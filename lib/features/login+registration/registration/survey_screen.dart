import 'package:cognitive/cognitive_app.dart';
import 'package:cognitive/features/database_config.dart';
import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgres/postgres.dart';

class SurveyScreen extends StatefulWidget {

  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _diseasesController = TextEditingController();
  final TextEditingController _sportsController = TextEditingController();
  final TextEditingController _wellBeingController = TextEditingController();
  bool isButtonDisabled = false;
  bool _isMounted = true; // Флаг для проверки монтирования

  int? _age;
  String? _gender;
  String? _education;
  String? _residence;
  int? _height;
  int? _weight;
  String? _dominantHand;
  bool? _smoking;
  String? _alcohol;
  bool? _insomnia;
  bool? _gamer;
  int? _wellBeing;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _isMounted = false; // Указываем, что виджет больше не смонтирован
    _specialtyController.dispose();
    _diseasesController.dispose();
    _sportsController.dispose();
    _wellBeingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

    void _goToTests() {
    debugPrint("User are going to successReg");
    Navigator.of(context).pushNamed(
      '/successReg',
    );
  }

  Future<bool> resultsToDB() async {
    // Блокируем кнопку
    if (_isMounted) {
      setState(() {
        isButtonDisabled = true;
      });
    }

    // Сброс блокировки кнопки через 4 секунды
    Future.delayed(const Duration(seconds: 4), () {
      if (_isMounted) {
        setState(() {
          isButtonDisabled = false;
        });
      }
    });

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
    SELECT cognitive."f\$users__write_form"(
    vp_user_id => @vp_user_id, 
    vp_age => @vp_age,
    vp_education => @vp_education,
    vp_speciality => @vp_speciality,
    vp_residence => @vp_residence,
    vp_height => @vp_height,
    vp_weight => @vp_weight,
    vp_lead_hand => @vp_lead_hand,
    vp_diseases => @vp_diseases,
    vp_smoking => @vp_smoking,
    vp_alcohol => @vp_alcohol,
    vp_sport => @vp_sport,
    vp_insomnia => @vp_insomnia,
    vp_current_health => @vp_current_health,
    vp_gaming => @vp_gaming

    )'''
    ),
    parameters: {
      'vp_user_id': userId,  
      'vp_age': _age,
      'vp_education': _education,
      'vp_speciality': _specialtyController.text,
      'vp_residence': _residence,
      'vp_height': _height,
      'vp_weight': _weight,
      'vp_lead_hand': _dominantHand,
      'vp_diseases': _diseasesController.text,
      'vp_smoking': _smoking,
      'vp_alcohol': _alcohol,
      'vp_sport': _sportsController.text,
      'vp_insomnia': _insomnia,
      'vp_current_health': _wellBeing,
      'vp_gaming': _gamer,
    },
  );

  debugPrint('$sendResults');
  final result = sendResults.first.first == null;

  conn.close();
  return result;
    
  } catch (e) {
    debugPrint('Ошибка подключения к бд из resultsToDB: $e');
    _showDatabaseError('Ошибка: не удалось сохранить информацию');
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
  Widget build(BuildContext context) {
    debugPrint(AuthManager.getUsername());
    return Scaffold(
      backgroundColor: const Color(0xFF373737),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Скрыть стрелку "Назад"
        title: const Text(
          'Введите информацию о себе',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF373737),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNumberField(
                label: 'Возраст',
                onChanged: (value) => _age = int.tryParse(value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Это поле обязательно';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Введите корректный возраст';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Как вы себя чувствуете сейчас?', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  List<String> emojis = ['😢', '🙁', '😐', '🙂', '😁'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _wellBeing = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _wellBeing == index ? Colors.white : Colors.transparent,
                      ),
                      child: Text(
                        emojis[index],
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Базовое образование',
                value: _education,
                items: [
                  'Основное общее',
                  'Среднее общее',
                  'Высшее образование: бакалавриат',
                  'Высшее образование: магистратура, специалитет',
                ],
                onChanged: (value) => setState(() => _education = value),
                validator: (value) => value == null ? 'Выберите образование' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _specialtyController,
                hintText: 'Специальность',
                validator: (value) => value == null || value.isEmpty ? 'Это поле обязательно' : null,
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Место основного проживания',
                value: _residence,
                items: [
                  'Столичный город (Москва или Санкт-Петербург)',
                  'Областной центр',
                  'Районный центр',
                  'Малый город или поселок городского типа',
                  'Деревня/село'
                ],
                onChanged: (value) => setState(() => _residence = value),
                validator: (value) => value == null ? 'Выберите место проживания' : null,
              ),
              const SizedBox(height: 16),
              _buildNumberField(
                label: 'Рост (см)',
                onChanged: (value) => _height = int.tryParse(value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Это поле обязательно';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Введите корректный рост';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildNumberField(
                label: 'Вес (кг)',
                onChanged: (value) => _weight = int.tryParse(value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Это поле обязательно';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Введите корректный вес';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Ведущая рука',
                value: _dominantHand,
                items: ['Правая', 'Левая'],
                onChanged: (value) => setState(() => _dominantHand = value),
                validator: (value) => value == null ? 'Выберите ведущую руку' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _diseasesController,
                hintText: 'Заболевания',
                validator: (value) => value == null || value.isEmpty ? 'Это поле обязательно' : null,
              ),
              const SizedBox(height: 16),
              _buildSwitchField(
                label: 'Курение',
                value: _smoking,
                onChanged: (value) => setState(() => _smoking = value),
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Как часто Вы употребляете алкогольные напитки?',
                value: _alcohol,
                items: [
                  'Никогда',
                  'Раз в месяц или реже',
                  '2-4 раза в месяц',
                  '2-3 раза в неделю',
                  '4 раза в неделю и чаще'
                ],
                onChanged: (value) => setState(() => _alcohol = value),
                validator: (value) => value == null ? 'Выберите регулярность' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _sportsController,
                hintText: 'Каким спортом занимаетесь',
                validator: (value) => value == null || value.isEmpty ? 'Это поле обязательно' : null,
              ),
              const SizedBox(height: 16),
              _buildSwitchField(
                label: 'Бессонница',
                value: _insomnia,
                onChanged: (value) => setState(() => _insomnia = value),
              ),
              const SizedBox(height: 16),
              _buildSwitchField(
                label: 'Являетесь ли любителем компьютерных игр',
                value: _gamer,
                onChanged: (value) => setState(() => _gamer = value),
              ),
              const SizedBox(height: 24),
              Center(
              child: const Text(
                'Перед началом тестирования просим Вас сосредоточиться и по возможности пройти все шесть предложенных тестов. Это займет примерно 15 минут',
                style: TextStyle(color: Colors.white), 
                textAlign: TextAlign.center,
              ),
              ),
            const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A4A4A), //  цвет кнопки
                  foregroundColor: Colors.white, // цвет текста кнопки
                ),
                  onPressed: isButtonDisabled
                  ? null
                  : () async {
                              if (_wellBeing == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Оцените свое самочувствие'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
    
                    if (_formKey.currentState?.validate() ?? false) {
                      final isResultsSendSuccess = await resultsToDB();
                      if (isResultsSendSuccess) {
                      AuthManager.setUserLoggedIn(true);
                      _goToTests();
                      }
                    }
                  },
                  child: const Text('Перейти к тестам'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildTextField({
  required TextEditingController controller,
  required String hintText,
  String? Function(String?)? validator,
}) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF4A4A4A),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: validator,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[А-Яа-яЁё\s]+')),
      ],
    ),
  );
}


  Widget _buildNumberField({
    required String label,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF4A4A4A),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Введите значение',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF4A4A4A),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF4A4A4A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildSwitchField({
    required String label,
    required bool? value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        Switch(
          value: value ?? false,
          onChanged: (bool newValue) => onChanged(newValue),
        ),
      ],
    );
  }

}
