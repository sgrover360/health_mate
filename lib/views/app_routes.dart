import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class AppRoutes extends StatelessWidget {
  const AppRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.red.shade50),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/profile': (context) => ProfileScreen(
              actions: [
                SignedOutAction((context) {
                  Navigator.of(context).pop();
                })
              ],
            )
      },
    );
  }
}
