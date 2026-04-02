import 'package:flutter/material.dart';

class QuickTips extends StatefulWidget {
  @override
  QuickTipsState createState() => QuickTipsState();
}

class QuickTipsState extends State<QuickTips> {

  Widget _sectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111318),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: child,
    );
  }

  Widget _tipItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D24),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D10),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// BACK BUTTON
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1A1D24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// HEADER
                  const Text(
                    "Interview Quick Tips",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Professional guidance to help you perform confidently and effectively.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// HIGHLIGHT BANNER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF2563EB),
                          Color(0xFF1E40AF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "Preparation + Clarity + Confidence = Interview Success",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// PREPARATION SECTION
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Preparation",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _tipItem(
                          Icons.book_outlined,
                          "Research the Role",
                          "Understand job responsibilities and align your skills accordingly.",
                        ),
                        _tipItem(
                          Icons.business_center_outlined,
                          "Know the Company",
                          "Study the company’s products, culture, and recent achievements.",
                        ),
                        _tipItem(
                          Icons.list_alt_outlined,
                          "Prepare Structured Answers",
                          "Use the STAR method (Situation, Task, Action, Result).",
                        ),
                      ],
                    ),
                  ),

                  /// COMMUNICATION SECTION
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Communication",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _tipItem(
                          Icons.record_voice_over_outlined,
                          "Speak Clearly",
                          "Maintain steady pace and articulate your thoughts confidently.",
                        ),
                        _tipItem(
                          Icons.remove_red_eye_outlined,
                          "Maintain Eye Contact",
                          "Shows confidence and engagement during the conversation.",
                        ),
                        _tipItem(
                          Icons.self_improvement_outlined,
                          "Control Body Language",
                          "Sit upright and avoid distracting gestures.",
                        ),
                      ],
                    ),
                  ),

                  /// TECHNICAL SECTION
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Technical Interviews",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _tipItem(
                          Icons.code_outlined,
                          "Think Out Loud",
                          "Explain your logic while solving problems.",
                        ),
                        _tipItem(
                          Icons.bug_report_outlined,
                          "Handle Mistakes Calmly",
                          "Correct errors confidently without panic.",
                        ),
                        _tipItem(
                          Icons.timer_outlined,
                          "Manage Time Wisely",
                          "Balance explanation and solution speed.",
                        ),
                      ],
                    ),
                  ),

                  /// BEHAVIORAL SECTION
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Behavioral Interviews",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _tipItem(
                          Icons.psychology_outlined,
                          "Show Problem-Solving Skills",
                          "Demonstrate analytical thinking in real scenarios.",
                        ),
                        _tipItem(
                          Icons.group_outlined,
                          "Highlight Teamwork",
                          "Emphasize collaboration and leadership examples.",
                        ),
                        _tipItem(
                          Icons.flag_outlined,
                          "Be Honest",
                          "Authenticity builds trust and credibility.",
                        ),
                      ],
                    ),
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
