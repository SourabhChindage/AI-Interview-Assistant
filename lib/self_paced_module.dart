// self_paced_module.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'self_paced_module_details.dart';

class self_paced_module extends StatefulWidget {
  @override
  SelfPacedScreenState createState() => SelfPacedScreenState();
}

class SelfPacedScreenState extends State<self_paced_module>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;
  String _search = "";
  String _activeCategory = "All";
  String? _lastSelectedDifficulty;
  double _progressPercent = 0.28;
  final TextEditingController _searchController = TextEditingController();

  late Map<String, List<Map<String, String>>> qaBank = {};

  final Map<String, List<String>> categories = {
    "All": ["Java", "Python", "DBMS", "Flutter", "OS", "Networks", "DSA", "HTML/CSS"],
    "Development": ["Java", "Python", "Flutter", "HTML/CSS"],
    "Core CS": ["DSA", "OS", "Networks", "DBMS"]
  };

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final String jsonString = await rootBundle.loadString('assets/data/questions.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final Map<String, List<Map<String, String>>> tempBank = {};

    jsonMap.forEach((subject, levels) {
      final List<Map<String, String>> subjectQuestions = [];
      (levels as Map<String, dynamic>).forEach((difficulty, questions) {
        for (var q in questions as List<dynamic>) {
          subjectQuestions.add({
            "q": q["q"],
            "a": q["a"],
            "difficulty": difficulty
          });
        }
      });
      tempBank[subject] = subjectQuestions;
    });

    setState(() {
      qaBank = tempBank;
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ----------------- HEADER -----------------
  Widget buildHeader() {
    return ClipPath(
      clipper: DeepWaveClipper(),
      child: Container(
        height: 185,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [
              Color(0xFF0A1F2F),
              Color(0xFF08344D),
              Color(0xFF0F4C75)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.white.withOpacity(0.02)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.cyanAccent.withOpacity(0.9), Colors.blueAccent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Self-Paced Module",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Sharpen interview skills — one subject at a time",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.white.withOpacity(0.06), Colors.white.withOpacity(0.02)],
                              ),
                              border: Border.all(color: Colors.white.withOpacity(0.06)),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${(_progressPercent * 100).round()}%",
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Mastery",
                                style: TextStyle(color: Colors.white70, fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ----------------- STATS ROW -----------------
  Widget buildStatsRow() {
    final totalQuestions = qaBank.values.fold<int>(0, (p, e) => p + e.length);
    final subjectCount = qaBank.keys.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.purpleAccent.withOpacity(0.45),
                  width: 1.6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withOpacity(0.35),
                    blurRadius: 25,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orangeAccent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$totalQuestions+ Questions",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text("Comprehensive practice", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: Colors.purpleAccent.withOpacity(0.45),
                width: 1.6,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(0.35),
                  blurRadius: 25,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.layers, color: Colors.lightBlueAccent),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$subjectCount Subjects", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text("Focused learning", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ----------------- TIPS BANNER -----------------
  Widget buildTipsBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orangeAccent.withOpacity(0.45),
            width: 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orangeAccent.withOpacity(0.35),
              blurRadius: 25,
              spreadRadius: 2,
            )
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.lightbulb, color: Colors.yellowAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Daily Tip", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Practice 20 minutes daily. Focus on explaining out loud.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Coming soon: Detailed tips")));
              },
              child: const Text("Learn More"),
              style: TextButton.styleFrom(foregroundColor: Colors.cyanAccent),
            )
          ],
        ),
      ),
    );
  }

  // ----------------- SEARCH BAR -----------------
  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.black),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search subject...",
                        hintStyle: TextStyle(color: Colors.black),
                        isDense: true,
                      ),
                      onChanged: (v) {
                        setState(() {
                          _search = v.trim();
                        });
                      },
                    ),
                  ),
                  if (_search.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _search = "";
                        });
                      },
                      child: const Icon(Icons.close, color: Colors.white54, size: 18),
                    )
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                _activeCategory = _activeCategory == "All" ? "Development" : "All";
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, color: Colors.black, size: 18),
                  const SizedBox(width: 8),
                  Text(_activeCategory, style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // ----------------- CATEGORY CHIPS -----------------
  Widget buildCategoryChips() {
    final chips = categories.keys.toList();
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 6),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: chips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final name = chips[i];
            final active = name == _activeCategory;
            return GestureDetector(
              onTap: () => setState(() => _activeCategory = name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? Colors.cyanAccent.withOpacity(0.18) : Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: active ? Colors.cyanAccent.withOpacity(0.6) : Colors.transparent),
                ),
                child: Center(
                  child: Text(name, style: TextStyle(color: active ? Colors.white : Colors.white70, fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ----------------- SUBJECT CARD -----------------
  Widget buildSubjectCard(String title, IconData icon) {
    final itemCount = qaBank[title]?.length ?? 0;
    final tagline = _generateTagline(title);
    return GestureDetector(
      onTap: () => _onSubjectTap(title),
      child: Hero(
        tag: "card_$title",
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.45),
              width: 1.6,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Colors.white.withOpacity(0.04), Colors.white.withOpacity(0.02)]),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Icon(icon, size: 22, color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text("$itemCount Q", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(tagline, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  String _generateTagline(String subject) {
    switch (subject) {
      case "Java":
        return "Core & OOPs concepts";
      case "Python":
        return "Scripting & data manipulation";
      case "DBMS":
        return "SQL, normalization & design";
      case "Flutter":
        return "UI, widgets & state management";
      case "OS":
        return "Processes & scheduling";
      case "Networks":
        return "Protocols & architecture";
      case "DSA":
        return "Algorithms & problem solving";
      case "HTML/CSS":
        return "Markup & styling basics";
      default:
        return "Practice & concepts";
    }
  }

  // ----------------- FILTER SUBJECTS -----------------
  List<String> getFilteredSubjects() {
    final allowed = categories[_activeCategory] ?? categories["All"]!;
    final listed = allowed.where((s) => qaBank.containsKey(s)).toList();
    if (_search.isEmpty) return listed;
    final lower = _search.toLowerCase();
    return listed.where((s) => s.toLowerCase().contains(lower)).toList();
  }

  // ----------------- ON SUBJECT TAP -----------------
  void _onSubjectTap(String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return _DifficultySelector(
          subject: title,
          onSelected: (difficulty) {
            setState(() {
              _lastSelectedDifficulty = difficulty;
            });
            Navigator.of(ctx).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Selected $difficulty • Opening $title"),
                duration: const Duration(milliseconds: 900),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.black87,
              ),
            );
            Future.delayed(const Duration(milliseconds: 350), () {
              final filteredQuestions = qaBank[title]!
                  .where((q) => q["difficulty"] == difficulty)
                  .toList();

              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 420),
                  pageBuilder: (context, anim, secAnim) => FadeTransition(
                    opacity: anim,
                    child: SelfPacedModuleDetails(
                      subject: title,
                      questions: filteredQuestions,
                    ),
                  ),
                ),
              );
            });
          },
        );
      },
    );
  }

  // ----------------- BUILD -----------------
  @override
  Widget build(BuildContext context) {
    final filtered = getFilteredSubjects();
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFF081F2F),
                      Color(0xFF0A354A),
                      Color(0xFF0F4C75)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    transform: GradientRotation(_bgController.value * 6.28),
                  ),
                ),
              );
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
              buildStatsRow(),
              buildTipsBanner(),
              buildSearchBar(),
              buildCategoryChips(),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeTop: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.05,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final title = filtered[index];
                        final icon = _iconForSubject(title);
                        return buildSubjectCard(title, icon);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconForSubject(String title) {
    switch (title) {
      case "Java":
        return Icons.code;
      case "Python":
        return Icons.memory;
      case "DBMS":
        return Icons.storage;
      case "Flutter":
        return Icons.phone_android;
      case "OS":
        return Icons.computer;
      case "Networks":
        return Icons.network_check;
      case "DSA":
        return Icons.stacked_line_chart;
      case "HTML/CSS":
        return Icons.web;
      default:
        return Icons.book;
    }
  }
}

