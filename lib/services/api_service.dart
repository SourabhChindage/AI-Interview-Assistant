import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.43.121:8000";

  // ===============================
  // INTERVIEW (QUESTION OR FEEDBACK)
  // ===============================
  static Future<Map<String, dynamic>> getNextQuestion({
    required String subject,
    required List<Map<String, String>> previousQA,
    String? answer,
    String mode = "question", // NEW
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/interview"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "subject": subject,
        "previous_qa": previousQA,
        "user_answer": answer,
        "mode": mode, // NEW
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load response");
    }
  }
}
