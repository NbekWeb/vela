import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/stars_animation.dart';
import '../sleep_stream_meditation_page.dart';
import '../vault/vault_buttons.dart';
import '../vault/vault_ritual_card.dart';
import '../vault/vault_stat_card.dart';
import '../check_in_page.dart';
import '../dashboard/my_meditations_page.dart';
import '../dashboard/archive_page.dart';
import '../../core/stores/meditation_store.dart';

class DashboardVaultPage extends StatefulWidget {
  final Function(String)? onAudioPlay;
  
  const DashboardVaultPage({this.onAudioPlay, super.key});

  @override
  State<DashboardVaultPage> createState() => _DashboardVaultPageState();
}

class _DashboardVaultPageState extends State<DashboardVaultPage> {
  @override
  void initState() {
    super.initState();
    // Fetch meditations when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meditationStore = Provider.of<MeditationStore>(context, listen: false);
      meditationStore.fetchMyMeditations();
      meditationStore.fetchMeditationLibrary();
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
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Consumer<MeditationStore>(
                              builder: (context, meditationStore, child) {
                                final myMeditations =
                                    meditationStore.myMeditations;
                                final meditationCount =
                                    myMeditations?.length ?? 0;

                                // Calculate total duration from all meditations
                                int totalDuration = 0;
                                if (myMeditations != null) {
                                  for (final meditation in myMeditations) {
                                    final details = meditation['details'];
                                    if (details != null &&
                                        details['duration'] != null) {
                                      final duration =
                                          int.tryParse(
                                            details['duration'].toString(),
                                          ) ??
                                          0;
                                      totalDuration += duration;
                                    }
                                  }
                                }

                                return Row(
                                  children: [
                                    Expanded(
                                      child: VaultStatCard(
                                        value: meditationCount
                                            .toString()
                                            .padLeft(2, '0'),
                                        label: 'Meditations\nCreated',
                                      ),
                                    ),
                                    const SizedBox(width: 12),
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
                              final myMeditations =
                                  meditationStore.myMeditations;
                              final meditationCount =
                                  myMeditations?.length ?? 0;

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => MyMeditationsPage(),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (myMeditations != null &&
                                      myMeditations.isNotEmpty) ...[
                                    SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: meditationCount,
                                        itemBuilder: (context, index) {
                                          final meditation = myMeditations[index];
                                          final details = meditation['details'];
                                          final name = details?['name'] ?? 'Sleep Stream';
                                          final meditationId = meditation['id']?.toString();

                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right: index < meditationCount - 1 ? 12.0 : 0,
                                            ),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width - 32,
                                              child: VaultRitualCard(
                                            name: name,
                                            meditationId: meditationId,
                                                onAudioPlay: widget.onAudioPlay,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ] else ...[
                                    VaultRitualCard(
                                      name: 'Sleep Stream',
                                      onAudioPlay: widget.onAudioPlay,
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          Consumer<MeditationStore>(
                            builder: (context, meditationStore, child) {
                              final libraryDatas = meditationStore.libraryDatas;
                              final libraryCount = libraryDatas?.length ?? 0;

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'The Archive ($libraryCount)',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Canela',
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
                                        child: const Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (libraryDatas != null &&
                                      libraryDatas.isNotEmpty) ...[
                                    SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: libraryCount,
                                        itemBuilder: (context, index) {
                                          final meditation = libraryDatas[index];
                                          final name = meditation['name'] ?? 'Library Meditation';
                                          final meditationId = meditation['id']?.toString();
                                          final file = meditation['file']?.toString();
                                          final title = meditation['name']?.toString();
                                          final description = meditation['description']?.toString();
                                          final imageUrl = meditation['image']?.toString();
                                          
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right: index < libraryCount - 1 ? 12.0 : 0,
                                            ),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width - 32,
                                              child: VaultRitualCard(
                                            name: name,
                                            meditationId: meditationId,
                                                file: file,
                                                title: title,
                                                description: description,
                                                imageUrl: imageUrl,
                                                onAudioPlay: widget.onAudioPlay,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ] else ...[
                                    VaultRitualCard(
                                      name: 'Library Meditation',
                                      onAudioPlay: widget.onAudioPlay,
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          
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
