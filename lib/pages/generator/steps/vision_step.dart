import 'package:flutter/material.dart';
import '../../../shared/models/meditation_profile_data.dart';
import '../../../core/stores/meditation_store.dart';
import '../step_scaffold.dart';
import 'package:provider/provider.dart';

class VisionStep extends StatefulWidget {
  final MeditationProfileData profileData;
  final Function(MeditationProfileData) onProfileDataChanged;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int currentStep;
  final int totalSteps;
  final int stepperIndex;
  final int stepperCount;
  const VisionStep({
    required this.profileData,
    required this.onProfileDataChanged,
    required this.onNext,
    this.onBack,
    required this.currentStep,
    required this.totalSteps,
    required this.stepperIndex,
    required this.stepperCount,
    super.key,
  });

  @override
  State<VisionStep> createState() => _VisionStepState();
}

class _VisionStepState extends State<VisionStep> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Avvalgi qiymatni ko‘rsatish uchun
    if (widget.profileData.dream != null && widget.profileData.dream!.isNotEmpty) {
      _controller.text = widget.profileData.dream!.join(', ');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDreamChanged(String value) {
    // Faqat bitta matn bo'lsa ham, uni listga o'rab saqlaymiz
    final dreams = value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    
    // Update local profile data
    final updatedProfile = widget.profileData.copyWith(dream: dreams);
    widget.onProfileDataChanged(updatedProfile);
    
                        // Save to store
                    final meditationStore = Provider.of<MeditationStore>(context, listen: false);
                    meditationStore.setMeditationProfile(updatedProfile);
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      title: '',
      onBack: widget.onBack,
      onNext: widget.onNext,
      currentStep: widget.currentStep,
      totalSteps: widget.totalSteps,
      nextEnabled: _controller.text.trim().isNotEmpty,
      stepperIndex: widget.stepperIndex,
      stepperCount: widget.stepperCount,
      // Faqat content scroll bo'ladi!
      child: Expanded(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Tell me about your dream life',
                  style: TextStyle(
                    fontFamily: 'Canela',
                    fontWeight: FontWeight.w300,
                    fontSize: 36,
                    color: Color(0xFFF2EFEA),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tell me about your dream life',
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xFFF2EFEA),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: _controller,
                    minLines: 3,
                    maxLines: 6,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Satoshi',
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
                      hintText: 'I see living in a cozy house and I am waking up with energy...',
                      hintStyle: const TextStyle(color: Color(0xFFB0B8C1)),
                      filled: true,
                      fillColor: Color(0x152B561A),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0x152B561A),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF152B56),
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    onChanged: _onDreamChanged,
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