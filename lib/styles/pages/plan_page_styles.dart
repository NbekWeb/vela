import 'package:flutter/material.dart';

class PlanPageStyles {
  static const Color pillBg = Color(0x333B6EAA);
  static const Color pillBorder = Color(0x33FFFFFF);
  static const Color badgeText = Color(0xFFF2EFEA);
  static const Color cardBg = Color(0x80A4C7EA);
  static const Color bullet = Color(0xFFB6D0F7);
  static const Color leftBorder = Color(0xFFC9DFF4);

  static const TextStyle badge = TextStyle(
    color: badgeText,
    fontWeight: FontWeight.bold,
    fontSize: 12,
    fontFamily: 'Satoshi',
  );

  static const TextStyle pill = TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle cardTitle = TextStyle(
    color: Colors.white,
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const TextStyle cardBody = TextStyle(
    color: Color(0xFFDCE6F0),
    fontSize: 14,
    fontFamily: 'Satoshi',
  );

  static const TextStyle cardSection = TextStyle(
    color: Colors.white,
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  static const TextStyle price = TextStyle(
    color: Colors.white,
    fontFamily: 'Canela',
    fontSize: 32,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle priceSub = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 16,
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700
  );

  static final ButtonStyle mainButton = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF3B6EAA),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
  );

  static const TextStyle pageTitle = TextStyle(
    color: Colors.white,
    fontFamily: 'Canela',
    fontSize: 36,
    fontWeight: FontWeight.w700,
  );

  static const LinearGradient badgeBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF54A0ED), // start color
      Color(0xFF9ECFFF), // end color
    ],
  );

}