import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubService {
  static const String url =
      "https://raw.githubusercontent.com/amirukhan08509-bot/sarkari-schemes/main/schemes.json";

  static Future<List<dynamic>> getSchemes() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      throw Exception("GitHub Error ${response.statusCode}");
    } catch (e) {
      throw Exception("Internet Connection Error");
    }
  }
}