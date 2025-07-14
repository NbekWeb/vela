import 'package:flutter/material.dart';
import '../vault/vault_ritual_card.dart';
import 'package:video_player/video_player.dart';
import '../../shared/widgets/custom_star.dart';
import '../dashboard/my_meditations_page.dart';
import '../dashboard/archive_page.dart'; // <-- add this import

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key});

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    try {
      _controller = VideoPlayerController.asset('assets/videos/starter.mp4');

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });

        _controller!
          ..setLooping(true)
          ..setVolume(0)
          ..play();
      }
    } catch (e) {
      debugPrint('Video controller initialization error: $e');
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3D8F7),
      body: Stack(
        children: [
          // Video background or fallback
          if (_isInitialized && _controller != null && !_hasError)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              ),
            )
          else
            // Fallback background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFB3D8F7),
                    Color(0xFF8BC6F7),
                    Color(0xFF5AA9F7),
                  ],
                ),
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                // Fixed header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4, 16.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Info icon in a circle, size 24x24
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: const Center(
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      Image.asset('assets/img/logo.png', width: 60, height: 39),
                      // Avatar on the right, size 30x30
                      ClipOval(
                        child: Image.asset(
                          'assets/img/card.png', // Placeholder, replace with your avatar asset if needed
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 240),
                          Center(
                            child: Text(
                              'Daily Streaks',
                              style: TextStyle(
                                fontFamily: 'Canela',
                                fontSize: 36,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              'You\'ve shown up 3 days in a row',
                              style: TextStyle(
                                color: const Color(0xFFDCE6F0),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              7,
                              (index) => CustomStar(
                                isFilled: index < 3,
                                title: [
                                  'M',
                                  'T',
                                  'W',
                                  'T',
                                  'F',
                                  'S',
                                  'S',
                                ][index],
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My meditations',
                                style: TextStyle(
                                  fontFamily: 'Canela',
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MyMeditationsPage(),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFFDCE6F0),
                                  size: 36,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          VaultRitualCard(
                            image: 'assets/img/card.png',
                            title: 'Sleep Stream Meditation',
                            subtitle:
                                'A deeply personalized journey crafted from your unique vision and dreams',
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3B6EAA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Generate New Meditation',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/img/star.png',
                                    width: 28,
                                    height: 28,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'The Archive',
                                style: TextStyle(
                                  fontFamily: 'Canela',
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ArchivePage(),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFFDCE6F0),
                                  size: 36,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          VaultRitualCard(
                            image: 'assets/img/card.png',
                            title: 'Morning Meditation',
                            subtitle:
                                'Start your day with positive energy and clarity',
                          ),
                          const SizedBox(height: 16),
                          VaultRitualCard(
                            image: 'assets/img/card.png',
                            title: 'Evening Reflection',
                            subtitle: 'Wind down and reflect on your day',
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
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
