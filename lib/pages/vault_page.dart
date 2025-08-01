import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/widgets/stars_animation.dart';
import '../shared/widgets/personalized_meditation_modal.dart';
import '../core/stores/meditation_store.dart';
import 'sleep_stream_meditation_page.dart';
import 'vault/vault_buttons.dart';
import 'vault/vault_ritual_card.dart';
import 'vault/vault_stat_card.dart';
import 'check_in_page.dart';

class VaultPage extends StatefulWidget {
  const VaultPage({super.key});

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  @override
  void initState() {
    super.initState();
    // Fetch meditations when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meditationStore = Provider.of<MeditationStore>(
        context,
        listen: false,
      );
      meditationStore.fetchMyMeditations();
      meditationStore.restoreMeditation();
    });
  }

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
                Expanded(
                  child: SingleChildScrollView(
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
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SleepStreamMeditationPage(),
                                  ),
                                ),
                              ),
                              Image.asset(
                                'assets/img/logo.png',
                                height: 32,
                                color: Colors.white,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return const PersonalizedMeditationModal();
                                    },
                                  );
                                },
                              ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Consumer<MeditationStore>(
                            builder: (context, meditationStore, child) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Your Saved Rituals (${meditationStore.myMeditations?.length ?? 0})',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Canela',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(
                                        context,
                                      ).pushNamed('/my-meditations');
                                    },
                                    child: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Consumer<MeditationStore>(
                          builder: (context, meditationStore, child) {
                            final myMeditations = meditationStore.myMeditations;
                            if (myMeditations == null ||
                                myMeditations.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            final meditationCount = myMeditations.length;
                            
                            if (meditationCount == 1) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: VaultRitualCard(
                                  image: 'assets/img/card.png',
                                  title: 'Sleep Stream ',
                                  subtitle:
                                      'A deeply personalized journey crafted from your unique vision and dreams',
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: meditationCount,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right: index < meditationCount - 1 ? 12.0 : 0,
                                      ),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width - 32,
                                        child: VaultRitualCard(
                                          image: 'assets/img/card.png',
                                          title: 'Sleep Stream ',
                                          subtitle:
                                              'A deeply personalized journey crafted from your unique vision and dreams',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Consumer<MeditationStore>(
                            builder: (context, meditationStore, child) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'The Archive (${meditationStore.archiveMeditation?.length ?? 0})',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Canela',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(
                                        context,
                                      ).pushNamed('/archive');
                                    },
                                    child: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Consumer<MeditationStore>(
                          builder: (context, meditationStore, child) {
                            final archiveMeditation =
                                meditationStore.archiveMeditation;
                            if (archiveMeditation == null) {
                              return const SizedBox.shrink();
                            }

                            final archiveCount = archiveMeditation.length;
                            
                            if (archiveCount == 1) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: VaultRitualCard(
                                  image: 'assets/img/card.png',
                                  title: 'Archive Meditation',
                                  subtitle: 'An archived meditation experience',
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: archiveCount,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right: index < archiveCount - 1 ? 12.0 : 0,
                                      ),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width - 32,
                                        child: VaultRitualCard(
                                          image: 'assets/img/card.png',
                                          title: 'Archive Meditation',
                                          subtitle: 'An archived meditation experience',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
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
                      Navigator.of(context).pushReplacementNamed('/dashboard');
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
