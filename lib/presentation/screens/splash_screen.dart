import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

import 'package:pluto_ui/business_logic/login_cubit/cubit/login_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _planetScale;
  late Animation<double> _planetGlow;
  late Animation<double> _textFade;
  late Animation<double> _textBlur;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _planetScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _planetGlow = Tween<double>(begin: 20.0, end: 60.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.9, curve: Curves.easeIn),
      ),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
          ),
        );

    _textBlur = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 4500), () async {
      if (mounted) {
        bool loggedIn = await context.read<LoginCubit>().isUserLoggedIn();

        if (loggedIn) {
          Navigator.pushReplacementNamed(context, '/app_router');
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark
        ? theme.scaffoldBackgroundColor
        : const Color(0xFF0F172A);
    final primaryColor = theme.primaryColor;
    final textColor = isDark ? Colors.white : Colors.white;
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: StarPainter(isDark: isDark)),
          ),
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _planetScale.value,
                      child: Container(
                        width: 180,
                        height: 180,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: _planetGlow.value,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CustomPaint(
                          size: const Size(180, 180),
                          painter: PlutoPlanetPainter(
                            color: primaryColor,
                            isDark: isDark,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textFade.value,
                      child: SlideTransition(
                        position: _textSlide,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: _textBlur.value,
                            sigmaY: _textBlur.value,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "WELCOME TO",
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 6,
                                  color: textColor.withOpacity(0.6),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "PLUTO",
                                style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w900,
                                  color: textColor,
                                  letterSpacing: 12,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Container(
                                width: 50,
                                height: 1.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      primaryColor,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlutoPlanetPainter extends CustomPainter {
  final Color color;
  final bool isDark;
  PlutoPlanetPainter({required this.color, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    final haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [color.withOpacity(0.2), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.5));

    canvas.drawCircle(center, radius * 1.5, haloPaint);

    final planetPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          color.withOpacity(1.0),
          color.withOpacity(0.7),
          isDark ? Colors.black : const Color(0xFF1E293B),
        ],
        stops: const [0.1, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, planetPaint);

    final detailPaint = Paint()
      ..color = Colors.white.withOpacity(isDark ? 0.05 : 0.1);
    canvas.drawCircle(
      Offset(center.dx - radius * 0.4, center.dy - radius * 0.2),
      radius * 0.15,
      detailPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy + radius * 0.4),
      radius * 0.25,
      detailPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class StarPainter extends CustomPainter {
  final bool isDark;
  StarPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(isDark ? 0.3 : 0.5);
    final points = [
      Offset(size.width * 0.15, size.height * 0.15),
      Offset(size.width * 0.85, size.height * 0.25),
      Offset(size.width * 0.5, size.height * 0.05),
      Offset(size.width * 0.1, size.height * 0.75),
      Offset(size.width * 0.9, size.height * 0.85),
      Offset(size.width * 0.4, size.height * 0.95),
      Offset(size.width * 0.7, size.height * 0.55),
    ];
    for (var p in points) {
      canvas.drawCircle(p, isDark ? 1.0 : 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
