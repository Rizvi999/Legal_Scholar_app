import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:legal_scholar_app/welcomepage.dart';
import 'firebase_options.dart'; // Ensure this is present for Firebase initialization
import 'sign_in_screen.dart'; // Import your SignInScreen
import 'registration_screen.dart'; // Import your RegistrationScreen
import 'home_screen.dart'; // Import your HomeScreen


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Legal Scholar App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
       initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/sign_in': (context) => const SignInScreen(),
        '/register': (context) => RegistrationScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
