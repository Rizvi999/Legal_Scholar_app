import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'ai_services.dart'; // Ensure this file exists and contains the IndianLegalSearchAssistant class

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final IndianLegalSearchAssistant legalSearchAssistant =
      IndianLegalSearchAssistant(
    geminiApiKey: '',//replace with actual api keys.
    searchApiKey: '',
    searchEngineId: '',
  );

  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  final queryController = TextEditingController();

  String response = '';
  bool showResponse = false;
  bool isLoading = false;
  List<QueryResponse> queryHistory = [];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
  }

  Future<void> performSearch(String query) async {
    if (query.isEmpty) return;

    // Remove unwanted symbols from the query
    String cleanedQuery = query.replaceAll(RegExp(r'[*#]'), '');

    setState(() {
      isLoading = true;
      showResponse = false;
    });

    try {
      final result = await legalSearchAssistant.processLegalQuery(cleanedQuery);

      // Clean the response to remove unwanted symbols
      String cleanedResponse = result.replaceAll(RegExp(r'[*#]'), '');

      setState(() {
        response = cleanedResponse;
        showResponse = true;
        queryHistory.insert(
            0, QueryResponse(query: cleanedQuery, response: cleanedResponse));
      });
    } catch (e) {
      setState(() {
        response = 'Error: ${e.toString()}';
        showResponse = true;
      });
    } finally {
      setState(() => isLoading = false);
    }

    queryController.clear();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF1A1A2E),
    body: Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: FuturisticBackgroundPainter(),
          ),
        ),
        SafeArea(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'LEGAL SCHOLAR',
                          textAlign: TextAlign.center, // Center the heading text
                          style: GoogleFonts.spaceMono(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.history, color: Colors.white),
                        onPressed: () {
                          // Add functionality for viewing history if needed
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Space between heading and subheading
                Text(
                  'Ask your legal question',
                  style: GoogleFonts.spaceMono(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 20), // Space between subheading and text field
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlassContainer(
                            child: TextField(
                              controller: queryController,
                              onSubmitted: performSearch,
                              style: GoogleFonts.spaceMono(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Type your query...',
                                hintStyle: GoogleFonts.spaceMono(color: Colors.white54),
                                border: InputBorder.none,
                                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                              ),
                            ),
                          ).animate().slideX(delay: 400.ms),
                          const SizedBox(height: 30),
                          if (isLoading)
                            const LoadingIndicator()
                          else if (showResponse)
                            ResponseCard(response: response)
                          else
                            buildRecentQueries(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget buildRecentQueries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT QUERIES',
          style: GoogleFonts.spaceMono(
            fontSize: 14,
            color: Colors.white54,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 15),
        ...List.generate(
          queryHistory.length < 3 ? queryHistory.length : 3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassContainer(
              child: ListTile(
                title: Text(
                  queryHistory[index].query,
                  style: GoogleFonts.spaceMono(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white54, size: 16),
                onTap: () {
                  setState(() {
                    response = queryHistory[index].response;
                    showResponse = true;
                  });
                },
              ),
            ),
          ),
        ).animate(interval: 100.ms).slideX(),
      ],
    );
  }

  @override
  void dispose() {
    queryController.dispose();
    animationController.dispose();
    super.dispose();
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const GlassContainer({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Analyzing your query...',
            style: GoogleFonts.spaceMono(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

class ResponseCard extends StatelessWidget {
  final String response;

  const ResponseCard({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RESPONSE',
            style: GoogleFonts.spaceMono(
              color: Colors.white54,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            response,
            style: GoogleFonts.spaceMono(
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

class FuturisticBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Add more custom drawing here if needed.
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class QueryResponse {
  final String query;
  final String response;

  QueryResponse({required this.query, required this.response});
}
