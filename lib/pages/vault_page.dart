import 'package:flutter/material.dart';
import '../shared/widgets/stars_animation.dart';
import 'sleep_stream_meditation_page.dart';
import 'vault/vault_buttons.dart';
import 'vault/vault_ritual_card.dart';
import 'vault/vault_stat_card.dart';
import 'check_in_page.dart';

class VaultPage extends StatelessWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const StarsAnimation(starCount: 50),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SleepStreamMeditationPage(),
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/img/logo.png',
                        height: 32,
                        color: Colors.white,
                      ),
                      const Icon(Icons.info_outline, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your Dream Vault',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Canela',
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'A living reflection of the future you\'re building',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Satoshi-Regular',
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: VaultStatCard(
                          value: '01',
                          label: 'Meditations\nCreated',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: VaultStatCard(
                          value: '10',
                          unit: 'min',
                          label: 'Total\ntime',
                          unitBelow: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Your Saved Rituals (1)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Canela',
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: VaultRitualCard(
                    image: 'assets/img/card.png',
                    title: 'Sleep Stream Meditation',
                    subtitle:
                        'A deeply personalized journey crafted from your unique vision and dreams',
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'The Archive (21)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Canela',
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: VaultRitualCard(
                    image: 'assets/img/card.png',
                    title: 'Zen Garden Sounds',
                    subtitle:
                        'Immerse yourself in nature with calming sounds designed to soothe your mind.',
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: VaultButtons(
                    onContinue: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const DailyCheckInPage(),
                        ),
                      );
                    },
                    onHome: () {
                      Navigator.of(context).pop();
                    },
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
