import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:interview_assistant/sliders_screen.dart';
import 'main.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<splash_screen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // FADE animation
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    // SCALE animation
    _scaleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();

    // NAVIGATION
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
            slider_screen()),
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ---------------- Glassmorphism Circle ----------------
                  ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: Colors.white24, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.tealAccent.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.smart_toy,
                          size: 70,
                          color: Colors.tealAccent,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ---------------- Shimmer-like Gradient Title ----------------
                  Text("Interview Assistant",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 30),),

                  const SizedBox(height: 12),

                  const Text(
                    "Practice, Improve & Shine with AI",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ---------------- Line Loader ----------------
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 3),
                    builder: (context, value, child) {
                      return Container(
                        width: 140 * value,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const LinearGradient(
                            colors: [
                              Colors.tealAccent,
                              Colors.white,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
