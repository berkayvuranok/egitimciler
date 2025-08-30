import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'view_model/splash_view_model.dart';
import 'view_model/splash_event.dart';
import 'view_model/splash_state.dart';

class ViewSplash extends StatefulWidget {
  const ViewSplash({super.key});

  @override
  State<ViewSplash> createState() => _ViewSplashState();
}

class _ViewSplashState extends State<ViewSplash>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Dönen yazı animasyonu
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Pulse animasyonu
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashViewModel()..add(SplashStarted()),
      child: BlocConsumer<SplashViewModel, SplashState>(
        listener: (context, state) {
          if (state.navigateToOnboarding) {
            Navigator.of(context).pushReplacementNamed('/onboarding');
          } else if (state.navigateToHome) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Dönen yazı
                  RotationTransition(
                    turns: _rotationController,
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter: CircularTextPainter(
                        text: "EĞİTİMCİLER   ",
                        textStyle: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [Colors.blue, Colors.purple],
                            ).createShader(const Rect.fromLTWH(0, 0, 200, 0)),
                        ),
                      ),
                    ),
                  ),
                  // Pulse efektli logo
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/png/splash/splash.png',
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CircularTextPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;

  CircularTextPainter({required this.text, required this.textStyle});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2.2;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final angleStep = 2 * math.pi / text.length;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final angle = -math.pi / 2 + (i * angleStep);
      final offset = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle + math.pi / 2);

      textPainter.text = TextSpan(text: char, style: textStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
