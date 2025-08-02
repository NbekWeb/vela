import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vault/vault_ritual_card.dart';
import 'package:video_player/video_player.dart';
import '../../shared/widgets/custom_star.dart';
import '../dashboard/my_meditations_page.dart';
import '../dashboard/archive_page.dart';
import '../generator/generator_page.dart';
import '../sleep_stream_meditation_page.dart';
import '../../core/stores/auth_store.dart';
import '../../core/stores/meditation_store.dart';
import '../dashboard/components/dashboard_audio_player.dart';

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key});

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
    _getUserDetails();
    _loadMeditationData();
  }

  Future<void> _initializeVideoController() async {
    try {
      _controller = VideoPlayerController.asset('assets/videos/starter.mp4');

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });

        _controller!
          ..setLooping(true)
          ..setVolume(0)
          ..play();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _getUserDetails() async {
    // Use Provider to access AuthStore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authStore = Provider.of<AuthStore>(context, listen: false);
      authStore.getUserDetails();
    });
  }

  Future<void> _loadMeditationData() async {
    // Use Provider to access MeditationStore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meditationStore = Provider.of<MeditationStore>(
        context,
        listen: false,
      );
      meditationStore.fetchMyMeditations();
      meditationStore.fetchMeditationLibrary();
    });
  }

  void _onAudioPlay(
    String meditationId, {
    String? title,
    String? description,
    String? imageUrl,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardAudioPlayer(
          meditationId: meditationId,
          title: title,
          description: description,
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5398DA),
      body: Column(
        children: [
          // Video background that covers entire screen including status bar
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  // Video background that scrolls with content - starts from top
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: _isInitialized && _controller != null && !_hasError
                        ? FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _controller!.value.size.width,
                              height: _controller!.value.size.height,
                              child: VideoPlayer(_controller!),
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFB3D8F7),
                                  Color(0xFF8BC6F7),
                                  Color(0xFF5AA9F7),
                                ],
                              ),
                            ),
                          ),
                  ),
                  // Content overlay with SafeArea
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Info icon in a circle, size 24x24
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
                              Image.asset('assets/img/logo.png', width: 60, height: 39),
                              // Avatar on the right, size 30x30
                              Consumer<AuthStore>(
                                builder: (context, authStore, child) {
                                  final user = authStore.user;
                                  final avatarUrl = user?.avatar;

                                  if (avatarUrl != null && avatarUrl.isNotEmpty) {
                                    return Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: NetworkImage(avatarUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: const DecorationImage(
                                          image: AssetImage('assets/img/card.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 300),
                          Center(
                            child: Text(
                              'Daily Streaks',
                              style: TextStyle(
                                fontFamily: 'Canela',
                                fontSize: 36,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Consumer<AuthStore>(
                            builder: (context, authStore, child) {
                              final user = authStore.user;
                              final weeklyStats = user?.weeklyLoginStats;
                              
                              int totalLogins = 0;
                              if (weeklyStats != null && weeklyStats.days.isNotEmpty) {
                                totalLogins = weeklyStats.days
                                    .where((day) => day.login)
                                    .length;
                              }

                              String streakText;
                              if (totalLogins == 0) {
                                streakText =
                                    'Start your meditation journey today';
                              } else if (totalLogins == 1) {
                                streakText = 'You\'ve shown up 1 day this week';
                              } else {
                                streakText =
                                    'You\'ve shown up $totalLogins days this week';
                              }

                              return Center(
                                child: Text(
                                  streakText,
                                  style: const TextStyle(
                                    color: Color(0xFFDCE6F0),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Consumer<AuthStore>(
                            builder: (context, authStore, child) {
                              final user = authStore.user;
                              final weeklyStats = user?.weeklyLoginStats;

                              if (weeklyStats != null && weeklyStats.days.isNotEmpty) {
                                final dayLabels = [
                                  'M',
                                  'T',
                                  'W',
                                  'T',
                                  'F',
                                  'S',
                                  'S',
                                ];

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(7, (index) {
                                    final dayData = weeklyStats.days[index];
                                    final isFilled = dayData.login;

                                    return CustomStar(
                                      isFilled: isFilled,
                                      title: dayLabels[index],
                                      size: 36,
                                    );
                                  }),
                                );
                              } else {
                                // Fallback if no weekly stats
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(
                                    7,
                                    (index) => CustomStar(
                                      isFilled: false,
                                      title: [
                                        'M',
                                        'T',
                                        'W',
                                        'T',
                                        'F',
                                        'S',
                                        'S',
                                      ][index],
                                      size: 36,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MyMeditationsPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'My meditations',
                                  style: TextStyle(
                                    fontFamily: 'Canela',
                                    fontSize: 36,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
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
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFFDCE6F0),
                                  size: 36,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Consumer<MeditationStore>(
                            builder: (context, meditationStore, child) {
                              final myMeditations =
                                  meditationStore.myMeditations;

                              if (myMeditations != null &&
                                  myMeditations.isNotEmpty) {
                                // Show meditations based on count
                                final meditationCount = myMeditations.length;
                                
                                if (meditationCount == 1) {
                                  // Single card - no scroll needed
                                  final meditation = myMeditations.first;
                                  final details = meditation['details'];
                                  final name = details?['name'] ?? 'Sleep Stream';
                                  
                                  return VaultRitualCard(
                                    name: name,
                                    meditationId: meditation['id']?.toString(),
                                    file: meditation['file'],
                                    onAudioPlay: _onAudioPlay,
                                  );
                                } else {
                                  // Multiple cards - horizontal scroll
                                  return SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: meditationCount,
                                      itemBuilder: (context, index) {
                                        final meditation = myMeditations[index];
                                        final details = meditation['details'];
                                        final name = details?['name'] ?? 'Sleep Stream';
                                        
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            right: index < meditationCount - 1 ? 12.0 : 0,
                                          ),
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width - 32,
                                            child: VaultRitualCard(
                                              name: name,
                                              meditationId: meditation['id']?.toString(),
                                              file: meditation['file'],
                                              onAudioPlay: _onAudioPlay,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              } else {
                                return VaultRitualCard(
                                  name: 'Sleep Stream',
                                  meditationId: '1',
                                  onAudioPlay: _onAudioPlay,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GeneratorPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3B6EAA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Generate New Meditation',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/img/star.png',
                                    width: 28,
                                    height: 28,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ArchivePage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'The Archive',
                                  style: TextStyle(
                                    fontFamily: 'Canela',
                                    fontSize: 36,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
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
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFFDCE6F0),
                                  size: 36,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Consumer<MeditationStore>(
                            builder: (context, meditationStore, child) {
                              final libraryDatas = meditationStore.libraryDatas;

                              if (libraryDatas != null && libraryDatas.isNotEmpty) {
                                // If libraryDatas has items, show cards in horizontal scroll
                                return SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: libraryDatas.length,
                                    itemBuilder: (context, index) {
                                      final meditation = libraryDatas[index];
                                      final name = meditation['name'] ?? 'Morning Meditation';
                                      
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          right: index < libraryDatas.length - 1 ? 12.0 : 0,
                                        ),
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width - 32,
                                          child: VaultRitualCard(
                                            name: name,
                                            meditationId: meditation['id']?.toString(),
                                            file: meditation['file'],
                                            imageUrl: meditation['image'],
                                            title: meditation['name'],
                                            description: meditation['description'],
                                            onAudioPlay: (id) => _onAudioPlay(
                                              id,
                                              title: meditation['name'],
                                              description: meditation['description'],
                                              imageUrl: meditation['image'],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                // If no libraryDatas, show no cards
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
