import 'package:cognitive/features/no_internet_screen.dart';
import 'package:cognitive/features/app_version/update_app_screen.dart';
import 'package:cognitive/features/initial_screen.dart';
import 'package:cognitive/features/login+registration/login/login_screen.dart';
import 'package:cognitive/features/login+registration/login/success_login_screen.dart';
import 'package:cognitive/features/login+registration/registration/registration_screen.dart';
import 'package:cognitive/features/login+registration/registration/survey_screen.dart';
import 'package:cognitive/features/tests/birdTest/bird_test_description_screen.dart';
import 'package:cognitive/features/tests/birdTest/bird_test_screen.dart';
import 'package:cognitive/features/tests/munstTest/munst_test_screen.dart';
import 'package:cognitive/features/tests/munstTest/munst_test_description_screen.dart';
import 'package:cognitive/features/tests/numberTest/number_test_description_screen.dart';
import 'package:cognitive/features/tests/numberTest/number_test_screen.dart';
import 'package:cognitive/features/tests/compometry_test/comp_description_screen.dart';
import 'package:cognitive/features/tests/compometry_test/comp_screen.dart';
import 'package:cognitive/features/tests/strupTest/strup_test_description_screen.dart';
import 'package:cognitive/features/tests/strupTest/strup_test_screen.dart';
import 'package:cognitive/features/tests/tag_test/tag_test_screen.dart';
import 'package:cognitive/features/tests/tag_test/tag_test_description_screen.dart';
import 'package:cognitive/features/tests_list/tests_list_screen.dart';
import '../features/login+registration/registration/success_reg_screen.dart';

final routes = {
        '/registration': (context) => const RegistrationScreen(),
        '/successReg': (context) => const SuccessRegScreen(),
        '/login': (context) => const LoginScreen(),
        '/successLogin': (context) => const SuccessLoginScreen(),
        '/testList': (context) => const TestsListScreen(),
        '/testList/munstTestDescription': (context) => const MunstTestDescriptionScreen(), 
        '/munstTest': (context) => const MunstTestScreen(),
        '/testList/birdTestDescription': (context) => const BirdTestDescriptionScreen(),
        '/birdTest': (context) => const BirdtestScreen(),
        '/': (context) => const InitialScreen(),
        '/testList/numberTestDescription': (context) => const NumberTestDescriptionScreen(),
        '/numberTest': (context) => NumberTestScreen(),
        '/testList/tagTestDescription': (context) => TagTestDescriptionScreen(),
        '/tagTest': (context) => TagTestScreen(),
        '/testList/strupTestDescription': (context) => const StrupTestDescriptionScreen(),
        '/strupTest': (context) => StrupTestScreen(),
        '/testList/compTestDescription': (context) => CampimetryDescriptionScreen(),
        '/campimetryTest': (context) => CampimetryScreen(),
        '/surveyScreen' : (context) => SurveyScreen(),
        '/updateAppScreen': (context) => UpdateAppScreen(),
        '/noInternetScreen': (context) => const NoInternetScreen()
      };