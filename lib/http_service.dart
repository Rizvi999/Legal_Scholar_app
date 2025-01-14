import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  final String apiKey = ''; // Replace with your actual API key
  final String searchEngineId = ''; // Replace with your search engine ID

  Future<List<dynamic>> fetchLawArticles(String query) async {
    final String url =
        'https://www.googleapis.com/customsearch/v1?q=$query&key=$apiKey&cx=$searchEngineId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['items'] ?? []; // Return the list of items or an empty list
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
