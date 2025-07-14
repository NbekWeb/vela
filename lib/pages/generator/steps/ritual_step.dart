import 'package:flutter/material.dart';
import '../step_scaffold.dart';
import '../../../shared/widgets/show_ritual_info_modal.dart';
import '../../../shared/widgets/ritual_info_modal.dart';

class RitualStep extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final int currentStep;
  final int totalSteps;
  final bool showStepper;

  const RitualStep({
    Key? key,
    this.onBack,
    this.onNext,
    required this.currentStep,
    required this.totalSteps,
    this.showStepper = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      title: 'Choose Your Ritual',
      onBack: onBack,
      onNext: null, // No next button
      currentStep: currentStep,
      totalSteps: totalSteps,
      nextEnabled: false, // Disable next button
      showStepper: showStepper,
      showTitles: false, // Don't show "Dream life intake" header
      showInfo: true,    // show info icon on the right (or false to hide)
      child: RitualChooser(
        onBack: onBack,
        showBackButton: false,
        showInfoButton: false,
      ),
    );
  }
}

class RitualChooser extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onInfo;
  final bool showBackButton;
  final bool showInfoButton;

  const RitualChooser({
    Key? key,
    this.onBack,
    this.onInfo,
    this.showBackButton = true,
    this.showInfoButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rituals = [
      _RitualCardData(
        title: 'Sleep Manifestation',
        subtitle: 'Fall asleep inside your future',
        color: const Color(0xFFB3D0E7),
        icon: Icons.nightlight_round,
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 41, 108, 184), Color(0xFFB3D0E7)], // to‘q ko‘k → och ko‘k
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _RitualCardData(
        title: 'Morning Spark',
        subtitle: 'Fuel your vision with focus and energy.',
        color: const Color(0xFFFFD59E),
        icon: Icons.wb_sunny,
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 227, 143, 110), Color(0xFFE0CDAD)], // to‘q sariq → och sariq
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _RitualCardData(
        title: 'Calming Reset',
        subtitle: 'Return to calm. Reconnect with clarity',
        color: const Color(0xFFF7B233),
        icon: Icons.waves,
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 211, 63, 237), Color.fromARGB(255, 245, 234, 243)], // to‘q pushti → och pushti
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _RitualCardData(
        title: 'Dream Visualizer',
        subtitle: 'Drop into the life you’re building.',
        color: const Color(0xFFC2B6F7),
        icon: Icons.star_border,
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 90, 58, 165), Color.fromARGB(255, 206, 197, 246)], // to‘q binafsha → och binafsha
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];

    final ritualInfos = [
      {
        'title': 'Sleep Manifestation',
        'body': 'Let your mind drift into your dream life as you fall asleep. This ritual helps you visualize your goals and primes your subconscious for success overnight.'
      },
      {
        'title': 'Morning Spark',
        'body': 'Start your day with clarity and energy. This ritual focuses your mind on your vision, setting a positive and productive tone for the day.'
      },
      {
        'title': 'Calming Reset',
        'body': 'Take a mindful pause to reset and reconnect. This ritual brings you back to calm, helping you regain clarity and composure.'
      },
      {
        'title': 'Dream Visualizer',
        'body': 'Immerse yourself in the life you’re building. This ritual strengthens your vision and motivation, making your dreams feel real and attainable.'
      },
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Select the perfect meditation\nexperience for this moment',
          style: TextStyle(
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFFF2EFEA),
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...List.generate(rituals.length, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: _RitualCard(
                ritual: rituals[i],
                onTap: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                    barrierColor: Colors.black54,
                    transitionDuration: const Duration(milliseconds: 350),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        CustomizeRitualModal(onClose: () => Navigator.of(context).pop()),
                    transitionBuilder: (context, animation, secondaryAnimation, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, -1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
                      return SlideTransition(position: offsetAnimation, child: child);
                    },
                  );
                },
              ),
            )),
      ],
    );
  }
}

class _RitualCardData {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final LinearGradient? gradient;

  _RitualCardData({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.gradient,
  });
}

class _RitualCard extends StatelessWidget {
  final _RitualCardData ritual;
  final VoidCallback onTap;

  const _RitualCard({required this.ritual, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: ritual.gradient,
          ),
          child: Row(
            children: [
              Icon(ritual.icon, color: Colors.white, size: 32),
              const SizedBox(width: 18),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ritual.title,
                      style: const TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ritual.subtitle,
                      style: const TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 