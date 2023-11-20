import 'package:flutter/material.dart';
import 'package:health_mate/pages/views/logo_animation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(scaffoldBackgroundColor: Colors.red.shade50),
    home: const Scaffold(
      body: LogoAnimation(),
    ),
  ));
}