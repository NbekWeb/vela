import 'package:flutter/material.dart';

class VaultIcon extends StatelessWidget {
  final double size;
  final bool filled;
  final double opacity;
  const VaultIcon({this.size = 30, this.filled = false, this.opacity = 1.0, super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Image.asset(
        filled ? 'assets/img/vault_fill.png' : 'assets/img/vault.png',
        width: size,
        height: size,
      ),
    );
  }
} 