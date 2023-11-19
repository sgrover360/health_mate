import 'package:flutter/material.dart';

import 'profile_page.dart';
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
        '/': (context) => HomePage(),
        '/profile': (context) => ProfilePage()
      },
    );
  }
}
