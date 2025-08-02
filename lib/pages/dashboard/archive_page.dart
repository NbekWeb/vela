import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vault/vault_ritual_card.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../core/stores/meditation_store.dart';
import 'components/dashboard_audio_player.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  void initState() {
    super.initState();
    // Fetch meditation library when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meditationStore = Provider.of<MeditationStore>(
        context,
        listen: false,
      );
      meditationStore.fetchMeditationLibrary();
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
                    fontWeight: FontWeight.w300,
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
                        // Show loading indicator while fetching data
                        if (meditationStore.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }

                        final libraryDatas = meditationStore.libraryDatas;
                        final libraryCount = libraryDatas?.length ?? 0;
                        
                        if (libraryCount > 0) {
                          // Show all cards in vertical scroll
                          return Column(
                            children: List.generate(libraryCount, (index) {
                              final meditation = libraryDatas![index];
                              final name = meditation['name'] ?? 'Morning Meditation';
                              
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index < libraryCount - 1 ? 16.0 : 0,
                                ),
                                child: VaultRitualCard(
                                  name: name,
                                  meditationId: meditation['id']?.toString(),
                                  file: meditation['file'],
                                  imageUrl: meditation['image'],
                                  title: meditation['name'],
                                  description: meditation['description'],
                                  onAudioPlay: (meditationId) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DashboardAudioPlayer(
                                          meditationId: meditationId,
                                          title: meditation['name'],
                                          description: meditation['description'],
                                          imageUrl: meditation['image'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          );
                        } else {
                          // Show no cards if no library meditations
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
