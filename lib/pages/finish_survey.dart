import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surveys_app_project/colors.dart';
import 'package:surveys_app_project/models/usaers_answers.dart';
import 'package:surveys_app_project/pages/waiting_page.dart';

class SubmissionSuccessScreen extends StatelessWidget {
  final List<String>? questions;
  final List<String>? selectedAnswers;
  final String? email;

  SubmissionSuccessScreen.withData({
    required this.questions,
    required this.selectedAnswers,
    this.email,
  });

  SubmissionSuccessScreen()
      : questions = null,
        selectedAnswers = null,
        email = null;

  @override
  Widget build(BuildContext context) {
    if (questions == null || selectedAnswers == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
              'No data available. Please make sure to pass data correctly.'),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 40), // Add spacing for top padding
              Center(
                child: Image.asset(
                  "assets/nightcaps_logo.png",
                  height: 200, // Adjust height to match the desired size
                ),
              ),
              Spacer(),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF0070F3),
                      size: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Successful Submission',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'arial_rounded',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Thank You',
                      style: TextStyle(
                        color: Color(0xFFFFA500),
                        fontSize: 20,
                        fontFamily: 'arial_rounded',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await updateSurveyCompletion(context); // Pass context
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0070F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'arial_rounded',
                  ),
                ),
              ),
              SizedBox(height: 20), // Add spacing for bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateSurveyCompletion(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;
      final userCollection = FirebaseFirestore.instance.collection('users');
      final usersAnswersCollection =
          FirebaseFirestore.instance.collection('users_answers');

      try {
        await userCollection.doc(userId).update(
            {'survey_completed': true, 'last_entered': Timestamp.now()});

        final newUserAnswer = UserAnswerModel(
          uid: user.uid,
          email: email,
          answers: selectedAnswers!,
          questions: questions!,
        ).toJson();

        print('newUserAnswer: $newUserAnswer');

        await usersAnswersCollection.doc().set(newUserAnswer);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CompletedSurveyPage()),
        );
      } catch (e) {
        print('Error updating survey completion status: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }
}
