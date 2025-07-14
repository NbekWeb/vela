import 'package:flutter/material.dart';
import '../step_scaffold.dart';

class GenderStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int currentStep;
  final int totalSteps;
  final int stepperIndex;
  final int stepperCount;
  const GenderStep({
    required this.onNext,
    this.onBack,
    required this.currentStep,
    required this.totalSteps,
    required this.stepperIndex,
    required this.stepperCount,
    Key? key,
  }) : super(key: key);

  @override
  State<GenderStep> createState() => _GenderStepState();
}

class _GenderStepState extends State<GenderStep> {
  int? selectedIndex;
  final List<String> genders = [
    'Female', 'Male', 'Non-binary/Other'
  ];

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      title: 'Gender?',
      onBack: widget.onBack ?? () => Navigator.of(context).pop(),
      onNext: widget.onNext,
      currentStep: widget.currentStep,
      totalSteps: widget.totalSteps,
      nextEnabled: selectedIndex != null,
      stepperIndex: widget.stepperIndex,
      stepperCount: widget.stepperCount,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: _genderButton(0, 'Female')),
              const SizedBox(width: 15),
              Expanded(child: _genderButton(1, 'Male')),
            ],
          ),
          const SizedBox(height: 15),
          _genderButton(2, 'Non-binary/Other', isFullWidth: true),
        ],
      ),
    );
  }

  Widget _genderButton(int i, String label, {bool isFullWidth = false}) {
    final selected = selectedIndex == i;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: isFullWidth ? double.infinity : null,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF152B56).withOpacity(0.10)
              : Colors.transparent,
          border: Border.all(
            color: const Color(0xFF152B56).withOpacity(0.10),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(70),
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              fontSize: 17,
              color: selected ? Colors.white : const Color(0xFFF2EFEA),
            ),
          ),
        ),
      ),
    );
  }
} 