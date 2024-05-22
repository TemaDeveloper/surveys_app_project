import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

class AnswerStore {
  static final AnswerStore _instance = AnswerStore._internal();

  factory AnswerStore() {
    return _instance;
  }

  AnswerStore._internal();

  final Map<String, List<String>> _answers = {};

  void saveAnswer(String questionId, List<String> answers) {
    _answers[questionId] = answers;
  }

  List<String> getAnswer(String questionId) {
    return _answers[questionId] ?? [];
  }
}

class QuestionAnswer {
  final String question;
  final List<String> answers;
  final bool isMultipleChoice;
  final String questionId;
  final int pageIndex;

  QuestionAnswer({
    required this.question,
    required this.answers,
    required this.isMultipleChoice,
    required this.questionId,
    required this.pageIndex,
  });
}

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
          duration: const Duration(milliseconds: 300),
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
          duration: const Duration(milliseconds: 300),
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
        title: const Text('NightCaps Questionnaire'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ProgressBar(
                currentPage: _currentPage + 1,
                totalPages: _questions.length,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _questions[_currentPage].question,
                  style: const TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
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
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Visibility(
              visible: _currentPage > 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousPage,
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage == _questions.length - 1) {
                    // Handle finish logic
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Thank you!'),
                        content: const Text('You have completed the questionnaire.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    _nextPage();
                  }
                },
                child: Text(_currentPage == _questions.length - 1 ? 'Finish' : 'Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  ProgressBar({required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        bool isSelected = currentPage == index + 1;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          child: CircleAvatar(
            radius: isSelected ? 15 : 10,
            backgroundColor: isSelected ? Colors.blue : Colors.grey,
            child: isSelected
                ? Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        );
      }),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: widget.questionAnswer.answers.map((answer) {
            bool isSelected = selectedAnswers.contains(answer);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.questionAnswer.isMultipleChoice) {
                    if (answer == 'None') {
                      selectedAnswers = [answer];
                    } else {
                      if (isSelected) {
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
              },
              child: Container(
                width: (MediaQuery.of(context).size.width / 2) - 24,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(answer),
                    SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.favorite, // Use a random icon here
                          color: isSelected ? Colors.white : Colors.grey[800],
                          size: 24.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: isSelected ? Colors.blue : Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        Spacer(),
      ],
    );
  }
}
