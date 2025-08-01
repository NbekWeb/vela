import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/widgets/stars_animation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/stores/auth_store.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  final _secureStorage = const FlutterSecureStorage();
  late AnimationController _circleController;
  late Animation<double> _circleScale;
  int _count = 1;
  bool _isIn = true;

  @override
  void initState() {
    super.initState();
    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _circleScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _circleController, curve: Curves.easeInOut),
    );
    _startBreathing();
  }

  Future<void> _startBreathing() async {
    // Check if user is authenticated first
    final authStore = Provider.of<AuthStore>(context, listen: false);
    final isAuthenticated = await authStore.isAuthenticated();
    
    if (isAuthenticated) {
      // User is authenticated, go directly to dashboard
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/dashboard');
      return;
    }
    
    // User is not authenticated, show breathing animation
    // Breathe In: circle grows from 0 to max and stays
    setState(() {
      _isIn = true;
      _count = 1;
    });
    _circleController.reset();
    _circleController.forward();
    for (int i = 1; i <= 5; i++) {
      setState(() => _count = i);
      await Future.delayed(const Duration(seconds: 1));
    }
    // Breathe Out: circle shrinks from max to 0
    setState(() {
      _isIn = false;
      _count = 1;
    });
    _circleController.reverse(from: 1.0);
    for (int i = 1; i <= 5; i++) {
      setState(() => _count = i);
      await Future.delayed(const Duration(seconds: 1));
    }
    // If we reach here, it means user is not authenticated
    // Navigate to starter page
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/onboarding-1');
  }

  @override
  void dispose() {
    _circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const StarsAnimation(),
          Center(
            child: AnimatedBuilder(
              animation: _circleController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.1,
                      child: Transform.scale(
                        scale: _circleScale.value,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isIn ? 'Breathe In' : 'Breathe Out',
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontFamily: 'Canela',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$_count',
                          style: TextStyle(
                            fontSize: 138,
                            color: Colors.white.withAlpha((0.3 * 255).toInt()),
                            fontFamily: 'Canela',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
