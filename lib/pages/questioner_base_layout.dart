import 'package:flutter/material.dart';
import 'answer_options.dart'; 
import 'question_answer_struct.dart';

class QuestionPage extends StatefulWidget {
  final QuestionAnswer questionAnswer;
  final void Function(String, List<String>) onSave;
  final List<String> Function(String) getSavedAnswers;

  QuestionPage({
    required this.questionAnswer,
    required this.onSave,
    required this.getSavedAnswers,
  });

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<String> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    selectedAnswers = widget.getSavedAnswers(widget.questionAnswer.questionId);
  }

  void _saveAnswers() {
    widget.onSave(widget.questionAnswer.questionId, selectedAnswers);
  }

  void _onAnswerSelected(String answer) {
    setState(() {
      if (widget.questionAnswer.isMultipleChoice) {
        if (answer == 'None') {
          selectedAnswers = [answer];
        } else {
          if (selectedAnswers.contains(answer)) {
            selectedAnswers.remove(answer);
          } else {
            selectedAnswers.add(answer);
            selectedAnswers.remove('None');
          }
        }
      } else {
        selectedAnswers = [answer];
      }
      _saveAnswers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: widget.questionAnswer.answers.map((answer) {
            return AnswerOption(
              answer: answer,
              isSelected: selectedAnswers.contains(answer),
              isMultipleChoice: widget.questionAnswer.isMultipleChoice,
              onSelected: _onAnswerSelected,
            );
          }).toList(),
        ),
        Spacer(),
      ],
    );
  }
}


