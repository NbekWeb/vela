import 'package:flutter/material.dart';
import '../vault/vault_ritual_card.dart';
import '../../shared/widgets/stars_animation.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

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
                    child: Column(
                      children: const [
                        VaultRitualCard(
                          image: 'assets/img/card.png',
                          title: 'Morning Meditation',
                          subtitle:
                              'Start your day with positive energy and clarity',
                        ),
                        SizedBox(height: 16),
                        VaultRitualCard(
                          image: 'assets/img/card.png',
                          title: 'Evening Reflection',
                          subtitle: 'Wind down and reflect on your day',
                        ),
                        SizedBox(height: 16),
                        VaultRitualCard(
                          image: 'assets/img/card.png',
                          title: 'Serene Sunrise Yoga',
                          subtitle:
                              'Gentle stretches and breathing exercises to awaken your body and mind.',
                        ),
                      ],
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
