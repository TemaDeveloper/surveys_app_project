import 'package:flutter/material.dart';
import '/pages/questioner.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NightCaps Questionnaire',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuestionnaireScreen(),
    );
  }
}
