import 'package:flutter/material.dart';

class VaultStatCard extends StatelessWidget {
  final String value;
  final String? unit;
  final String label;
  final bool unitBelow;
  const VaultStatCard({
    required this.value,
    this.unit,
    required this.label,
    this.unitBelow = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          unitBelow && unit != null
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'Canela',
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.w400,
                        height: 1,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit!,
                      style: const TextStyle(
                        fontFamily: 'Satoshi-Bold',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            fontFamily: 'Canela',
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                        if (unit != null) ...[
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              unit!,
                              style: const TextStyle(
                                fontFamily: 'Satoshi-Bold',
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...label
                    .split('\n')
                    .map(
                      (line) => Text(
                        line.trim(),
                        style: const TextStyle(
                          fontFamily: 'Satoshi-Bold',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 