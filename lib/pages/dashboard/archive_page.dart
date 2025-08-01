import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vault/vault_ritual_card.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../core/stores/meditation_store.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  void initState() {
    super.initState();
    // Fetch archive meditations when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meditationStore = Provider.of<MeditationStore>(
        context,
        listen: false,
      );
      meditationStore.restoreMeditation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const StarsAnimation(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4, 16.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Image.asset('assets/img/logo.png', width: 60, height: 39),
                      ClipOval(
                        child: Image.asset(
                          'assets/img/card.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Meditations library',
                  style: TextStyle(
                    fontFamily: 'Canela',
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select meditations selected by the Vela team',
                  style: TextStyle(
                    color: Color(0xFFDCE6F0),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Consumer<MeditationStore>(
                      builder: (context, meditationStore, child) {
                        final archiveMeditation = meditationStore.archiveMeditation;
                        final archiveCount = archiveMeditation?.length ?? 0;
                        
                        if (archiveCount > 0) {
                          // Show cards based on archive count
                          if (archiveCount == 1) {
                            // Single card - no scroll needed
                            return VaultRitualCard(
                              image: 'assets/img/card.png',
                              title: 'Morning Meditation',
                              subtitle: 'Start your day with positive energy and clarity',
                            );
                          } else {
                            // Multiple cards - horizontal scroll
                            return SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: archiveCount,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: index < archiveCount - 1 ? 16.0 : 0,
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width - 32,
                                      child: VaultRitualCard(
                                        image: 'assets/img/card.png',
                                        title: 'Morning Meditation',
                                        subtitle: 'Start your day with positive energy and clarity',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        } else {
                          // Show no cards if no archive meditations
                          return const SizedBox.shrink();
                        }
                      },
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
