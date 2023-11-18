import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, AuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class EmptyHomePage extends StatelessWidget {
  const EmptyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(elevation: 10, title: const Text('Empty Home Page'), actions: [
        TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
            child: Text(
              "LOG OUT",
              style: TextStyle(color: Colors.grey[900]),
            ))
      ]),
      body: const Center(
        child: Text('This is an empty home page'),
      ),
    );
  }
}

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
    return AdaptiveTheme(
      light: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade100,
        primarySwatch: Colors.grey,
      ),
      dark: ThemeData.dark(useMaterial3: true),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        initialRoute:
            FirebaseAuth.instance.currentUser == null ? '/login' : '/',
        routes: {
          '/': (context) => const EmptyHomePage(),
          '/login': (context) {
            return SignInScreen(
              providers: providers, // make sure to define providers
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  Navigator.pushReplacementNamed(context, '/');
                }),
                AuthStateChangeAction<UserCreated>((context, state) {
                  Navigator.pushReplacementNamed(context, '/');
                }),
              ],
            );
          },
          '/emptyHomepage': (context) => const EmptyHomePage(),
        },
      ),
    );
  }
}
