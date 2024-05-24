// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCPWkW7GlWWvr6_5wnhiazF1GoU4N-FpN4',
    appId: '1:753614534084:ios:0203846ea8d71a41aae091',
    messagingSenderId: '753614534084',
    projectId: 'nightcaps-75442',
    databaseURL: 'https://nightcaps-75442-default-rtdb.firebaseio.com',
    storageBucket: 'nightcaps-75442.appspot.com',
    iosBundleId: 'com.example.surveysAppProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCth5aXXiUyRDIHDVdczjiPWWE2LslZ7M4',
    appId: '1:753614534084:web:b97bf9e558f34560aae091',
    messagingSenderId: '753614534084',
    projectId: 'nightcaps-75442',
    authDomain: 'nightcaps-75442.firebaseapp.com',
    databaseURL: 'https://nightcaps-75442-default-rtdb.firebaseio.com',
    storageBucket: 'nightcaps-75442.appspot.com',
    measurementId: 'G-SEPBTHQLC2',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCth5aXXiUyRDIHDVdczjiPWWE2LslZ7M4',
    appId: '1:753614534084:web:b97bf9e558f34560aae091',
    messagingSenderId: '753614534084',
    projectId: 'nightcaps-75442',
    authDomain: 'nightcaps-75442.firebaseapp.com',
    databaseURL: 'https://nightcaps-75442-default-rtdb.firebaseio.com',
    storageBucket: 'nightcaps-75442.appspot.com',
    measurementId: 'G-SEPBTHQLC2',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPWkW7GlWWvr6_5wnhiazF1GoU4N-FpN4',
    appId: '1:753614534084:ios:0203846ea8d71a41aae091',
    messagingSenderId: '753614534084',
    projectId: 'nightcaps-75442',
    databaseURL: 'https://nightcaps-75442-default-rtdb.firebaseio.com',
    storageBucket: 'nightcaps-75442.appspot.com',
    iosBundleId: 'com.example.surveysAppProject',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLFDwXLSfHDhTELWceiX31q7uid38zwOA',
    appId: '1:753614534084:android:b150b45da92f73a2aae091',
    messagingSenderId: '753614534084',
    projectId: 'nightcaps-75442',
    databaseURL: 'https://nightcaps-75442-default-rtdb.firebaseio.com',
    storageBucket: 'nightcaps-75442.appspot.com',
  );

}