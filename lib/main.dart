import 'package:flutter/material.dart';
import 'package:health_mate/views/logo_animation.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(scaffoldBackgroundColor: Colors.red.shade50),
    home: const Scaffold(
      body: LogoAnimation(),
    ),
  ));
}