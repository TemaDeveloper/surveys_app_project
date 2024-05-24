import 'package:flutter/material.dart';
import '/widgets/progress_bar.dart';
import '/widgets/question_text.dart';
import '/widgets/navigation_buttons.dart';
import '../question_answer_builder/questioner_base_layout.dart';
import 'question_answer_struct.dart';
import '../question_answer_builder/answer_store.dart';

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isNextButtonEnabled = false; // Initialize to false to disable Next button by default

  final List<QuestionAnswer> _questions = [
    QuestionAnswer(
      question: 'Did you take your NightCaps when you brushed your teeth last night?',
      answers: ['yes', 'no'],
      selectionType: SelectionType.Single,
      questionId: 'q1',
      pageIndex: 1,
    ),
    QuestionAnswer(
      question: 'How do you feel this morning?',
      answers: ['fantastic', 'pretty_good', 'okay', 'not_great', 'exhausted'],
      selectionType: SelectionType.Single,
      questionId: 'q2',
      pageIndex: 2,
    ),
    QuestionAnswer(
      question: 'What screens did you watch within 1 hour of going to bed?',
      answers: ['tv', 'computer', 'e_reader', 'phone', 'none'],
      selectionType: SelectionType.Multiple,
      questionId: 'q3',
      pageIndex: 3,
    ),
    QuestionAnswer(
      question: 'What was your bedroom like when you went to bed?',
      answers: ['light', 'dark', 'warm', 'cool', 'loud', 'quiet'],
      pairs: [
        ['light', 'dark'],
        ['warm', 'cool'],
        ['loud', 'quiet']
      ],
      selectionType: SelectionType.AtLeastOne,
      questionId: 'q4',
      pageIndex: 4,
    ),
    QuestionAnswer(
      question: 'What screens did you watch within 1 hour of going to bed?',
      answers: ['tv', 'computer', 'e_reader', 'phone', 'none'],
      selectionType: SelectionType.Multiple,
      questionId: 'q5',
      pageIndex: 5,
    ),
  ];

  bool get isAnswerSelected {
    final currentQuestion = _questions[_currentPage];
    final selectedAnswers = _getSavedAnswers(currentQuestion.questionId);
    return selectedAnswers.isNotEmpty;
  }

  void _nextPage() {
    final currentQuestion = _questions[_currentPage];
    final selectedAnswers = _getSavedAnswers(currentQuestion.questionId);

    if (_currentPage == 3 && !_isNextButtonEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select three options')),
      );
      return;
    }

    if (selectedAnswers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please choose at least one option')),
      );
      return;
    }

    if (_currentPage < _questions.length - 1) {
      setState(() {
        _currentPage++;
        _isNextButtonEnabled = false; // Reset button state for other pages
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
        _isNextButtonEnabled = _getSavedAnswers(_questions[_currentPage].questionId).isNotEmpty;
        _pageController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    }
  }

  void _saveAnswers(String questionId, List<String> selectedAnswers) {
    AnswerStore().saveAnswer(questionId, selectedAnswers);
    setState(() {
      _isNextButtonEnabled = selectedAnswers.isNotEmpty;
    });
  }

  List<String> _getSavedAnswers(String questionId) {
    return AnswerStore().getAnswer(questionId);
  }

  void _onOptionsCountChange(bool isEnabled) { // Handle option count changes
    setState(() {
      _isNextButtonEnabled = isEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: AppBar(
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Center(
                  child: Image.asset(
                    "assets/nightcaps_logo.png",
                    fit: BoxFit.contain,
                    height: 150, // Adjust the height as needed
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
      
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
                    onPageChanged: (index) { // Ensure page change is tracked
                      setState(() {
                        _currentPage = index;
                        _isNextButtonEnabled = _getSavedAnswers(_questions[index].questionId).isNotEmpty;
                      });
                    },
                    itemBuilder: (context, index) {
                      return QuestionPage(
                        questionAnswer: _questions[index],
                        onSave: _saveAnswers,
                        getSavedAnswers: _getSavedAnswers,
                        onOptionsCountChange: index == 3 ? _onOptionsCountChange : null, // Track option count changes only for page with pairs
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
              isAnswerSelected: isAnswerSelected,
              isNextButtonEnabled: _isNextButtonEnabled, // Pass button state to NavigationButtons
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}