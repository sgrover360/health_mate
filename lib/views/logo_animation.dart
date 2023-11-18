import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'auth_gate.dart';

class LogoAnimation extends StatefulWidget {
  const LogoAnimation({super.key});

  @override
  createState() => _LogoAnimationState();
}

class _LogoAnimationState extends State<LogoAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // scale animation for the logo
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2).animate(curve);

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: SizedBox(
                  width: 100, // Heart icon size
                  height: 100, // Heart icon size
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: 250.0,
            child: TextLiquidFill(
              text: 'Health Mate',
              loadDuration: const Duration(seconds: 2),
              waveColor: Colors.redAccent.shade400,
              boxBackgroundColor: Colors.red.shade50,
              textStyle: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
              boxHeight: 70.0,
            ),
          )
        ],
      ),
    );
  }
}
