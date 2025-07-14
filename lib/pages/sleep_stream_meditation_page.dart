import 'package:flutter/material.dart';
import '../shared/widgets/stars_animation.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:share_plus/share_plus.dart';
import 'components/sleep_meditation_header.dart';
import 'components/sleep_meditation_audio_player.dart';
import 'components/sleep_meditation_control_bar.dart';
import 'components/sleep_meditation_waveform.dart';
import 'components/sleep_meditation_action_buttons.dart';

class SleepStreamMeditationPage extends StatefulWidget {
  const SleepStreamMeditationPage({super.key});

  @override
  State<SleepStreamMeditationPage> createState() => _SleepStreamMeditationPageState();
}

class _SleepStreamMeditationPageState extends State<SleepStreamMeditationPage> {
  just_audio.AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isAudioReady = false;
  PlayerController? _waveformController;
  bool _waveformReady = false;
  Duration _duration = const Duration(minutes: 3, seconds: 29);
  Duration _position = Duration.zero;
  bool _isLiked = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  Future<void> _initializeAudioPlayer() async {
    try {
      _audioPlayer = just_audio.AudioPlayer();
      _waveformController = PlayerController();
      
      // Set up audio player
      await _audioPlayer!.setAsset('assets/audio/ex.mp3');
      debugPrint('Asset set successfully');
      
      // Listen to player state changes
      _audioPlayer!.playerStateStream.listen((state) {
        debugPrint('Player state changed: ${state.playing}, processing: ${state.processingState}');
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
            _isAudioReady = state.processingState == just_audio.ProcessingState.ready;
          });
        }
      });

      // Listen to duration changes
      _audioPlayer!.durationStream.listen((duration) {
        debugPrint('Duration changed: $duration');
        if (mounted) {
          setState(() {
            _duration = duration ?? const Duration(minutes: 3, seconds: 29);
          });
        }
      });

      // Listen to position changes
      _audioPlayer!.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _position = position;
          });
        }
      });

      setState(() {
        _isAudioReady = true;
      });

      // Prepare waveform after audio player is ready
      await _prepareWaveform();
      debugPrint('Audio player initialized successfully');
    } catch (e) {
      debugPrint('Error initializing audio player: $e');
      setState(() {
        _isAudioReady = true;
      });
    }
  }

  Future<void> _prepareWaveform() async {
    try {
      if (_waveformController != null) {
        await _waveformController!.preparePlayer(
          path: 'assets/audio/ex.mp3',
          shouldExtractWaveform: true,
          noOfSamples: 80,
        );

        if (mounted) {
          setState(() {
            _waveformReady = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error preparing waveform: $e');
      // Continue without waveform if it fails
    }
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    _waveformController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    try {
      debugPrint('Toggle play/pause called. Current state: $_isPlaying');
      debugPrint('Audio ready: $_isAudioReady, Duration: $_duration');
      
      if (_audioPlayer == null) {
        debugPrint('Audio player is null, initializing...');
        await _initializeAudioPlayer();
        return;
      }
      
      if (_isPlaying) {
        debugPrint('Pausing audio...');
        await _audioPlayer!.pause();
        if (_waveformReady && _waveformController != null) {
          try {
            _waveformController!.pausePlayer();
          } catch (e) {
            debugPrint('Error pausing waveform: $e');
          }
        }
      } else {
        debugPrint('Playing audio...');
        
        // Ensure audio is ready before playing
        if (!_isAudioReady) {
          debugPrint('Audio not ready, trying to initialize...');
          await _audioPlayer!.setAsset('assets/audio/ex.mp3');
          setState(() {
            _isAudioReady = true;
            _duration = const Duration(minutes: 3, seconds: 29);
          });
        }
        
        await _audioPlayer!.play();
        if (_waveformReady && _waveformController != null) {
          try {
            _waveformController!.startPlayer();
          } catch (e) {
            debugPrint('Error starting waveform: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error toggling play/pause: $e');
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _audioPlayer?.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _shareMeditation() async {
    await Share.share('Check out this meditation!');
  }

  void _resetMeditation() {
    // Reset functionality - can be implemented as needed
    debugPrint('Reset meditation');
  }

  void _saveToVault() {
    Navigator.pushNamed(context, '/vault');
  }

  void _testAudio() async {
    debugPrint('Testing audio...');
    try {
      if (_audioPlayer != null) {
        await _audioPlayer!.setAsset('assets/audio/ex.mp3');
        await _audioPlayer!.play();
        debugPrint('Test audio started');
      }
    } catch (e) {
      debugPrint('Test audio failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(204), // 0.8 * 255 ≈ 204
      body: Stack(
        children: [
          const StarsAnimation(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SleepMeditationHeader(
                            onBackPressed: () => Navigator.of(context).pop(),
                            onInfoPressed: _testAudio,
                          ),
                          SleepMeditationAudioPlayer(
                            isPlaying: _isPlaying,
                            onPlayPausePressed: _togglePlayPause,
                          ),
                          const SizedBox(height: 24),
                          SleepMeditationControlBar(
                            isMuted: _isMuted,
                            isLiked: _isLiked,
                            onMuteToggle: _toggleMute,
                            onLikeToggle: _toggleLike,
                            onShare: _shareMeditation,
                          ),
                          const SizedBox(height: 24),
                          SleepMeditationWaveform(
                            waveformReady: _waveformReady,
                            waveformController: _waveformController,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom buttons outside scroll
                  SleepMeditationActionButtons(
                    onResetPressed: _resetMeditation,
                    onSavePressed: _saveToVault,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 