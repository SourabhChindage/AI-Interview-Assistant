import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:interview_assistant/live_module.dart';
import 'package:interview_assistant/quick_tips.dart';
import 'package:interview_assistant/self_paced_module.dart';
import 'package:interview_assistant/watch_interviews.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interview Assistant',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
      home: const splash_screen(),
    );
  }
}

// ---------------------------------------------------
// HOME PAGE
// ---------------------------------------------------

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Futuristic Animated Gradient
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFF020D1A),
                      Color(0xFF061E35),
                      Color(0xFF0A3458),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    transform: GradientRotation(_bgController.value * 6.28),
                  ),
                ),
              );
            },
          ),

          // Glow patches (balanced)
          Positioned(
            top: 100,
            right: -40,
            child: _floatingGlow(160, Colors.blueAccent.withOpacity(0.22)),
          ),
          Positioned(
            bottom: 130,
            left: -30,
            child: _floatingGlow(150, Colors.purpleAccent.withOpacity(0.18)),
          ),

          // Main Scroll View
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProHeader(), // Fixed header

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome,",
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Ace your next interview!!",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Scrollable Pro Cards
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    _buildProCard(
                      title: "Self-Paced Practice",
                      subtitle: "Practice questions anytime",
                      icon: Icons.school_rounded,
                      neon: Colors.cyanAccent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => self_paced_module()));
                      },
                    ),
                    _buildProCard(
                      title: "AI Live Practice",
                      subtitle: "Mock interview with AI",
                      icon: Icons.smart_toy_rounded,
                      neon: Colors.purpleAccent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LiveModule()));
                      },
                    ),
                    _buildProCard(
                      title: "Quick Tips",
                      subtitle: "Crack interviews smartly",
                      icon: Icons.lightbulb_outline_rounded,
                      neon: Colors.orangeAccent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuickTips()));
                      },
                    ),
                    _buildProCard(
                      title: "Watch Interviews",
                      subtitle: "Learn from real examples",
                      icon: Icons.play_circle_fill_rounded,
                      neon: Colors.greenAccent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WatchInterview()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}

// ---------------------------------------------------
// FIXED — FLOATING GLOW
// ---------------------------------------------------

Widget _floatingGlow(double size, Color color) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [
        BoxShadow(
          color: color,
          blurRadius: 95,
          spreadRadius: 60,
        )
      ],
    ),
  );
}

// ---------------------------------------------------
// FIXED & PERFECTLY CENTERED HEADER
// ---------------------------------------------------

// ---------------------------------------------------
// CLEAN + CENTERED + NO OVERLAYS HEADER
// ---------------------------------------------------

Widget buildProHeader() {
  return ClipRRect(
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(40),
      bottomRight: Radius.circular(40),
    ),
    child: Container(
      height: 120,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF04151F),
            Color(0xFF072536),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Stack(
        alignment: Alignment.center,
        children: [

          // SOFT INNER BOTTOM GLOW BUILT INTO HEADER (no overlays)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyanAccent.withOpacity(0.20),
                    Colors.transparent
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // MAIN HEADER TEXT
          Column(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [
              Text(
                "Interview Assistant",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.cyanAccent.withOpacity(0.45),
                      blurRadius: 18,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Your Personal Interview Coach",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


// ---------------------------------------------------
// PREMIUM NEO-GLASS CARD
// ---------------------------------------------------

Widget _buildProCard({
  required String title,
  required String subtitle,
  required IconData icon,
  required Color neon,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 190),
        height: 115,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.10),
              Colors.white.withOpacity(0.03),
            ],
          ),
          border: Border.all(
            color: neon.withOpacity(0.45),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: neon.withOpacity(0.22),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        neon.withOpacity(0.9),
                        neon.withOpacity(0.25),
                        Colors.transparent,
                      ],
                      stops: const [0.1, 0.4, 1],
                    ),
                  ),
                  child: Icon(icon, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 22),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
