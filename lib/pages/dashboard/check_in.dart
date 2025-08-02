import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../shared/widgets/full_width_track_shape.dart';
import '../../core/stores/check_in_store.dart';
import '../generator/generator_page.dart';

class DashboardCheckInPage extends StatefulWidget {
  const DashboardCheckInPage({super.key});

  @override
  State<DashboardCheckInPage> createState() => _DashboardCheckInPageState();
}

class _DashboardCheckInPageState extends State<DashboardCheckInPage> {
  double _sliderValue = 0.5;
  final TextEditingController _descriptionController = TextEditingController();

  String _getMoodText(double value) {
    if (value <= 0.30) {
      return 'Struggling';
    } else if (value <= 0.70) {
      return 'Neutral';
    } else {
      return 'Excellent';
    }
  }

  String _getCheckInChoice(double value) {
    if (value <= 0.30) {
      return 'struggling';
    } else if (value <= 0.70) {
      return 'neutral';
    } else {
      return 'excellent';
    }
  }

  String _getMoodImage(double value) {
    if (value <= 0.45) {
      return 'assets/img/struggling.png';
    } else if (value <= 0.54) {
      return 'assets/img/planet.png';
    } else {
      return 'assets/img/excellent.png';
    }
  }

  void _handleCheckIn(BuildContext context, CheckInStore checkInStore) {
    final checkInChoice = _getCheckInChoice(_sliderValue);
    final description = _descriptionController.text.trim();
    
    if (description.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter a description',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    checkInStore.submitCheckIn(
      checkInChoice: checkInChoice,
      description: description,
      onSuccess: () {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      },
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

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

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
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(
                              context,
                            ).pushReplacementNamed('/dashboard'),
                          ),
                          Image.asset(
                            'assets/img/logo.png',
                            width: 60,
                            height: 39,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
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
                        fontWeight: FontWeight.w300,
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
                            Text(
                              _formattedDate(),
                              style: const TextStyle(
                                color: Color(0xFFDCE6F0),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Dynamic mood image
                            Image.asset(
                              _getMoodImage(_sliderValue),
                              width: 48,
                              height: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getMoodText(_sliderValue),
                              style: const TextStyle(
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
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 7.5,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 20,
                                  ),
                                  trackShape: const FullWidthTrackShape(),
                                ),
                                child: Slider(
                                  value: _sliderValue,
                                  onChanged: (v) {
                                    setState(() {
                                      _sliderValue = v;
                                    });
                                  },
                                  min: 0,
                                  max: 1,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Struggling',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Neutral',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Excellent',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
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
                            SizedBox(
                              width: double.infinity,
                              height: 100,
                              child: TextFormField(
                                controller: _descriptionController,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'I\'m overwhelmed about my test — I need help calming down.',
                                  hintStyle: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(21, 43, 86, 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(21, 43, 86, 0.3),
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                  fillColor: Color.fromRGBO(21, 43, 86, 0.1),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Complete Check-In Button
                            Consumer<CheckInStore>(
                              builder: (context, checkInStore, child) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: checkInStore.isLoading ? null : () {
                                      _handleCheckIn(context, checkInStore);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF3B6EAA),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                    ),
                                    child: checkInStore.isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'Complete Check-In',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            // Generate New Meditation Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => const GeneratorPage()),
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
