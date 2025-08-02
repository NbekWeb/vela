import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles/pages/plan_page_styles.dart';
import 'components/plan_switch.dart';
import 'components/plan_info_card.dart';
import '../shared/widgets/auth.dart';
import '../core/stores/auth_store.dart';

enum PlanStep { choosePlan, dreamLifeIntro }
enum PlanType { annual, monthly }

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  PlanStep _currentStep = PlanStep.choosePlan;
  PlanType _selectedPlan = PlanType.annual;

  void _goToNextStep() {
    setState(() {
      _currentStep = PlanStep.dreamLifeIntro;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title;
    Widget? subtitle;
    Widget child;
    VoidCallback? onBack;

    switch (_currentStep) {
      case PlanStep.choosePlan:
        title = 'Choose your plan';
        subtitle = Column(
          children: [
            Text(
              _selectedPlan == PlanType.annual
                  ? 'First 3 days free, then \$49/year (\$4.08/month)'
                  : 'First 3 days free, then \$9.99/month (\$120/year)',
              style: PlanPageStyles.priceSub,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: PlanSwitch(
                  selected: _selectedPlan,
                  onChanged: (plan) => setState(() => _selectedPlan = plan),
                ),
              ),
            ),
          ],
        );
        child = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            PlanInfoCard(),
            const SizedBox(height: 20),
            // Timeline, matnlar, stepper va h.k.
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Center(
                child: Text(
                  _selectedPlan == PlanType.annual ? '\$49/year' : '\$9.99/month',
                  style: PlanPageStyles.price,
                ),
              ),
            ),
            Center(
              child: Text(
                _selectedPlan == PlanType.annual ? '(\$4.08/month)*' : '(\$120/year)',
                style: PlanPageStyles.priceSub,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: PlanPageStyles.mainButton,
                onPressed: () async {
                  final authStore = context.read<AuthStore>();
                  await authStore.assignFreeTrial();
                  if (!authStore.isLoading && authStore.error == null) {
                    _goToNextStep();
                  }
                },
                child: const Text(
                  'Start my free trial',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
        onBack = null;
        break;
      case PlanStep.dreamLifeIntro:
        title = '';
        subtitle = null;
        child = Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Set sail to your dream life',
                  style: PlanPageStyles.pageTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: PlanPageStyles.cardBg,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'We will set up your profile based on your answers to generate your customized manifesting meditation experience, grounded in neuroscience, and tailored to you.',
                    style: PlanPageStyles.cardBody,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: PlanPageStyles.mainButton,
                    onPressed: () {
                      Navigator.pushNamed(context, '/generator');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue to Dream Life Intake',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        onBack = () {
          setState(() {
            _currentStep = PlanStep.choosePlan;
          });
        };
        break;
    }

    return AuthScaffold(
      title: title,
      subtitle: subtitle,
      onBack: onBack,
      showTerms: _currentStep == PlanStep.choosePlan,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 70),
      child: child,
    );
  }
}
