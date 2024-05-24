import 'package:flutter/material.dart';
import 'package:surveys_app_project/colors.dart';
import 'answer_options.dart'; 
import '../pages/question_answer_struct.dart';

class QuestionPage extends StatefulWidget {
  final QuestionAnswer questionAnswer;
  final void Function(String, List<String>) onSave;
  final List<String> Function(String) getSavedAnswers;
  final void Function(bool)? onOptionsCountChange; // Track option count changes

  QuestionPage({
    required this.questionAnswer,
    required this.onSave,
    required this.getSavedAnswers,
    this.onOptionsCountChange, // Initialize onOptionsCountChange
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
    if (widget.onOptionsCountChange != null) {
      Future.microtask(() {
        widget.onOptionsCountChange!(selectedAnswers.length >= 3); // Check initial count
      });
    }
  }

  void _saveAnswers() {
    widget.onSave(widget.questionAnswer.questionId, selectedAnswers);
  }

  void _onAnswerSelected(String answer) {
    setState(() {
      if (answer == 'none') {
        selectedAnswers = ['none'];
      } else {
        if (selectedAnswers.contains('none')) {
          selectedAnswers.remove('none');
        }

        // Handle pair logic
        if (widget.questionAnswer.pairs != null) {
          for (var pair in widget.questionAnswer.pairs!) {
            if (pair.contains(answer)) {
              for (var option in pair) {
                if (option != answer) {
                  selectedAnswers.remove(option);
                }
              }
            }
          }
        }

        if (selectedAnswers.contains(answer)) {
          selectedAnswers.remove(answer);
        } else {
          if (widget.questionAnswer.selectionType == SelectionType.Single) {
            selectedAnswers = [answer];
          } else {
            selectedAnswers.add(answer);
          }
        }
      }
      _saveAnswers();
      if (widget.onOptionsCountChange != null) {
        Future.microtask(() {
          widget.onOptionsCountChange!(selectedAnswers.length >= 3); // Check count after selection
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.questionAnswer.selectionType == SelectionType.Multiple)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "(Select All That Apply)",
              style: TextStyle(fontSize: 16.0, color: AppColors.brightOrange),
            ),
          ),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: widget.questionAnswer.answers.map((answer) {
            return AnswerOption(
              answer: answer,
              isSelected: selectedAnswers.contains(answer),
              isMultipleChoice: widget.questionAnswer.selectionType != SelectionType.Single,
              onSelected: _onAnswerSelected,
            );
          }).toList(),
        ),
        Spacer(),
      ],
    );
  }
}