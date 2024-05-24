import 'package:flutter/material.dart';
import 'package:surveys_app_project/colors.dart';

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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Thank You',
                  style: TextStyle(
                    color: Color(0xFFFFA500),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to home screen
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
                    ),
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
}