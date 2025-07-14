import 'package:flutter/material.dart';

class SleepMeditationActionButtons extends StatelessWidget {
  final VoidCallback onResetPressed;
  final VoidCallback onSavePressed;

  const SleepMeditationActionButtons({
    super.key,
    required this.onResetPressed,
    required this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 100, minHeight: 56),
          child: ElevatedButton(
            onPressed: onResetPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh_rounded, color: Colors.blue.shade800, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: onSavePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48),
                ),
                padding: EdgeInsets.zero,
              ),
              child: const Center(
                child: Text(
                  'Save to Dream Vault',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 