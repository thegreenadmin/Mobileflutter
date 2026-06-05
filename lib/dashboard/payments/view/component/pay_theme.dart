import 'package:flutter/material.dart';

/// Design tokens for the Payments module, per the spec (sections 3.1–3.3).
/// Kept local so the payment screens match the supplied mockups exactly.
class PayTheme {
  // Colors (3.3)
  static const accent = Color(0xFF12B5EA);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const background = Color(0xFFF8F9FC);
  static const cardSurface = Color(0xFFFFFFFF);
  static const primaryText = Color(0xFF111827);
  static const secondaryText = Color(0xFF6B7280);
  static const divider = Color(0xFFEAECF0);

  // Layout (3.1)
  static const double hPad = 20;
  static const double sectionGap = 24;
  static const double itemGap = 16;
  static const double cardRadius = 20;
  static const double inputHeight = 56;
  static const double buttonHeight = 52;

  // Typography (3.2)
  static const largeHeader =
      TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryText);
  static const screenTitle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: primaryText);
  static const cardTitle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryText);
  static const body = TextStyle(fontSize: 16, color: primaryText);
  static const bodyMuted = TextStyle(fontSize: 16, color: secondaryText);
  static const label =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: secondaryText);
  static const caption = TextStyle(fontSize: 12, color: secondaryText);
}
