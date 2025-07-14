import 'package:flutter/material.dart';
import 'package:vela/shared/widgets/stars_animation.dart';

class ZeroGenerator extends StatefulWidget {
  final VoidCallback? onNext;
  const ZeroGenerator({super.key, this.onNext});

  @override
  State<ZeroGenerator> createState() => _ZeroGeneratorState();
}

class _ZeroGeneratorState extends State<ZeroGenerator> {
  @override
  void initState() {
    super.initState();
    if (widget.onNext != null) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) widget.onNext!();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const StarsAnimation(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Take a quiet moment to connect with yourself',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Canela',
                      fontWeight: FontWeight.w300,
                      fontSize: 36,
                      height: 1.15,
                      letterSpacing: -0.9,
                      color: Color(0xFFF2EFEA),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'These questions activate the parts of your brain responsible for vision, clarity, and motivation.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      height: 1.5,
                      color: Color(0xFFF2EFEA),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    "You're about to build a blueprint for your dream life.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      height: 1.5,
                      color: Color(0xFFF2EFEA),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 