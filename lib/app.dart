import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/welcome_page.dart';
import 'theme.dart';

class CarShareApp extends StatelessWidget {
  const CarShareApp({
    super.key,
    required this.firebaseReady,
    this.firebaseError,
  });

  final bool firebaseReady;
  final String? firebaseError;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CarShare',
    debugShowCheckedModeBanner: false,
    theme: carShareTheme,
    home: firebaseReady
        ? const _AuthenticationGate()
        : WelcomePage(firebaseReady: false, firebaseError: firebaseError),
    routes: {
      SignInPage.routeName: (_) => const SignInPage(),
      SignUpPage.routeName: (_) => const SignUpPage(),
    },
  );
}

class _AuthenticationGate extends StatelessWidget {
  const _AuthenticationGate();

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final user = snapshot.data;
      return user == null ? const WelcomePage() : HomePage(user: user);
    },
  );
}
