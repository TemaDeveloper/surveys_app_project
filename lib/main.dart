import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:surveys_app_project/pages/auth_wrapper.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Log Firebase initialization
  print("Initializing Firebase...");
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCth5aXXiUyRDIHDVdczjiPWWE2LslZ7M4",
          authDomain: "nightcaps-75442.firebaseapp.com",
          databaseURL: "https://nightcaps-75442-default-rtdb.firebaseio.com",
          projectId: "nightcaps-75442",
          storageBucket: "nightcaps-75442.appspot.com",
          messagingSenderId: "753614534084",
          appId: "1:753614534084:web:bb583173dd924768aae091",
          measurementId: "G-33TLWKTX6E",
      ),
    );
    print("Firebase initialized for Web");
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized for Mobile/Desktop");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("Building MaterialApp...");
    return MaterialApp(
      title: 'NightCaps Questionnaire',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
    );
  }
}
