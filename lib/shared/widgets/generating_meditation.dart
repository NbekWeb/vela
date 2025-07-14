import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'stars_animation.dart';
import '../../pages/sleep_stream_meditation_page.dart';

class GeneratingMeditation extends StatefulWidget {
  final String title;
  final String subtitle;
  final String videoAsset;
  final double bottomPadding;

  const GeneratingMeditation({
    super.key,
    this.title = 'Generating meditation',
    this.subtitle = 'We\'re shaping your vision\ninto a meditative journey...',
    this.videoAsset = 'assets/videos/moon.mp4',
    this.bottomPadding = 80,
  });

  @override
  State<GeneratingMeditation> createState() => _GeneratingMeditationState();
}

class _GeneratingMeditationState extends State<GeneratingMeditation> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoAsset);
      
      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        
        _controller!
          ..setLooping(false)
          ..setVolume(0)
          ..play();
        
        // 1 sekunddan keyin video ni to'liq to'xtat va SleepStreamMeditationPage ga o'tish
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SleepStreamMeditationPage()),
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Video controller initialization error: $e');
      if (mounted) {
        setState(() {
          _isInitialized = false;
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
    return Stack(
      children: [
        // Gradient background
        const StarsAnimation(),
        if (_isInitialized && _controller != null)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontFamily: 'Canela',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                widget.subtitle,
                style: const TextStyle(
                  color: Color(0xFFF2EFEA),
                  fontSize: 16,
                  fontFamily: 'Satoshi-Regular',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: widget.bottomPadding),
            ],
          ),
        ),
      ],
    );
  }
} 