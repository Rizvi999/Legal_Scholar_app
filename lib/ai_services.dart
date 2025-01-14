import 'dart:async';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;


class LegalSearchResult {
  final String title;
  final String snippet;
  final String link;
  final DateTime date;

  LegalSearchResult({
    required this.title,
    required this.snippet,
    required this.link,
    required this.date,
  });
}

class IndianLegalSearchAssistant {
  final String geminiApiKey;
  final String searchApiKey;
  final String searchEngineId;
  late GenerativeModel model;

  IndianLegalSearchAssistant({
    required this.geminiApiKey,
    required this.searchApiKey,
    required this.searchEngineId,
  }) {
    model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        maxOutputTokens: 1500,
        temperature: 0.2,
        topP: 0.9,
      ),
    );
  }

  Future<List<LegalSearchResult>> performLegalSearch(String query) async {
    try {
      final enhancedQuery =
          '$query site:indiankanoon.org OR site:sci.gov.in OR site:indiacode.nic.in OR site:lawmin.gov.in';

      final url = Uri.parse(
          'https://www.googleapis.com/customsearch/v1?key=$searchApiKey'
          '&cx=$searchEngineId'
          '&q=${Uri.encodeComponent(enhancedQuery)}'
          '&sort=date'
          '&num=10');

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Search failed with status: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      if (data['items'] != null) {
        final items = data['items'] as List<dynamic>;
        return items
            .map((item) => LegalSearchResult(
                  title: item['title'] as String? ?? 'No Title',
                  snippet: item['snippet'] as String? ?? 'No Snippet',
                  link: item['link'] as String? ?? 'No Link',
                  date: DateTime.now(),
                ))
            .toList();
      } else {
        throw Exception('No items found in response');
      }
    } catch (e) {
      print('Search error: $e');
      return [];
    }
  }

  Future<String> analyzeLegalInformation(
      String query, List<LegalSearchResult> searchResults) async {
    final contextBuilder = StringBuffer();

    contextBuilder.writeln(
        'Based on the following legal sources and recent cases about: "$query"\n');

    for (final result in searchResults) {
      contextBuilder.writeln('Source: ${result.title}');
      contextBuilder.writeln('Context: ${result.snippet}\n');
    }

    contextBuilder.writeln('''
Please provide a comprehensive legal analysis following this structure:

1. CASE CLASSIFICATION
- Nature of Case (Civil/Criminal):
- Jurisdiction:
- Relevant Legal Domain:

2. APPLICABLE LAWS
- Key Sections and Acts:
- Relevant Case Laws:
- Recent Amendments:
- Limitation Period:

3. LEGAL PROCEDURE
- Filing Process:
- Required Documents:
- Expected Timeline:
- Estimated Costs:

4. IMMEDIATE ACTIONS
- First Steps:
- Documentation Needed:
- Important Precautions:
- Common Mistakes to Avoid:

5. REMEDIES & ALTERNATIVES
- Available Legal Options:
- Alternative Resolution Methods:
- Preventive Measures:

Use specific sections, case laws, and recent judgments from the provided sources.
''');

    try {
      final response = await model
          .generateContent([Content.text(contextBuilder.toString())]);
      return formatLegalResponse(
          response.text ?? "Unable to generate response", query);
    } catch (e) {
      return "Error analyzing legal information: $e";
    }
  }

  String formatLegalResponse(String analysis, String query) {
    return '''
🔖 LEGAL ANALYSIS REPORT
═══════════════════════
Query: $query

$analysis

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DISCLAIMER: This analysis is based on available legal information and 
should not be considered as legal advice. Please consult with a qualified 
legal professional for advice specific to your situation.

The information provided is based on Indian law and may not account for 
very recent changes. Always verify the current legal position with a 
practicing advocate.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''';
  }

  Future<String> processLegalQuery(String query) async {
    try {
      print('Searching for legal information: $query');

      final searchResults = await performLegalSearch(query);

      if (searchResults.isEmpty) {
        return '''
NO RELEVANT LEGAL INFORMATION FOUND
══════════════════════════════════
Unable to find specific legal information for your query. 
Please try rephrasing your question or consult a legal professional.
''';
      }

      print('Analyzing legal information...');
      return await analyzeLegalInformation(query, searchResults);
    } catch (e) {
      return '''
ERROR PROCESSING QUERY
═══════════════════════
An error occurred while processing your legal query: $e

Please try again or rephrase your query.
''';
    }
  }

  Future<String> fetchSummary(String inputText) async {
    if (inputText.isEmpty) {
      return "Input text is empty.";
    }

    try {
      final response = await model.generateContent([Content.text(inputText)]);
      return response.text ?? "Unable to generate summary.";
    } catch (e) {
      print('Summary error: $e');
      return "Error generating summary: $e";
    }
  }
}
