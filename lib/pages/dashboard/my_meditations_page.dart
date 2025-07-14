import 'package:flutter/material.dart';
import '../vault/vault_ritual_card.dart';
import '../../shared/widgets/stars_animation.dart';

class MyMeditationsPage extends StatelessWidget {
  const MyMeditationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const StarsAnimation(
          ),
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
                Text(
                  'My meditations',
                  style: TextStyle(
                    fontFamily: 'Canela',
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pick a meditation or make your own',
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
                    child: Column(
                      children: const [
                        VaultRitualCard(
                          image: 'assets/img/card.png',
                          title: 'Sleep Stream Meditation',
                          subtitle: 'A deeply personalized journey crafted from your unique vision and dreams',
                        ),
                        SizedBox(height: 16),
                        VaultRitualCard(
                          image: 'assets/img/card.png',
                          title: 'Dream Flow Meditation',
                          subtitle: 'An intimately tailored experience shaped by your individual aspirations and fantasies.',
                        ),
                        SizedBox(height: 16),
                        VaultRitualCard(
                          image: 'assets/img/card.png',
                          title: 'Creative Flow Art Therapy',
                          subtitle: 'An expressive outlet that fosters creativity and self-discovery through various artistic mediums.',
                        ),
                        SizedBox(height: 16),
                        VaultRitualCard(
                          image: 'assets/img/card.png',
                          title: 'Vision Stream Meditation',
                          subtitle: 'A deeply personalized journey crafted around your unique desires and dreams.',
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B6EAA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 