// ----------------- DIFFICULTY SELECTOR -----------------
class _DifficultySelector extends StatelessWidget {
  final String subject;
  final void Function(String difficulty) onSelected;

  const _DifficultySelector({Key? key, required this.subject, required this.onSelected}) : super(key: key);

  Widget _option(BuildContext context, String title, String subtitle, IconData icon, Color accent) {
    return GestureDetector(
      onTap: () => onSelected(title),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.03),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [accent.withOpacity(0.15), accent.withOpacity(0.06)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.46,
      minChildSize: 0.28,
      maxChildSize: 0.9,
      builder: (context, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF061625),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollCtrl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Select Difficulty", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(subject, style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white54),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                _option(context, "Beginner", "Basic concepts & definitions", Icons.emoji_people, Colors.greenAccent),
                _option(context, "Intermediate", "Application & short problems", Icons.timeline, Colors.cyanAccent),
                _option(context, "Advanced", "Complex questions & design", Icons.whatshot, Colors.deepOrangeAccent),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text("Tip: You can change difficulty anytime from the practice screen.", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                ),
                const SizedBox(height: 26),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ----------------- CLIPPER -----------------
class DeepWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();
    p.lineTo(0, size.height - 40);
    p.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height - 20);
    p.quadraticBezierTo(size.width * 0.75, size.height - 40, size.width, size.height - 10);
    p.lineTo(size.width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
