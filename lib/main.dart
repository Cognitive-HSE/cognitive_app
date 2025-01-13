
import 'package:cognitive/cognitive_app.dart';
import 'package:cognitive/features/login+registration/utils/auth_manager.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthManager.init(); // Инициализация GetStorage
  runApp(const CognitiveApp());
}


