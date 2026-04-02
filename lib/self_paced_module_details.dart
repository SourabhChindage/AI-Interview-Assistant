import 'package:flutter/material.dart';
import 'dart:ui';

class SelfPacedModuleDetails extends StatefulWidget {
  final String subject;
  final List<Map<String, String>> questions;

  const SelfPacedModuleDetails({
    super.key,
    required this.subject,
    required this.questions,
  });

  @override
  _SelfPacedModuleDetailsState createState() => _SelfPacedModuleDetailsState();
}

class _SelfPacedModuleDetailsState extends State<SelfPacedModuleDetails> {
  late final Map<int, TextEditingController> _controllers;
  late final Map<int, bool> _showAnswers;
  late final Map<int, double> _scores;
  late final Map<int, bool> _showScores;
  int _currentIndex = 0;
  bool _isNext = true;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    _showAnswers = {};
    _scores = {};
    _showScores = {};
    for (int i = 0; i < widget.questions.length; i++) {
      _controllers[i] = TextEditingController();
      _showAnswers[i] = false;
      _scores[i] = 0.0;
      _showScores[i] = false;
    }
  }

  double _compareAnswers(String userAns, String actualAns) {
    if (userAns.trim().isEmpty) return 0.0;
    final userWords = userAns.toLowerCase().split(RegExp(r'\s+'));
    final actualWords = actualAns.toLowerCase().split(RegExp(r'\s+'));
    int matched = 0;
    for (var word in userWords) {
      if (actualWords.contains(word)) matched++;
    }
    return (matched / actualWords.length * 10).clamp(0, 10);
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _isNext = true;
        _currentIndex++;
      });
    }
  }

  void _prevQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _isNext = false;
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.questions[_currentIndex];
    final questionText = item["q"] ?? "";
    final answerText = item["a"] ?? "";
    final totalQuestions = widget.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F2F),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Stack(
              children: [
                ClipPath(
                  clipper: DeepWaveClipper2(),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0C1F2F), Color(0xFF0C3C56)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black45.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 160,
                  child: Center(
                    child: Text(
                      widget.subject,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / totalQuestions,
                color: Colors.cyanAccent,
                backgroundColor: Colors.white.withOpacity(0.2),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 16),
            // Scrollable Question Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      final offsetAnim = Tween<Offset>(
                        begin: Offset(_isNext ? 1 : -1, 0),
                        end: Offset.zero,
                      ).animate(animation);
                      return SlideTransition(
                        position: offsetAnim,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: Container(
                      key: ValueKey<int>(_currentIndex),
                      padding: const EdgeInsets.all(22),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.02),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.3), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45.withOpacity(0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Q${_currentIndex + 1}: $questionText",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _controllers[_currentIndex],
                            style: const TextStyle(color: Colors.white),
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Type your answer...",
                              hintStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 18),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _showAnswers[_currentIndex] =
                                      !(_showAnswers[_currentIndex] ?? false);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyanAccent.withOpacity(0.85),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: Text(
                                    _showAnswers[_currentIndex]! ? "Hide Answer" : "View Answer",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final userAns =
                                        _controllers[_currentIndex]?.text ?? "";
                                    final score =
                                    _compareAnswers(userAns, answerText);
                                    setState(() {
                                      _scores[_currentIndex] = score;
                                      _showScores[_currentIndex] = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyanAccent.withOpacity(0.65),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: const Text(
                                    "Compare",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_showAnswers[_currentIndex] ?? false)
                            Container(
                              margin: const EdgeInsets.only(top: 18),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyanAccent.withOpacity(0.2),
                                    Colors.cyanAccent.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.cyanAccent.withOpacity(0.7),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Text(
                                "Answer: $answerText",
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                            ),
                          if (_showScores[_currentIndex] ?? false)
                            Container(
                              margin: const EdgeInsets.only(top: 14),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 18),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.greenAccent.withOpacity(0.85),
                                    Colors.greenAccent.withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Text(
                                "Score: ${(_scores[_currentIndex] ?? 0).toStringAsFixed(1)}/10",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _prevQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Colors.cyanAccent, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                    child: const Text(
                      "Previous",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Wave clipper
class DeepWaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();
    p.lineTo(0, size.height - 40);
    p.quadraticBezierTo(size.width * 0.25, size.height,
        size.width * 0.5, size.height - 20);
    p.quadraticBezierTo(size.width * 0.75, size.height - 40,
        size.width, size.height - 10);
    p.lineTo(size.width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
