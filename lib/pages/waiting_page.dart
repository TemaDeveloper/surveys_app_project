import 'package:flutter/material.dart';

class CompletedSurveyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
