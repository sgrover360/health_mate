import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, AuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

import 'app_routes.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final List<AuthProvider<AuthListener, AuthCredential>> providers = [
    EmailAuthProvider(),
    GoogleProvider(
        clientId:
            "1005622537424-ek0pnmrgkou172j6afli4ec8m0de9b8p.apps.googleusercontent.com")
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              providers: providers,
              headerBuilder: (context, constraints, shrinkOffset) {
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 100, // Set the desired width
                          height: 100, // Set the desired height
                        ),
                      ),
                    ),
                    const Text('Health Mate', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ],
                );
              },
              footerBuilder: (context, action) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'By signing in, you agree to our terms and conditions.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
            );
          } else {
            return const AppRoutes();
          }
        });
  }
}