import 'package:flutter/material.dart';
import 'package:health_mate/pages/chat_overview/chat_overview_page.dart';
import 'package:health_mate/views/theme_provider.dart';
import 'package:provider/provider.dart';

import '../models/chat_user.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  final ChatUser user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfilePage()),// change
              );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action for the chat button here
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChatOverviewPage(user)));
        },
        tooltip: 'Chat',
        child: const Icon(Icons.chat),
      ),
    );
  }
}