import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[800] ?? Colors.blue, // Fallback color if null
                  Colors.blue[200] ?? Colors.blue, // Fallback color if null
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/photos/welcompage photo.jpg',
                  fit: BoxFit.cover,
                  height: 200, // Adjust height as needed
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to Legal Scholar',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your AI-powered legal assistant',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Get Started" button press
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Choose an Option'),
                          content: const Text('Please choose whether you want to sign in or continue as a guest.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushNamed(context, '/sign_in'); // Replace with your sign-in screen route
                              },
                              child: const Text('Sign In'),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Guest Mode'),
                                      content: const Text('As a guest, your history and charts will not be saved. Are you sure you want to continue?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close both dialogs
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close both dialogs
                                            Navigator.pushNamed(context, '/home'); // Replace with your home screen route
                                          },
                                          child: const Text('Continue'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text('Continue as Guest'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}