import 'package:health_mate/views/auth_gate.dart';
import 'package:health_mate/views/logo_animation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Ensure Flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    theme: ThemeData(scaffoldBackgroundColor: Colors.red.shade50),
    home: const Scaffold(
      body: LogoAnimation(),
    ),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: AuthGate(),
      );
}
