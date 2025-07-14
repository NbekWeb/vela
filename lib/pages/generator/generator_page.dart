import 'package:flutter/material.dart';
import 'package:vela/shared/widgets/stars_animation.dart';
import 'steps/age_step.dart';
import 'steps/gender_step.dart';
import 'steps/goals_step.dart';
import 'steps/vision_step.dart';
import 'steps/happy_step.dart';
import 'steps/ritual_step.dart';
import 'zero_generator.dart';

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  int _currentStep = 0;
  static const int _totalSteps = 7;
  static const int _stepperCount = 5;

  void _goToNextStep() {
    setState(() {
      if (_currentStep < _totalSteps - 1) {
        _currentStep++;
      }
    });
  }

  void _goToPreviousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  void _goToZeroGenerator() {
    setState(() {
      _currentStep = 0;
    });
  }

  List<Widget> get _steps => [
        ZeroGenerator(
          onNext: _goToNextStep,
        ),
        AgeStep(
          onNext: _goToNextStep,
          onBack: _goToZeroGenerator,
          currentStep: 1,
          totalSteps: _totalSteps,
          stepperIndex: 0,
          stepperCount: _stepperCount,
        ),
        GenderStep(
          onNext: _goToNextStep,
          onBack: _goToPreviousStep,
          currentStep: 2,
          totalSteps: _totalSteps,
          stepperIndex: 1,
          stepperCount: _stepperCount,
        ),
        GoalsStep(
          onNext: _goToNextStep,
          onBack: _goToPreviousStep,
          currentStep: 3,
          totalSteps: _totalSteps,
          stepperIndex: 2,
          stepperCount: _stepperCount,
        ),
        VisionStep(
          onNext: _goToNextStep,
          onBack: _goToPreviousStep,
          currentStep: 4,
          totalSteps: _totalSteps,
          stepperIndex: 3,
          stepperCount: _stepperCount,
        ),
        HappyStep(
          onBack: _goToPreviousStep,
          currentStep: 5,
          totalSteps: _totalSteps,
          onNext: _goToNextStep,
          stepperIndex: 4,
          stepperCount: _stepperCount,
        ),
        RitualStep(
          onBack: _goToPreviousStep,
          currentStep: 6,
          totalSteps: _totalSteps,
          showStepper: false, // indikator ko‘rinmasin
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const StarsAnimation(),
          Center(
            child: _steps[_currentStep],
          ),
        ],
      ),
    );
  }
} 