import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  String? authError;
  try {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
  } catch (e) {
    authError = '$e';
  }
  runApp(BoletosApp(authError: authError));
}

class BoletosApp extends StatelessWidget {
  const BoletosApp({super.key, this.authError});

  final String? authError;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0E7C86),
      tertiary: const Color(0xFFE09F3E),
    );
    return MaterialApp(
      title: 'Boletos de eventos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF2F5F7),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: authError == null
          ? const HomeScreen()
          : _AuthErrorScreen(message: authError!),
    );
  }
}

class _AuthErrorScreen extends StatelessWidget {
  const _AuthErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No se pudo iniciar sesión anónima.\n'
            'Habilita Authentication → Sign-in method → Anonymous en Firebase.\n\n'
            '$message',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
