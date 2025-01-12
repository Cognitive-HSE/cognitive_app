import 'package:cognitive/features/registration/initial_screen.dart';
import 'package:cognitive/features/registration/registration_screen.dart';
import 'package:cognitive/features/tests/birdTest/bird_test_description_screen.dart';
import 'package:cognitive/features/tests/birdTest/bird_test_screen.dart';
import 'package:cognitive/features/tests/munstTest/munst_test_screen.dart';
import 'package:cognitive/features/tests/munstTest/munst_test_description_screen.dart';
import 'package:cognitive/features/tests_list/tests_list_screen.dart';
import '../features/registration/success_reg_screen.dart';

final routes = {
        '/registration': (context) => const RegistrationScreen(),
        '/successReg': (context) => const SuccessRegScreen(),
        '/testList': (context) => const TestsListScreen(),
        '/testList/munstTestDescription': (context) => const MunstTestDescriptionScreen(), 
        '/munstTest': (context) => const MunstTestScreen(),
        '/testList/birdTestDescription': (context) => const BirdTestDescriptionScreen(),
        '/birdTest': (context) => const BirdtestScreen(),
        '/': (context) => const InitialScreen(),
      };