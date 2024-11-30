import 'package:cognitive/features/registration/registration_screen.dart';
import 'package:cognitive/features/tests/birdTest/bird_test_screen.dart';
import 'package:cognitive/features/tests/one_test_screen.dart';
import 'package:cognitive/features/tests/test_description_screen.dart';
import 'package:cognitive/features/tests_list/tests_list_screen.dart';
import '../features/registration/success_reg_screen.dart';

final routes = {
        '/': (context) => const RegistrationScreen(),
        '/successReg': (context) => const SuccessRegScreen(),
        '/successReg/testList': (context) => const TestsListScreen(),
        '/successReg/testList/testDescription': (context) => const TestDescriptionScreen(), 
        '/successReg/testList/testDescription/oneTest': (context) => OneTestScreen(),
      };