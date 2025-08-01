import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/stars_animation.dart';
import '../sleep_stream_meditation_page.dart';
import '../vault/vault_buttons.dart';
import '../vault/vault_ritual_card.dart';
import '../vault/vault_stat_card.dart';
import '../check_in_page.dart';
import '../../core/stores/meditation_store.dart';

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
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () => Navigator.of(
                              context,
                            ).pushReplacementNamed('/dashboard'),
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
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ), // Add bottom padding for navbar
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Center all children horizontally
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
                            child: Consumer<MeditationStore>(
                              builder: (context, meditationStore, child) {
                                final myMeditations = meditationStore.myMeditations;
                                final meditationCount = myMeditations?.length ?? 0;
                                
                                // Calculate total duration from all meditations
                                int totalDuration = 0;
                                if (myMeditations != null) {
                                  for (final meditation in myMeditations) {
                                    final details = meditation['details'];
                                    if (details != null && details['duration'] != null) {
                                      final duration = int.tryParse(details['duration'].toString()) ?? 0;
                                      totalDuration += duration;
                                    }
                                  }
                                }
                                
                                return Row(
                                  children: [
                                    Expanded(
                                      child: VaultStatCard(
                                        value: meditationCount.toString().padLeft(2, '0'),
                                        label: 'Meditations\nCreated',
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: VaultStatCard(
                                        value: totalDuration.toString(),
                                        unit: 'min',
                                        label: 'Total\ntime',
                                        unitBelow: true,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          Consumer<MeditationStore>(
                            builder: (context, meditationStore, child) {
                              final myMeditations = meditationStore.myMeditations;
                              final meditationCount = myMeditations?.length ?? 0;
                              
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Your Saved Rituals ($meditationCount)',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Canela',
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right, color: Colors.white),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (myMeditations != null && myMeditations.isNotEmpty) ...[
                                    if (meditationCount == 1) ...[
                                      VaultRitualCard(
                                        image: 'assets/img/card.png',
                                        title: 'Sleep Stream',
                                        subtitle: 'A deeply personalized journey crafted from your unique vision and dreams',
                                      ),
                                    ] else ...[
                                      ...myMeditations.map((meditation) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: VaultRitualCard(
                                          image: 'assets/img/card.png',
                                          title: 'Sleep Stream',
                                          subtitle: 'A deeply personalized journey crafted from your unique vision and dreams',
                                        ),
                                      )),
                                    ],
                                  ] else ...[
                                    VaultRitualCard(
                                      image: 'assets/img/card.png',
                                      title: 'Sleep Stream',
                                      subtitle: 'A deeply personalized journey crafted from your unique vision and dreams',
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          Consumer<MeditationStore>(
                            builder: (context, meditationStore, child) {
                              final archiveMeditation = meditationStore.archiveMeditation;
                              final archiveCount = archiveMeditation?.length ?? 0;
                              
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'The Archive ($archiveCount)',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Canela',
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right, color: Colors.white),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (archiveMeditation != null && archiveMeditation.isNotEmpty) ...[
                                    if (archiveCount == 1) ...[
                                      VaultRitualCard(
                                        image: 'assets/img/card.png',
                                        title: 'Morning Meditation',
                                        subtitle: 'Start your day with positive energy and clarity',
                                      ),
                                    ] else ...[
                                      ...archiveMeditation.map((meditation) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: VaultRitualCard(
                                          image: 'assets/img/card.png',
                                          title: 'Morning Meditation',
                                          subtitle: 'Start your day with positive energy and clarity',
                                        ),
                                      )),
                                    ],
                                  ] else ...[
                                    VaultRitualCard(
                                      image: 'assets/img/card.png',
                                      title: 'Morning Meditation',
                                      subtitle: 'Start your day with positive energy and clarity',
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          VaultButtons(
                            onContinue: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DailyCheckInPage(),
                                ),
                              );
                            },
                            onHome: () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed('/dashboard');
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
