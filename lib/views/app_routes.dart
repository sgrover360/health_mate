import 'package:flutter/material.dart';
import 'package:health_mate/views/theme_provider.dart';
import 'package:provider/provider.dart';

import 'profile_page.dart';
import 'home_page.dart';

class AppRoutes extends StatelessWidget {
  const AppRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/profile': (context) => ProfilePage()
      },
    );
  }
}
