import 'package:flutter/material.dart';
import 'dart:ui';
import '../../shared/models/meditation_profile_data.dart';

class SleepMeditationAudioPlayer extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPausePressed;
  final MeditationProfileData? profileData; // Change to MeditationProfileData

  const SleepMeditationAudioPlayer({
    super.key,
    required this.isPlaying,
    required this.onPlayPausePressed,
    this.profileData, // Change to MeditationProfileData
  });

  @override
  Widget build(BuildContext context) {
    // Get duration from MeditationProfileData ritual
    final duration = profileData?.ritual?['duration'] ?? '5'; // Get duration from ritual object
    
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          'Sleep Stream ',
          style: TextStyle(
            fontFamily: 'Canela',
            fontSize: 32,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'A deeply personalized journey crafted\nfrom your unique vision and dreams',
          style: TextStyle(
            fontFamily: 'Satoshi-Regular',
            fontSize: 16,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'This $duration min meditation weaves together your personal aspirations, gratitude, and authentic self with dreamy guidance to help manifest your dream life.',
          style: const TextStyle(
            fontFamily: 'Satoshi-Regular',
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Center(
          child: GestureDetector(
            onTap: onPlayPausePressed,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                  image: AssetImage('assets/img/card.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                          child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(59, 110, 170, 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 