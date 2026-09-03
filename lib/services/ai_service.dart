import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String workerUrl =
      "https://green-feather-e63f.amirukhan08509.workers.dev";

  Future<String> getResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse(workerUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "message": message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        final answer = data["answer"];

        if (answer != null && answer.toString().trim().isNotEmpty) {
          return answer.toString().trim();
        }

        return "⚠️ AI से सही उत्तर प्राप्त नहीं हुआ।";
      }

      return "❌ Error: ${response.statusCode}";
    } catch (e) {
      return "⚠️ Error: $e";
    }
  }
}