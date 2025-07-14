import 'package:flutter/material.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../shared/widgets/full_width_track_shape.dart';

class DashboardCheckInPage extends StatelessWidget {
  const DashboardCheckInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const StarsAnimation(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Image.asset('assets/img/logo.png', width: 60, height: 39),
                          IconButton(
                            icon: const Icon(Icons.info_outline, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Title
                    const Text(
                      'Daily Check-In',
                      style: TextStyle(
                        fontFamily: 'Canela',
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Connect with your inner journey today',
                      style: TextStyle(
                        color: Color(0xFFDCE6F0),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'How are you feeling today?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Thursday, June 12, 2025',
                              style: TextStyle(
                                color: Color(0xFFDCE6F0),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Emoji
                            Image.asset(
                              'assets/img/planet.png',
                              width: 48,
                              height: 48,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Neutral',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                                Text('Struggling', style: TextStyle(color: Colors.white, fontSize: 12)),
                                Text('Neutral', style: TextStyle(color: Colors.white, fontSize: 12)),
                                Text('Excellent', style: TextStyle(color: Colors.white, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'How can Vela support you in this exact moment?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.22),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Text(
                                'I’m overwhelmed about my test — I need help calming down.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Complete Check-In Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B6EAA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                            // Generate New Meditation Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

 