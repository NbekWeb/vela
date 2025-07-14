import 'package:flutter/material.dart';
import '../step_scaffold.dart';

class HappyStep extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final int currentStep;
  final int totalSteps;
  final int stepperIndex;
  final int stepperCount;
  const HappyStep({
    this.onBack,
    this.onNext,
    required this.currentStep,
    required this.totalSteps,
    required this.stepperIndex,
    required this.stepperCount,
    super.key,
  });

  @override
  State<HappyStep> createState() => _HappyStepState();
}

class _HappyStepState extends State<HappyStep> {
  final TextEditingController _controller = TextEditingController();
  bool _nextEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _nextEnabled = _controller.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      title: 'What makes you happy?',
      onBack: widget.onBack,
      onNext: widget.onNext,
      currentStep: widget.currentStep,
      totalSteps: widget.totalSteps,
      nextEnabled: _controller.text.trim().isNotEmpty,
      stepperIndex: widget.stepperIndex,
      stepperCount: widget.stepperCount,
      child: Column(
        children: [
          const Text(
            'What makes you feel the most "you"?',
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Color(0xFFF2EFEA),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _controller,
            minLines: 5,
            maxLines: 8,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Satoshi',
              fontSize: 12,
            ),
            decoration: InputDecoration(
              hintText: 'I feel most myself when I laugh freely, make art, and spend time in nature.',
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
          ),
        ],
      ),
    );
  }
} 