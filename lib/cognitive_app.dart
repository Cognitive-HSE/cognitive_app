import 'package:cognitive/router/router.dart';
import 'package:flutter/material.dart';
import 'theme/theme.dart';

class CognitiveApp extends StatelessWidget {
  const CognitiveApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration',
      theme: theme,
      routes: routes,
    );
  }
}