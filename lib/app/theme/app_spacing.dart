import 'package:flutter/widgets.dart';

/// Spacing / radius / elevation design tokens.
///
/// Use these instead of loose numeric literals so vertical rhythm and corner
/// language stay consistent across every screen. Scale: 4 / 8 / 16 / 24 / 32 / 40.
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;

  /// Standard horizontal page gutter.
  static const double gutter = 20;

  static const SizedBox gapXs = SizedBox(height: xs);
  static const SizedBox gapSm = SizedBox(height: sm);
  static const SizedBox gapMd = SizedBox(height: md);
  static const SizedBox gapLg = SizedBox(height: lg);
  static const SizedBox gapXl = SizedBox(height: xl);
}

/// Corner radii. Larger surfaces read calmer; smaller controls read tappable.
class AppRadius {
  const AppRadius._();

  static const double card = 24;
  static const double tile = 12;
  static const double button = 14;
  static const double pill = 999;

  static BorderRadius get cardBr => BorderRadius.circular(card);
  static BorderRadius get tileBr => BorderRadius.circular(tile);
  static BorderRadius get buttonBr => BorderRadius.circular(button);
  static BorderRadius get pillBr => BorderRadius.circular(pill);
}
