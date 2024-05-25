import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surveys_app_project/colors.dart';
import 'package:surveys_app_project/manager/shared_pref_manager.dart';
import 'package:surveys_app_project/pages/waiting_page.dart';

class SubmissionSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Spacer(),
                Image.asset("assets/nightcaps_logo.png"),
                const SizedBox(height: 20),
                // Text(
                //   'NightCaps Sleeping Habits Questionnaire',
                //   style: TextStyle(
                //     color: Color(0xFF1E90FF),
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // Text(
                //   'Fighting sleep deprivation, one day at a time',
                //   style: TextStyle(
                //     color: Color(0xFFFFA500),
                //     fontSize: 16,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                //Spacer(),
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.facebookBlue,
                  size: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'Successful Submission',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'arial_rounded'),
                ),
                Text(
                  'Thank You',
                  style: TextStyle(
                      color: Color(0xFFFFA500),
                      fontSize: 20,
                      fontFamily: 'arial_rounded'),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    updateSurveyCompletion();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompletedSurveyPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.facebookBlue, // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    'Home',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'arial_rounded'),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateSurveyCompletion() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String userId = user.uid; // UID from Firebase Auth
    final userCollection = FirebaseFirestore.instance.collection('users');

    try {
      DocumentSnapshot doc = await userCollection.doc(userId).get();

      if (doc.exists) {
        await userCollection.doc(userId).update({'survey_completed': true});
        await userCollection.doc(userId).update({'last_entered': Timestamp.now()});
        print('Survey completion status updated successfully.');
      } else {
        print('User document not found. Creating new document.');
      }
    } catch (e) {
      print('Error updating survey completion status: $e');
    }
  } else {
    print('No user is currently signed in.');
  }
}
}