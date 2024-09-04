import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surveys_app_project/manager/shared_pref_manager.dart';
import 'package:surveys_app_project/pages/questioner.dart';
import 'package:surveys_app_project/pages/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surveys_app_project/pages/waiting_page.dart';

class AuthWrapper extends StatefulWidget {
  State<AuthWrapper> createState() => AuthWrapperState();
}

class AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkSurveyCompleted(String userId) async {
    final userCollection = FirebaseFirestore.instance.collection('users');

    DocumentSnapshot doc = await userCollection.doc(userId).get();
    if (doc.exists) {
      return doc['survey_completed'] ?? false;
    } else {
      return false; // Default to false if user document does not exist
    }
  }

  @override
  Widget build(BuildContext context) {
    UserDataManager userDataManager = UserDataManager();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return FutureBuilder<String>(
            future: userDataManager.getUid(),
            builder: (context, uidSnapshot) {
              if (uidSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (uidSnapshot.hasError) {
                return Center(child: Text('Error: ${uidSnapshot.error}'));
              }

              if (uidSnapshot.hasData) {
                String? userId = uidSnapshot.data;
                if (userId != null && userId.isNotEmpty) {
                  return FutureBuilder<bool>(
                    future: checkSurveyCompleted(userId),
                    builder: (context, surveySnapshot) {
                      if (surveySnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (surveySnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${surveySnapshot.error}'));
                      }

                      if (surveySnapshot.hasData) {
                        bool surveyCompleted = surveySnapshot.data!;
                        if (surveyCompleted) {
                          return CompletedSurveyPage();
                        } else {
                          
                          return QuestionnaireScreen();
                        }
                      }

                      return Center(child: Text('Unexpected error occurred'));
                    },
                  );
                } else {
                  return AuthPage();
                }
              }

              return Center(child: Text('Unexpected error occurred'));
            },
          );
        } else {
          return AuthPage();
        }
      },
    );
  }
}
