import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../theme.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.user});

  final User user;
  final FirebaseService _service = FirebaseService();

  Future<void> _signOut(BuildContext context) async {
    try {
      await _service.signOut();
      if (context.mounted) {
        Navigator.of(context).pushNamed('/sign-in');
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(authErrorMessage(error))));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'CarShare',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      actions: [
        IconButton(
          tooltip: 'Sign Out',
          onPressed: () => _signOut(context),
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FutureBuilder<Map<String, dynamic>?>(
              future: _service.getProfile(user.uid),
              builder: (context, snapshot) {
                final profile = snapshot.data;
                final name = (profile?['fullName'] as String?)?.trim();
                final roleValue = profile?['role'] as String?;
                final role = roleValue == 'driver'
                    ? 'Driver'
                    : roleValue == 'passenger'
                    ? 'Passenger'
                    : 'Member';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.waving_hand_rounded,
                        color: carShareGreen,
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome${name == null || name.isEmpty ? '' : ','}',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    if (name != null && name.isNotEmpty)
                      Text(
                        name,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: carShareGreen,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    const SizedBox(height: 12),
                    const Text(
                      'You’re all set for your next journey.',
                      style: TextStyle(color: Color(0xFF718096)),
                    ),
                    const SizedBox(height: 24),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const LinearProgressIndicator(),
                    if (snapshot.hasError)
                      const Text(
                        'Your profile could not be loaded. Check your connection and Firestore rules.',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    if (roleValue != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 28),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          role,
                          style: const TextStyle(
                            color: carShareGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _signOut(context),
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Sign Out'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}
