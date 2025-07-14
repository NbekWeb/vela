import 'dart:ui';
import 'package:flutter/material.dart';
import '../themes/app_styles.dart';
import 'svg_icon.dart';
import 'generating_meditation.dart';

class RitualInfoModal extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback? onClose;
  const RitualInfoModal({super.key, required this.title, required this.body, this.onClose});

  @override
  Widget build(BuildContext context) {
    final double modalWidth = MediaQuery.of(context).size.width * 0.92;

    return Center(
      child: ClipRRect(
        borderRadius: AppStyles.radiusMedium,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            width: modalWidth,
            padding: AppStyles.paddingModal,
            decoration: AppStyles.frostedGlass,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppStyles.white, size: 28),
                          onPressed: onClose ?? () => Navigator.of(context).pop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        Expanded(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: AppStyles.headingMedium,
                          ),
                        ),
                        Opacity(
                          opacity: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: null,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                AppStyles.spacingMedium,
                Text(
                  body,
                  style: AppStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                AppStyles.spacingLarge,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                    style: AppStyles.modalButton,
                    child: Text(
                      'Continue',
                      style: AppStyles.buttonTextSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomizeRitualModal extends StatefulWidget {
  final VoidCallback? onClose;
  const CustomizeRitualModal({super.key, this.onClose});

  @override
  State<CustomizeRitualModal> createState() => _CustomizeRitualModalState();
}

class _CustomizeRitualModalState extends State<CustomizeRitualModal> {
  String ritualType = 'Guided meditations';
  String tone = 'Dreamy';
  String voice = 'Calm Male';
  int duration = 5;

  final List<String> ritualTypes = [
    'Guided meditations',
    'Music only',
    'Nature sounds',
  ];
  final List<String> tones = [
    'Dreamy',
    'Uplifting',
    'Calm',
  ];
  final List<String> voices = [
    'Calm Male',
    'Calm Female',
    'Energetic',
  ];
  final List<int> durations = [2, 5, 10];

  @override
  Widget build(BuildContext context) {
    final double modalWidth = MediaQuery.of(context).size.width * 0.92;
    return Center(
      child: ClipRRect(
        borderRadius: AppStyles.radiusMedium,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            width: modalWidth,
            padding: AppStyles.paddingModal,
            decoration: AppStyles.frostedGlass,
            child: Material(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: AppStyles.white, size: 28),
                              onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const Expanded(
                              child: Text(
                                'Customize Ritual',
                                textAlign: TextAlign.center,
                                style: AppStyles.headingMedium,
                              ),
                            ),
                            Opacity(
                              opacity: 0,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: null,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    AppStyles.spacingMedium,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Ritual Type', style: AppStyles.bodyMedium),
                    ),
                    const SizedBox(height: 8),
                    _StyledDropdown<String>(
                      value: ritualType,
                      items: ritualTypes,
                      onChanged: (v) => setState(() => ritualType = v!),
                    ),
                    AppStyles.spacingSmall,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Choose your tone', style: AppStyles.bodyMedium),
                    ),
                    const SizedBox(height: 8),
                    _StyledDropdown<String>(
                      value: tone,
                      items: tones,
                      onChanged: (v) => setState(() => tone = v!),
                    ),
                    AppStyles.spacingSmall,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Choose your voice', style: AppStyles.bodyMedium),
                    ),
                    const SizedBox(height: 8),
                    _StyledDropdown<String>(
                      value: voice,
                      items: voices,
                      onChanged: (v) => setState(() => voice = v!),
                    ),
                    AppStyles.spacingSmall,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Duration', style: AppStyles.bodyMedium),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: durations.map((d) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: duration == d ? AppStyles.primaryBlue : AppStyles.transparentWhite,
                              foregroundColor: AppStyles.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () => setState(() => duration = d),
                            child: Text('$d min', style: AppStyles.buttonTextSmall),
                          ),
                        ),
                      )).toList(),
                    ),
                    AppStyles.spacingLarge,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                body: GeneratingMeditation(),
                              ),
                            ),
                          );
                        },
                        style: AppStyles.modalButton,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Generate My Meditation', style: AppStyles.buttonTextSmall),
                            SizedBox(width: 12),
                            Image.asset(
                              'assets/img/star.png',
                              width: 22, 
                              height: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StyledDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  const _StyledDropdown({required this.value, required this.items, required this.onChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.transparentWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: AppStyles.white),
        dropdownColor: const Color(0xCC3B6EAA),
        style: AppStyles.buttonTextSmall,
        borderRadius: BorderRadius.circular(16),
        items: items.map((e) => DropdownMenuItem<T>(
          value: e,
          child: Text(e.toString(), style: AppStyles.buttonTextSmall),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }
} 