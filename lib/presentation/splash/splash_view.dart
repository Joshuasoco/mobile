import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_viewmodel.dart';
import 'arrow_painter.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {
  late AnimationController _drawController;
  late Animation<double> _drawAnimation;
  late AnimationController _textFadeController;
  late AnimationController _fadeOutController;
  late Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();

    final vm = context.read<SplashViewModel>();
    vm.init();

    // ---- Draw animation ----
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _drawAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _drawController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _drawController.forward();

    // ---- Fade text after the arrow finishes ----
    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _drawController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textFadeController.forward();
      }
    });

    // ---- Fade out entire screen when VM signals done ----
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeOutAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _fadeOutController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeOutController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(context, "/onboarding");
      }
    });

    // ---- Navigate after VM is finished ----
    vm.addListener(() {
      if (vm.state.isDone) {
        _fadeOutController.forward();
      }
    });
  }

  @override
  void dispose() {
    _drawController.dispose();
    _textFadeController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FadeTransition(
        opacity: _fadeOutAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: const [Color(0xFF0B0B0B), Color(0xFF3A3A3A)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: AnimatedBuilder(
                    animation: _drawAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: ArrowPainter(_drawAnimation.value),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                FadeTransition(
                  opacity: _textFadeController,
                  child: Column(
                    children: const [
                 Text(
  "MSME",
  style: TextStyle(
    color: Colors.white,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        color: Color.fromARGB(255, 255, 255, 255), // glow color
        blurRadius: 6,           // how soft the glow is
        offset: Offset(0, 0),
      ),

    ],
  ),
),

                      SizedBox(height: 5),
                      Text(
                        "Pathways",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
