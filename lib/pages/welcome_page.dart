import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/primary_button.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, this.firebaseReady = true, this.firebaseError});

  final bool firebaseReady;
  final String? firebaseError;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 700;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_car_filled_rounded,
                        color: carShareGreen,
                        size: 28,
                      ),
                      const SizedBox(width: 9),
                      Text(
                        'CarShare',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  SizedBox(height: compact ? 16 : 28),
                  Container(
                    height: compact ? 250 : 330,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF34D399),
                          carShareGreen,
                          Color(0xFF065F46),
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: _RoadPainter()),
                        ),
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .14),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.directions_car_filled_rounded,
                            color: carShareGreen,
                            size: 42,
                          ),
                        ),
                        const Positioned(
                          left: 24,
                          top: 24,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white70,
                            size: 25,
                          ),
                        ),
                        const Positioned(
                          right: 30,
                          bottom: 30,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white70,
                            size: 25,
                          ),
                        ),
                        Positioned(
                          bottom: 22,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              child: Text(
                                'Your next ride starts here',
                                style: TextStyle(
                                  color: carShareGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: compact ? 20 : 28),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Share the ride,\nsplit the road.',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            height: 1.12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.6,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Find people going your way and make every journey a little easier.',
                      style: TextStyle(
                        color: Color(0xFF687780),
                        height: 1.5,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!firebaseReady) ...[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Firebase setup is needed before you can create an account or sign in.',
                        style: TextStyle(color: Color(0xFF795500)),
                      ),
                    ),
                  ],
                  PrimaryButton(
                    label: 'Get Started',
                    onPressed: () =>
                        Navigator.pushNamed(context, SignUpPage.routeName),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, SignInPage.routeName),
                      child: const Text('I already have an account'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * .12, size.height * .77)
      ..cubicTo(
        size.width * .3,
        size.height * .68,
        size.width * .54,
        size.height * .3,
        size.width * .82,
        size.height * .2,
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: .65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    for (final point in [
      Offset(size.width * .12, size.height * .77),
      Offset(size.width * .82, size.height * .2),
    ]) {
      canvas.drawCircle(point, 6, Paint()..color = Colors.white);
      canvas.drawCircle(point, 3, Paint()..color = carShareGreen);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
