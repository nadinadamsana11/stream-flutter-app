import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with keys from your firebase-config.js
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBlhYdJPUZH9RKr7EwVIshBbIfsG-paWTU",
      authDomain: "beyond-reality-ai.firebaseapp.com",
      projectId: "beyond-reality-ai",
      storageBucket: "beyond-reality-ai.firebasestorage.app",
      messagingSenderId: "496490426602",
      appId: "1:496490426602:web:25dde2ee448a2435cca793",
      measurementId: "G-JYEK2P2NVF",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beyond Reality AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0a0a0a), // --bg-dark
        primaryColor: const Color(0xFF00f3ff), // --neon-blue
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00f3ff),
          secondary: Color(0xFFbc13fe), // --neon-purple
          surface: Color(0xFF161616), // --bg-card
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0f0f0f),
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/auth': (context) => const AuthScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}