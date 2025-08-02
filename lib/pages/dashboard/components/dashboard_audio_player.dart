import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../shared/widgets/stars_animation.dart';
import '../../../shared/widgets/personalized_meditation_modal.dart';
import '../../../core/stores/meditation_store.dart';
import '../../../core/stores/like_store.dart';
import '../../components/sleep_meditation_header.dart';
import '../../components/sleep_meditation_audio_player.dart';
import '../../components/sleep_meditation_control_bar.dart';
import '../../components/sleep_meditation_waveform.dart';
import '../../components/sleep_meditation_action_buttons.dart';

class DashboardAudioPlayer extends StatefulWidget {
  final String meditationId;
  final String? title;
  final String? description;
  final String? imageUrl;

  const DashboardAudioPlayer({
    super.key,
    required this.meditationId,
    this.title,
    this.description,
    this.imageUrl,
  });

  @override
  State<DashboardAudioPlayer> createState() => _DashboardAudioPlayerState();
}

class _DashboardAudioPlayerState extends State<DashboardAudioPlayer> {
  just_audio.AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isAudioReady = false;
  PlayerController? _waveformController;
  bool _waveformReady = false;
  Duration _duration = const Duration(minutes: 3, seconds: 29);
  Duration _position = Duration.zero;
  bool _isLiked = false;
  bool _isMuted = false;
  String? fileUrl;

