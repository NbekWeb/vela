import 'package:flutter/material.dart';
import '../../shared/widgets/starter_modal.dart';

class StepScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final int currentStep;
  final int totalSteps;
  final bool showInfo;
  final VoidCallback? onInfo;
  final bool nextEnabled;
  final String? nextLabel;
  final bool showStepper;
  final bool showTitles;
  final int? stepperIndex;
  final int? stepperCount;

  const StepScaffold({
    super.key,
    required this.title,
    required this.child,
    this.onBack,
    this.onNext,
    required this.currentStep,
    required this.totalSteps,
    this.showInfo = true,
    this.onInfo,
    this.nextEnabled = true,
    this.nextLabel,
    this.showStepper = true,
    this.showTitles = true,
    this.stepperIndex,
    this.stepperCount,
  });

  @override
  Widget build(BuildContext context) {
    void showInfoPopover() {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Starter",
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: Alignment.topCenter,
            child: StarterModal(onClose: () => Navigator.of(context).pop()),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
            child: child,
          );
        },
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: [
          // Back button yuqorida, status bar ostidan 4px pastroqda
          Positioned(
            top: MediaQuery.of(context).padding.top + 4,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack,
            ),
          ),
          // Info button yuqorida, status bar ostidan 4px pastroqda (REMOVE THIS)
          // Positioned(
          //   top: MediaQuery.of(context).padding.top + 4,
          //   right: 0,
          //   child: IconButton(
          //     icon: const Icon(Icons.info_outline, color: Colors.white, size: 30),
          //     onPressed: onInfo ?? showInfoPopover,
          //   ),
          // ),
          // Asosiy content
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 4),
              // Back, Stepper, Info icon bitta qatorda
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: onBack,
                  ),
                  if (showStepper && stepperIndex != null && stepperCount != null)
                    Expanded(
                      child: Center(
                        child: _StepperIndicator(
                          currentStep: stepperIndex!,
                          totalSteps: stepperCount!,
                        ),
                      ),
                    ),
                  if (!showStepper || stepperIndex == null || stepperCount == null)
                    Spacer(), // yoki SizedBox(width: 48),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.white, size: 30),
                    onPressed: onInfo ?? showInfoPopover,
                  ),
                ],
              ),
              if (showTitles) ...[
                const Text(
                  'Dream life intake',
                  style: TextStyle(
                    fontFamily: 'Canela',
                    fontWeight: FontWeight.w400,
                    fontSize: 32,
                    color: Color(0xFFF2EFEA),
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  'The Vision Builder',
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFFF2EFEA),
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Canela',
                          fontWeight: FontWeight.w300,
                          fontSize: 36,
                          color: Color(0xFFF2EFEA),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      child,
                    ],
                  ),
                ),
              ),
              if (onNext != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: nextEnabled ? onNext : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return const Color(0xFF3B6EAA).withAlpha(80);
                            }
                            return const Color(0xFF3B6EAA);
                          },
                        ),
                        foregroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors.white.withOpacity(0.7);
                            }
                            return Colors.white;
                          },
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            nextLabel ?? 'Next',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepperIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const _StepperIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (i) {
        final isActive = i == currentStep;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 2.5), // 5px gap between indicators
          width: 35,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
} 