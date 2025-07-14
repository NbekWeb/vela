import 'package:flutter/material.dart';
import '../step_scaffold.dart';

class VisionStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int currentStep;
  final int totalSteps;
  final int stepperIndex;
  final int stepperCount;
  const VisionStep({
    required this.onNext,
    this.onBack,
    required this.currentStep,
    required this.totalSteps,
    required this.stepperIndex,
    required this.stepperCount,
    Key? key,
  }) : super(key: key);

  @override
  State<VisionStep> createState() => _VisionStepState();
}

class _VisionStepState extends State<VisionStep> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      title: 'Tell me about your dream life',
      onBack: widget.onBack,
      onNext: widget.onNext,
      currentStep: widget.currentStep,
      totalSteps: widget.totalSteps,
      nextEnabled: _controller.text.trim().isNotEmpty,
      stepperIndex: widget.stepperIndex,
      stepperCount: widget.stepperCount,
      child: Column(
        children: [
          const SizedBox(height: 32),
          TextField(
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
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }
} 