  @override
  void initState() {
    super.initState();
    _configureAudioSession();
    // Delay the audio loading to ensure widget is properly mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAndPlayMeditation();
    });
  }

  Future<void> _configureAudioSession() async {
    try {
      if (Platform.isIOS) {
        debugPrint('Configuring iOS audio session...');
      }
    } catch (e) {
      debugPrint('Error configuring audio session: $e');
    }
  }

  Future<void> _loadAndPlayMeditation() async {
    try {
      debugPrint('Loading meditation audio...');
      
      final meditationStore = Provider.of<MeditationStore>(context, listen: false);
      final profileData = meditationStore.meditationProfile;

      // First try to get fileUrl from store
      fileUrl = meditationStore.fileUrl;
      debugPrint('Got fileUrl from store: $fileUrl');
      
      // If not in store, try secure storage
      if (fileUrl == null || fileUrl!.isEmpty) {
        debugPrint('FileUrl is null in store, checking secure storage...');
        const storage = FlutterSecureStorage();
        final storedFile = await storage.read(key: 'file');
        if (storedFile != null && storedFile.isNotEmpty) {
          fileUrl = storedFile;
          debugPrint('Got fileUrl from secure storage: $fileUrl');
        } else {
          debugPrint('FileUrl not found in secure storage either');
        }
      }
      
      // If still null, wait a bit and retry store
      if (fileUrl == null || fileUrl!.isEmpty) {
        debugPrint('FileUrl is still null, waiting a bit and retrying store...');
        await Future.delayed(const Duration(milliseconds: 500));
        fileUrl = meditationStore.fileUrl;
        debugPrint('Retried fileUrl from store: $fileUrl');
      }

      // Dispose previous audio player safely
      if (_audioPlayer != null) {
        try {
          await _audioPlayer!.stop();
          await _audioPlayer!.dispose();
        } catch (e) {
          debugPrint('Error disposing previous audio player: $e');
        }
        _audioPlayer = null;
      }

      // Dispose previous waveform controller safely
      if (_waveformController != null) {
        try {
          _waveformController!.dispose();
        } catch (e) {
          debugPrint('Error disposing previous waveform controller: $e');
        }
        _waveformController = null;
      }

      // Create new instances
      _audioPlayer = just_audio.AudioPlayer();
      _waveformController = PlayerController();

      if (fileUrl != null && fileUrl!.isNotEmpty && _audioPlayer != null) {
        debugPrint('Setting audio URL: $fileUrl');
        try {
          await _audioPlayer!.setUrl(fileUrl!);
          debugPrint('Audio URL set successfully');
        } catch (e) {
          debugPrint('Error setting audio URL: $e');
          return;
        }

        _audioPlayer!.playerStateStream.listen((state) {
          debugPrint('Player state: ${state.processingState} - playing: ${state.playing}');
          if (mounted) {
            setState(() {
              _isPlaying = state.playing;
              _isAudioReady =
                  state.processingState == just_audio.ProcessingState.ready;
            });
          }
        });

        _audioPlayer!.durationStream.listen((duration) {
          debugPrint('Duration: $duration');
          if (mounted) {
            setState(() {
              _duration = duration ?? const Duration(minutes: 3, seconds: 29);
            });
          }
        });

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

        debugPrint('Audio player initialized successfully');
        await _prepareWaveform();
      } else {
        debugPrint('No fileUrl available from store: ${meditationStore.fileUrl}');
        setState(() {
          _isAudioReady = true;
        });
      }
    } catch (e) {
      debugPrint('Error in _loadAndPlayMeditation: $e');
      setState(() {
        _isAudioReady = true;
      });
    }
  }

  Future<void> _prepareWaveform() async {
    try {
      if (_waveformController != null) {
        await _waveformController!.preparePlayer(
          path: fileUrl ?? '',
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
    }
  }

  @override
  void dispose() {
    try {
      _audioPlayer?.stop();
      _audioPlayer?.dispose();
    } catch (e) {
      debugPrint('Error disposing audio player: $e');
    }
    
    try {
      _waveformController?.dispose();
    } catch (e) {
      debugPrint('Error disposing waveform controller: $e');
    }
    
    super.dispose();
  }

  void _togglePlayPause() async {
    try {
      if (_audioPlayer == null) {
        await _loadAndPlayMeditation();
        return;
      }

      if (_isPlaying) {
        await _audioPlayer!.pause();
        if (_waveformReady && _waveformController != null) {
          try {
            _waveformController!.pausePlayer();
          } catch (e) {
            debugPrint('Error pausing waveform: $e');
          }
        }
      } else {
        if (!_isAudioReady) {
          await _audioPlayer!.setUrl(fileUrl!);
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

  void _toggleLike() async {
    final meditationStore = context.read<MeditationStore>();
    final likeStore = context.read<LikeStore>();
    
    final meditationId = meditationStore.meditationProfile?.ritual?['id']?.toString();
    
    if (meditationId != null) {
      await likeStore.toggleLike(meditationId);
      setState(() {
        _isLiked = likeStore.isLiked(meditationId);
      });
    } else {
      setState(() {
        _isLiked = !_isLiked;
      });
    }
  }

  void _shareMeditation() async {
    await Share.share('Check out this meditation!');
  }

  void _resetMeditation() {
    context.read<MeditationStore>().completeReset();
    Navigator.pushReplacementNamed(context, '/generator');
  }

  void _saveToVault() {
    Navigator.pushReplacementNamed(context, '/vault');
  }

  void _handleBack() {
    // Check if we can go back in navigation history
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      // If no previous page, go to home
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void _showPersonalizedMeditationInfo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const PersonalizedMeditationModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(204),
      child: Stack(
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
                            onBackPressed: _handleBack,
                            onInfoPressed: _showPersonalizedMeditationInfo,
                          ),
                          Consumer<MeditationStore>(
                            builder: (context, meditationStore, child) {
                              return SleepMeditationAudioPlayer(
                                isPlaying: _isPlaying,
                                onPlayPausePressed: _togglePlayPause,
                                profileData: meditationStore.meditationProfile,
                                title: widget.title,
                                description: widget.description,
                                imageUrl: widget.imageUrl,
                              );
                            },
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
                          Material(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Slider(
                                  value: _position.inSeconds.toDouble().clamp(
                                    0,
                                    _duration.inSeconds.toDouble(),
                                  ),
                                  min: 0,
                                  max: _duration.inSeconds.toDouble(),
                                  onChanged: (value) async {
                                    final newPosition = Duration(
                                      seconds: value.toInt(),
                                    );
                                    await _audioPlayer?.seek(newPosition);
                                    setState(() {
                                      _position = newPosition;
                                    });
                                  },
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SleepMeditationActionButtons(
                  //   onResetPressed: _resetMeditation,
                  //   onSavePressed: _saveToVault,
                  // ),
                  // const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 