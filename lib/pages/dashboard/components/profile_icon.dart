import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  final double size;
  final bool filled;
  final double opacity;
  const ProfileIcon({this.size = 30, this.filled = false, this.opacity = 1.0, super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Image.asset(
        filled ? 'assets/img/profile_fill.png' : 'assets/img/profile.png',
        width: size,
        height: size,
      ),
    );
  }
} 