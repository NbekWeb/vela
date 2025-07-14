import 'package:flutter/material.dart';

class HomeIcon extends StatelessWidget {
  final double size;
  final bool filled;
  final double opacity;
  const HomeIcon({this.size = 30, this.filled = false, this.opacity = 1.0, super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Image.asset(
        filled ? 'assets/img/home_fill.png' : 'assets/img/home.png',
        width: size,
        height: size,
      ),
    );
  }
} 