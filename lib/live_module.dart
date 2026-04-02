import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'services/api_service.dart';

class LiveModule extends StatefulWidget {
  @override
  State<LiveModule> createState() => _LiveModuleState();
}

class _LiveModuleState extends State<LiveModule>
    with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText speech;
  final TextEditingController subjectController = TextEditingController();

  String currentQuestion = "";
  List<Map<String, String>> previousQA = [];
  bool isListening = false;
  bool interviewStarted = false;
  String recognizedText = "";
  bool isSubmitting = false;
  bool isGeneratingFeedback = false;
  String feedbackText = "";
  bool canSubmit = false;


  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _startInterview() async {
    if (subjectController.text.trim().isEmpty) return;

    setState(() {
      interviewStarted = true;
      previousQA.clear();
      recognizedText = "";
      feedbackText = "";
    });

    final result = await ApiService.getNextQuestion(
      subject: subjectController.text.trim(),
      previousQA: [],
    );

    setState(() {
      currentQuestion = result["next_question"] ?? "";
    });

    await _speakQuestion();
  }

  Future<void> _speakQuestion() async {
    if (currentQuestion.isEmpty) return;
    await flutterTts.stop();
    await flutterTts.speak(currentQuestion);
  }

  Future<void> _startListening() async {
    bool available = await speech.initialize();
    if (!available) return;

    setState(() {
      recognizedText = "";
      isListening = true;
      canSubmit = false;
    });

    await speech.listen(
      listenMode: stt.ListenMode.dictation,
      onResult: (result) {
        setState(() {
          recognizedText = result.recognizedWords;
        });
      },
    );
  }

  Future<void> _stopListening() async {
    await speech.stop();
    setState(() {
      isListening = false;
      canSubmit = recognizedText.isNotEmpty; // enable if text exists
    });
  }

  Future<void> _submitAnswer() async {
    if (recognizedText.isEmpty) return;

    setState(() {
      isSubmitting = true;
    });

    final answerToSend = recognizedText;

    final result = await ApiService.getNextQuestion(
      subject: subjectController.text.trim(),
      previousQA: previousQA,
      answer: answerToSend,
      mode: "question",
    );

    setState(() {
      previousQA.add({
        "question": currentQuestion,
        "answer": answerToSend,
      });

      currentQuestion = result["next_question"] ?? "";
      recognizedText = "";
      isSubmitting = false;
    });

    await _speakQuestion();
  }

  Future<void> _generateFeedback() async {
    if (previousQA.isEmpty) return;

    setState(() {
      isGeneratingFeedback = true;
    });

    final result = await ApiService.getNextQuestion(
      subject: subjectController.text.trim(),
      previousQA: previousQA,
      mode: "feedback",
    );

    setState(() {
      feedbackText = result["feedback"] ?? "No feedback generated.";
      isGeneratingFeedback = false;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    speech.stop();
    subjectController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D10),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// BACK BUTTON (SCROLLS NORMALLY)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).maybePop();
                    },
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

                  const Text(
                    "AI Interview Session",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    interviewStarted
                        ? "Interview in progress"
                        : "Start a new mock interview session",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Subject",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: subjectController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "e.g. Flutter, Java, DBMS",
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.4)),
                            filled: true,
                            fillColor: const Color(0xFF1A1D24),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFF2563EB),
                              padding:
                              const EdgeInsets.symmetric(
                                  vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                            ),
                            onPressed:
                            interviewStarted ? null : _startInterview,
                            child: const Text("Start Interview"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (interviewStarted) ...[

                    const SizedBox(height: 20),

                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Question",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70)),
                          const SizedBox(height: 12),
                          Text(
                            currentQuestion.isEmpty
                                ? "Loading..."
                                : currentQuestion,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                height: 1.5),
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: _speakQuestion,
                            icon:
                            const Icon(Icons.volume_up, size: 18),
                            label: const Text("Play Question"),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Your Answer",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// RECORD BUTTON (CENTERED)
                          Center(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isListening
                                    ? Colors.redAccent
                                    : const Color(0xFF16A34A),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14),
                              ),
                              onPressed: isListening
                                  ? _stopListening
                                  : _startListening,
                              icon: Icon(
                                isListening ? Icons.stop : Icons.mic,
                              ),
                              label: Text(
                                isListening ? "Stop Recording" : "Record",
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1D24),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              recognizedText.isEmpty
                                  ? "Your recorded answer will appear here..."
                                  : recognizedText,
                              style: TextStyle(
                                color: recognizedText.isEmpty
                                    ? Colors.white38
                                    : Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          /// SUBMIT BUTTON (CENTERED + GREEN WHEN ENABLED)
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: canSubmit
                                    ? const Color(0xFF16A34A) // green when enabled
                                    : Colors.grey.shade700,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 14),
                              ),
                              onPressed: (!canSubmit || isSubmitting)
                                  ? null
                                  : _submitAnswer,
                              child: isSubmitting
                                  ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text("Submit Answer"),
                            ),
                          ),
                        ],
                      ),
                    ),


                    const SizedBox(height: 20),

                    /// 🔥 FEEDBACK SECTION (ALWAYS AVAILABLE AFTER START)
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text("Interview Feedback",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70)),
                          const SizedBox(height: 16),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFF7C3AED),
                            ),
                            onPressed: isGeneratingFeedback
                                ? null
                                : _generateFeedback,
                            child: isGeneratingFeedback
                                ? const CircularProgressIndicator()
                                : const Text(
                                "Generate Feedback"),
                          ),

                          if (feedbackText.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding:
                              const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                const Color(0xFF1A1D24),
                                borderRadius:
                                BorderRadius.circular(
                                    12),
                              ),
                              child: Text(
                                feedbackText,
                                style: const TextStyle(
                                    color: Colors.white,
                                    height: 1.5),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
