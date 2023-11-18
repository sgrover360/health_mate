// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDJQGy-n0_TIQJZx8r0aJ9aUwAhGXKCo84',
    appId: '1:408911448811:web:4aa476ac6011d0324c4cae',
    messagingSenderId: '408911448811',
    projectId: 'healthmate-a6451',
    authDomain: 'healthmate-a6451.firebaseapp.com',
    storageBucket: 'healthmate-a6451.appspot.com',
    measurementId: 'G-44KKQ70P1C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZixwGlCKim8CDC79-XMtRFVWWUHZaQV0',
    appId: '1:408911448811:android:07e3ae38e1c0a2f54c4cae',
    messagingSenderId: '408911448811',
    projectId: 'healthmate-a6451',
    storageBucket: 'healthmate-a6451.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBy54cpoopN6Wh7lCskafOdakShKFEBbT8',
    appId: '1:408911448811:ios:386e6b4e6c960fd24c4cae',
    messagingSenderId: '408911448811',
    projectId: 'healthmate-a6451',
    storageBucket: 'healthmate-a6451.appspot.com',
    iosClientId: '408911448811-7k305vga5fh8pmk3ld2r58nukdjr4l64.apps.googleusercontent.com',
    iosBundleId: 'com.example.healthMate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBy54cpoopN6Wh7lCskafOdakShKFEBbT8',
    appId: '1:408911448811:ios:c2bd9af7487ef42f4c4cae',
    messagingSenderId: '408911448811',
    projectId: 'healthmate-a6451',
    storageBucket: 'healthmate-a6451.appspot.com',
    iosClientId: '408911448811-8rphiv9o7tnf9j4hhlnmecivb29vjtfk.apps.googleusercontent.com',
    iosBundleId: 'com.example.healthMate.RunnerTests',
  );
}