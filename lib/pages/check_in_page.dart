import 'package:flutter/material.dart';
import '../shared/widgets/stars_animation.dart';
import '../shared/widgets/full_width_track_shape.dart';
import 'dashboard/main.dart';

class DailyCheckInPage extends StatelessWidget {
  const DailyCheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const StarsAnimation(starCount: 50),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                _CheckInAppBar(),
                SizedBox(height: 16),
                Expanded(child: _CheckInForm()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckInAppBar extends StatelessWidget {
  const _CheckInAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Image.asset(
            'assets/img/logo.png',
            height: 32,
            color: Colors.white,
          ),
          Icon(Icons.info_outline, color: Colors.white, size: 24),
        ],
      ),
    );
  }
}

class _CheckInForm extends StatelessWidget {
  const _CheckInForm();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Canela',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formattedDate(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // O'rtadagi emoji o'rniga planet.png rasmidan foydalanamiz
                  Image.asset(
                    'assets/img/planet.png',
                    width: 66,
                    height: 66,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Neutral',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Slider
                  SizedBox(
                    width: double.infinity,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 8,
                        activeTrackColor: Color(0xFFC9DFF4),
                        inactiveTrackColor: Color(0xFFC9DFF4),
                        thumbColor: Color(0xFF3B6EAA),
                        overlayColor: Colors.white24,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7.5),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                        trackShape: const FullWidthTrackShape(),
                      ),
                      child: Slider(
                        value: 0.5,
                        onChanged: (v) {},
                        min: 0,
                        max: 1,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: Text(
                          'Struggling',
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Neutral',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Excellent',
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'How can Vela support\nyou in this exact moment?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Canela',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'I’m overwhelmed about my test — I need help calming down.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _CheckInButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formattedDate() {
    final now = DateTime.now();
    return '${_weekday(now.weekday)}, ${now.month}/${now.day}/${now.year}';
  }

  static String _weekday(int weekday) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return days[weekday - 1];
  }
}

class _CheckInButtons extends StatelessWidget {
  const _CheckInButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const DashboardMainPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B6EAA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: const Text(
              'Complete Check-In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const DashboardMainPage()),
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Generate New Meditation',
                  style: TextStyle(
                    color: Color(0xFF3B6EAA),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.auto_awesome, color: Color(0xFF3B6EAA)),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 