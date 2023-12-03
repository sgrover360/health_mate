import 'package:flutter/material.dart';
import 'package:health_mate/views/auth_gate.dart';

class AuthenticationCompletePage extends StatefulWidget {
  const AuthenticationCompletePage({super.key});

  @override
  _AuthenticationCompletePageState createState() => _AuthenticationCompletePageState();
}

class _AuthenticationCompletePageState extends State<AuthenticationCompletePage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      // Navigate back to AuthGate page after a 5-second delay
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthGate()),
              (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'We will get back to you once the authentication is complete.!!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Replace with your own animated doctor asset if you have one
            Image.asset('assets/doctor_animation.gif'),
          ],
        ),
      ),
    );
  }
}
