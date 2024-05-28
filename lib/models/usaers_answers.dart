import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surveys_app_project/pages/question_answer_struct.dart';

class UserAnswerModel {
  final String? email;
  final String? uid;
  final List<String> answers;
  final List<String> questions;

  UserAnswerModel({
    this.uid,
    this.email,
    required this.answers,
    required this.questions,
  });

  static UserAnswerModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserAnswerModel(
      uid: snapshot['uid'],
      email: snapshot['email'],
      answers: List<String>.from(snapshot['answers']),
      questions: List<String>.from(snapshot['questions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "answers": answers,
      "questions": questions,
    };
  }
}

// Function to convert QuestionAnswer objects to a list of question texts
List<String> questionsToTextList(List<QuestionAnswer> questions) {
  return questions.map((q) => q.question).toList();
}
