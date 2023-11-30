import 'package:flutter/material.dart';

class AuthenticationCompletePage extends StatelessWidget {
  const AuthenticationCompletePage({super.key});

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
