import 'package:flutter/material.dart';

import 'models/user_profile.dart';
import 'pages/home_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/welcome_page.dart';
import 'services/auth_service.dart';
import 'theme.dart';

class CarShareApp extends StatelessWidget {
  const CarShareApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CarShare',
    debugShowCheckedModeBanner: false,
    theme: carShareTheme,
    home: const _AuthenticationGate(),
    routes: {
      SignInPage.routeName: (_) => const SignInPage(),
      SignUpPage.routeName: (_) => const SignUpPage(),
    },
  );
}

class _AuthenticationGate extends StatelessWidget {
  const _AuthenticationGate();

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<UserProfile?>(
    valueListenable: AuthService.instance.currentUser,
    builder: (context, user, _) => user == null
        ? const WelcomePage()
        : HomePage(user: user),
  );
}
