import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<http.Response> fetchShlokaTranslation(String shloka) async {
    final response = await http.post(
      Uri.parse('https://shlokasaar.onrender.com/summarize_shloka'),
      body: jsonEncode({'shloka': shloka}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load translation');
    }
  }
}
