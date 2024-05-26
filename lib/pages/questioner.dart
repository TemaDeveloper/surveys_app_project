import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _isNextButtonEnabled = false;
  late Future<List<QuestionAnswer>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _questionsFuture = _loadQuestions(context);
  }

  Future<List<QuestionAnswer>> _loadQuestions(BuildContext context) async {
    try {
      return [
        QuestionAnswer(
          question: await _getQuestion(context, "1") ?? "Default Question 1",
          answers: await _getAnswers(context, "1"),
          selectionType: SelectionType.Single,
          questionId: 'q${await _getQid(context, "1")}',
          pageIndex: await _getQid(context, "1"),
        ),
        QuestionAnswer(
          question: await _getQuestion(context, "2") ?? "Default Question 2",
          answers: await _getAnswers(context, "2"),
          selectionType: SelectionType.Single,
          questionId: 'q${await _getQid(context, "2")}',
          pageIndex: await _getQid(context, "2"),
        ),
        QuestionAnswer(
          question: await _getQuestion(context, "3") ?? "Default Question 3",
          answers: await _getAnswers(context, "3"),
          selectionType: SelectionType.Multiple,
          questionId: 'q${await _getQid(context, "3")}',
          pageIndex: await _getQid(context, "3"),
        ),
        QuestionAnswer(
          question: await _getQuestion(context, "4") ?? "Default Question 4",
          answers: await _getAnswers(context, "4"),
          pairs: await _getPairs(context, "4"),
          selectionType: SelectionType.AtLeastOne,
          questionId: 'q${await _getQid(context, "4")}',
          pageIndex: await _getQid(context, "4"),
        ),
        QuestionAnswer(
          question: await _getQuestion(context, "5") ?? "Default Question 5",
          answers: await _getAnswers(context, "5"),
          selectionType: SelectionType.Multiple,
          questionId: 'q${await _getQid(context, "5")}',
          pageIndex: await _getQid(context, "5"),
        ),
        QuestionAnswer(
          question: await _getQuestion(context, "6") ?? "Default Question 6",
          answers: await _getAnswers(context, "6"),
          selectionType: SelectionType.Multiple,
          questionId: 'q${await _getQid(context, "6")}',
          pageIndex: await _getQid(context, "6"),
        ),
      ];
    } catch (e) {
      print('Error loading questions: $e');
      throw Exception('Error loading questions');
    }
  }

  bool isAnswerSelected(List<QuestionAnswer> questions) {
    final currentQuestion = questions[_currentPage];
    final selectedAnswers = _getSavedAnswers(currentQuestion.questionId);
    return selectedAnswers.isNotEmpty;
  }

  void _nextPage(List<QuestionAnswer> questions) {
    final currentQuestion = questions[_currentPage];
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

    if (_currentPage < questions.length - 1) {
      setState(() {
        _currentPage++;
        _isNextButtonEnabled = false;
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    }
  }

  void _previousPage(List<QuestionAnswer> questions) {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _isNextButtonEnabled =
            _getSavedAnswers(questions[_currentPage].questionId).isNotEmpty;
        _pageController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    }
  }

  void _saveAnswers(String questionId, List<String>? selectedAnswers) {
    AnswerStore().saveAnswer(questionId, selectedAnswers);
    setState(() {
      _isNextButtonEnabled = selectedAnswers!.isNotEmpty;
    });
  }

  List<String> _getSavedAnswers(String questionId) {
    return AnswerStore().getAnswer(questionId);
  }

  void _onOptionsCountChange(bool isEnabled) {
    setState(() {
      _isNextButtonEnabled = isEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: AppBar(
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Image.asset(
                    "assets/nightcaps_logo.png",
                    fit: BoxFit.contain,
                    height: 150,
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
        ),
        body: FutureBuilder<List<QuestionAnswer>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading questions'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No questions available'));
            } else {
              List<QuestionAnswer> questions = snapshot.data!;
              return Stack(
                children: [
                  Column(
                    children: [
                      ProgressBar(
                        currentPage: _currentPage + 1,
                        totalPages: questions.length,
                      ),
                      QuestionText(question: questions[_currentPage].question),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: questions.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                              _isNextButtonEnabled =
                                  _getSavedAnswers(questions[index].questionId)
                                      .isNotEmpty;
                            });
                          },
                          itemBuilder: (context, index) {
                            return QuestionPage(
                              questionAnswer: questions[index],
                              onSave: _saveAnswers,
                              getSavedAnswers: _getSavedAnswers,
                              onOptionsCountChange: index == 3
                                  ? _onOptionsCountChange
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  NavigationButtons(
                    currentPage: _currentPage,
                    totalPages: questions.length,
                    onPrevious: () => _previousPage(questions),
                    onNext: () => _nextPage(questions),
                    isAnswerSelected: isAnswerSelected(questions),
                    isNextButtonEnabled: _isNextButtonEnabled,
                  ),
                  const SizedBox(height: 40),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<String?> _getQuestion(BuildContext context, String qCounter) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userCollection = FirebaseFirestore.instance.collection('questions');
        DocumentSnapshot docSnapshot = await userCollection.doc(qCounter).get();

        if (docSnapshot.exists) {
          var data = docSnapshot.data() as Map<String, dynamic>;
          String? question = data['question'] as String?;
          return question;
        }
      }
    } catch (e) {
      print('Error fetching question $qCounter: $e');
    }
    return null;
  }

  Future<int?> _getQid(BuildContext context, String qCounter) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userCollection = FirebaseFirestore.instance.collection('questions');
        DocumentSnapshot docSnapshot = await userCollection.doc(qCounter).get();

        if (docSnapshot.exists) {
          var data = docSnapshot.data() as Map<String, dynamic>;
          int? qid = data['qid'] as int?;
          return qid;
        }
      }
    } catch (e) {
      print('Error fetching qid $qCounter: $e');
    }
    return null;
  }

  Future<List<String>> _getAnswers(BuildContext context, String qCounter) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userCollection = FirebaseFirestore.instance.collection('questions');
        DocumentSnapshot docSnapshot = await userCollection.doc(qCounter).get();

        if (docSnapshot.exists) {
          var data = docSnapshot.data() as Map<String, dynamic>;
          List<String> answers = List<String>.from(data['answers']);
          return answers;
        }
      }
    } catch (e) {
      print('Error fetching answers for $qCounter: $e');
    }
    return [];
  }

  Future<List<List<String>>> _getPairs(BuildContext context, String qCounter) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userCollection = FirebaseFirestore.instance.collection('questions');
      DocumentSnapshot docSnapshot = await userCollection.doc(qCounter).get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> pairsData = data['pairs'] as List<dynamic>;
        List<List<String>> pairs = [];

        for (var pair in pairsData) {
          List<String> pairValues = [];
          if (pair.containsKey('pair1')) pairValues.add(pair['pair1'] ?? '');
          if (pair.containsKey('pair2')) pairValues.add(pair['pair2'] ?? '');
          if (pair.containsKey('pair3')) pairValues.add(pair['pair3'] ?? '');
          if (pair.containsKey('pair4')) pairValues.add(pair['pair4'] ?? '');
          if (pair.containsKey('pair5')) pairValues.add(pair['pair5'] ?? '');
          if (pair.containsKey('pair6')) pairValues.add(pair['pair6'] ?? '');
          pairs.add(pairValues);
        }
        return pairs;
      }
    }
  } catch (e) {
    print('Error fetching pairs for $qCounter: $e');
  }
  return [];
}


}
