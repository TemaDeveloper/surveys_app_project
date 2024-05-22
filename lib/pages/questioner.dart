import 'package:flutter/material.dart';
import '/widgets/progress_bar.dart';
import '/widgets/question_text.dart';
import '/widgets/navigation_buttons.dart';
import 'questioner_base_layout.dart';
import 'question_answer_struct.dart'; 
import 'answer_store.dart';

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  final List<QuestionAnswer> _questions = [
    QuestionAnswer(
      question: 'Did you take your NightCaps when you brushed your teeth last night?',
      answers: ['Yes', 'No'],
      isMultipleChoice: false,
      questionId: 'q1',
      pageIndex: 1,
    ),
    QuestionAnswer(
      question: 'How do you feel this morning?',
      answers: ['Fantastic', 'Pretty Good', 'Okay', 'Not Great', 'Exhausted'],
      isMultipleChoice: false,
      questionId: 'q2',
      pageIndex: 2,
    ),
    QuestionAnswer(
      question: 'What screens did you watch within 1 hour of going to bed?',
      answers: ['TV', 'Computer', 'E-reader', 'Phone', 'None'],
      isMultipleChoice: true,
      questionId: 'q3',
      pageIndex: 3,
    ),
    QuestionAnswer(
      question: 'Did you have/do any of the following within 2 hours of bed?',
      answers: ['Smoke', 'Caffeine', 'Alcohol', 'Big Meal', 'Exercise', 'None'],
      isMultipleChoice: true,
      questionId: 'q4',
      pageIndex: 4,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _questions.length - 1) {
      setState(() {
        _currentPage++;
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _pageController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    }
  }

  void _saveAnswers(String questionId, List<String> selectedAnswers) {
    AnswerStore().saveAnswer(questionId, selectedAnswers);
  }

  List<String> _getSavedAnswers(String questionId) {
    return AnswerStore().getAnswer(questionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NightCaps Questionnaire'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ProgressBar(
                currentPage: _currentPage + 1,
                totalPages: _questions.length,
              ),
              QuestionText(question: _questions[_currentPage].question),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return QuestionPage(
                      questionAnswer: _questions[index],
                      onSave: _saveAnswers,
                      getSavedAnswers: _getSavedAnswers,
                    );
                  },
                ),
              ),
            ],
          ),
          NavigationButtons(
            currentPage: _currentPage,
            totalPages: _questions.length,
            onPrevious: _previousPage,
            onNext: _nextPage,
          ),
        ],
      ),
    );
  }
}
