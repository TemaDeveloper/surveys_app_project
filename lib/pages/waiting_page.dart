import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:surveys_app_project/pages/questioner.dart';

class CompletedSurveyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkAndUpdateSurveyStatus(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Image.asset("assets/nightcaps_logo.png"),
          const Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'You have already completed your Great Sleeper Survey today.\nSleep well tonight!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontFamily: 'arial_rounded'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAndUpdateSurveyStatus(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot docSnapshot = await userCollection.doc(user.uid).get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        bool? surveyCompleted = data['survey_completed'] as bool?;
        Timestamp? lastEnteredTimestamp = data['last_entered'] as Timestamp?;
        DateTime lastEnteredDate = lastEnteredTimestamp?.toDate() ?? DateTime.now();
        DateTime currentDate = DateTime.now();

        // Compare dates by day only
        DateFormat dateFormat = DateFormat('yyyy-MM-dd');
        String lastEnteredDay = dateFormat.format(lastEnteredDate);
        String currentDay = dateFormat.format(currentDate);

        if (currentDay.compareTo(lastEnteredDay) > 0) {
          // Update survey_completed to false if the current date is greater than last_entered date
          await userCollection.doc(user.uid).update({'survey_completed': false});
          surveyCompleted = false;
        }

        if (surveyCompleted == false) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => QuestionnaireScreen()),
          );
        }else{
          print("Survey Already Completed");
        }
      } else {
        print('Document does not exist');
      }
    }
  }
}
