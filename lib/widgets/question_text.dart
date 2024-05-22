import 'package:flutter/material.dart';

class QuestionText extends StatelessWidget {
  final String question;

  QuestionText({required this.question});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        question,
        style: const TextStyle(fontSize: 18.0),
        textAlign: TextAlign.center,
      ),
    );
  }
}
