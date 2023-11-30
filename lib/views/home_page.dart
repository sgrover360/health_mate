import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_mate/models/chat_data.dart';
import 'package:health_mate/views/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final ChatUser user;
  HomePage({
    super.key,
    required this.user,
  });
  // User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Currently, we have a functioning app bar"),
            SizedBox(
              height: 20,
            ),
            Text("The body needs to be implemented with Aesthetic UI"),
          ],
        ),
      ),
    );
  }
}
