import 'dart:async';
import 'package:flutter/material.dart';
import 'package:interview_assistant/main.dart';


class slider_screen extends StatefulWidget {
  @override
  SliderScreenState createState() => SliderScreenState();
}

class SliderScreenState extends State<slider_screen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<Map<String, String>> _slides = [
    {
      "image": "assets/images/image3.jpg",
      "title": "AI-Based Interview Practice",
      "description":
      "Sharpen your communication skills with intelligent AI-driven interview simulations."
    },
    {
      "image": "assets/images/image2.jpg",
      "title": "Real-Time Feedback",
      "description":
      "Receive instant, personalized feedback to improve confidence, tone, clarity, and delivery."
    },
    {
      "image": "assets/images/image5.jpg",
      "title": "Skill-Based Question Sets",
      "description":
      "Access curated technical and HR interview questions tailored to your job role."
    },
    {
      "image": "assets/images/image4.jpg",
      "title": "Prepare Like a Pro",
      "description":
      "Track your progress, enhance weak areas, and get ready for your next interview."
    },
  ];


  @override
  void initState() {
    super.initState();
    // Auto-slide every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _slides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // PageView Slider
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Added top space for image
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0), // 👈 top space added
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          _slides[index]['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(
                          _slides[index]['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Text(
                            _slides[index]['description']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          ),

          // Smooth Page Indicator
          Positioned(
            bottom: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  height: 10,
                  width: _currentPage == index ? 25 : 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.cyanAccent
                        : Colors.white30,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
          ),

          // LOGIN and REGISTER Buttons
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(title: "Interview Assistant")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.cyanAccent, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 12),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),


                // Register Button

              ],
            ),
          ),
        ],
      ),
    );
  }
}
