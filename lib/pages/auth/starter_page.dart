import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../shared/widgets/svg_icon.dart';
import '../../shared/widgets/starter_modal.dart';
import '../../styles/pages/starter_page_styles.dart';
import '../../styles/components/button_styles.dart';
import '../../styles/components/text_styles.dart';
import '../../styles/components/spacing_styles.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  VideoPlayerController? _controller;
  bool isMuted = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(StarterPageStyles.systemUiStyle);
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    try {
      _controller = VideoPlayerController.asset('assets/videos/starter.mp4');
      
      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        
        _controller!
          ..setLooping(true)
          ..setVolume(1.0)
          ..play();
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: StarterPageStyles.systemUiStyleWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            if (_isInitialized && _controller != null)
              SizedBox.expand(
                child: FittedBox(
                  fit: StarterPageStyles.videoFit,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: SpacingStyles.starterPagePadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isMuted = !isMuted;
                              _controller?.setVolume(isMuted ? 0.0 : 1.0);
                            });
                          },
                          child: SvgIcon(
                            assetName: isMuted
                                ? 'assets/icons/mute.svg'
                                : 'assets/icons/unmute.svg',
                            color: StarterPageStyles.iconColor,
                          ),
                        ),
                        Text(
                          'vela',
                          style: TextStyles.brandText,
                        ),
                        GestureDetector(
                          onTap: () {
                            openPopupFromTop(context, const StarterModal());
                          },
                          child: SvgIcon(
                            assetName: 'assets/icons/brain.svg',
                            color: StarterPageStyles.iconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Restore the original layout: use Spacer to push the text section down
                  const Spacer(),
                  Text(
                    'Navigate\nfrom Within',
                    textAlign: TextAlign.center,
                    style: TextStyles.headingLarge,
                  ),
                  SpacingStyles.spacingMedium,
                  Padding(
                    padding: SpacingStyles.starterPageContentPadding,
                    child: Text(
                      'Vela is the only meditation app built specifically for you. Personalized meditations built from your joy, identity, and dreams.\n\nGuided by AI, grounded in neuroscience. Set sail to manifest your dream life, with Vela.',
                      textAlign: TextAlign.center,
                      style: TextStyles.bodyLarge,
                    ),
                  ),
                  SpacingStyles.spacingLarge,
                  Padding(
                    padding: SpacingStyles.paddingHorizontal,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ButtonStyles.primary,
                      child: Text(
                        'Get Started',
                        style: ButtonStyles.primaryText,
                      ),
                    ),
                  ),
                  SpacingStyles.spacingSmall,
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ButtonStyles.text,
                    child: Text(
                      'Already have an account? Sign in',
                      style: ButtonStyles.linkText,
                    ),
                  ),
                  SpacingStyles.spacingSmall,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void openPopupFromTop(BuildContext context, Widget child) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      barrierColor: StarterPageStyles.barrierColor,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}
