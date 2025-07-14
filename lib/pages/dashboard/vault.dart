import 'package:flutter/material.dart';
import '../../shared/widgets/stars_animation.dart';
import '../sleep_stream_meditation_page.dart';
import '../vault/vault_buttons.dart';
import '../vault/vault_ritual_card.dart';
import '../vault/vault_stat_card.dart';
import '../check_in_page.dart';

class DashboardVaultPage extends StatelessWidget {
  const DashboardVaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const StarsAnimation(starCount: 50),
          SafeArea(
            child: Column(
              children: [
                // Fixed header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4, 16.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back arrow in a circle, size 24x24
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SleepStreamMeditationPage(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Image.asset('assets/img/logo.png', width: 60, height: 39),
                      // Info icon on the right, size 24x24
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
                    ],
                  ),
                ),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 10), // Add bottom padding for navbar
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Center all children horizontally
                        children: [
                          const SizedBox(height: 16),
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
                          Row(
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
                          const SizedBox(height: 12),
                          VaultRitualCard(
                            image: 'assets/img/card.png',
                            title: 'Sleep Stream Meditation',
                            subtitle:
                                'A deeply personalized journey crafted from your unique vision and dreams',
                          ),
                          const SizedBox(height: 24),
                          Row(
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
                          const SizedBox(height: 12),
                          VaultRitualCard(
                            image: 'assets/img/card.png',
                            title: 'Zen Garden Sounds',
                            subtitle:
                                'Immerse yourself in nature with calming sounds designed to soothe your mind.',
                          ),
                          const SizedBox(height: 24),
                          VaultButtons(
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