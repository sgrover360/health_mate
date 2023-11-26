import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:health_mate/pages/login/auth_gate.dart';

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
        MaterialPageRoute(builder: (context) => const AuthGate()),
      );
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2).animate(curve);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color of the page
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset('assets/logo.png'),
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
                waveColor: Colors.blueAccent,
                boxBackgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
                boxHeight: 70.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
