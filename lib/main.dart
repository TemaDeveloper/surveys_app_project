import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/pages/register.dart';
import 'firebase_options.dart'; 

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCth5aXXiUyRDIHDVdczjiPWWE2LslZ7M4",
            appId: "1:753614534084:web:bb583173dd924768aae091",
            messagingSenderId: "753614534084",
            projectId: "nightcaps-75442"));
  } else {
    await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NightCaps Questionnaire',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthPage(),
    );
  }
}
