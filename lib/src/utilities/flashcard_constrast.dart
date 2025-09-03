import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Utilities for contrast decisioning and luminance math.
class FlashcardContrast {
  // coverage:ignore-start
  FlashcardContrast._();
  // coverage:ignore-end

  /// Returns the best foreground (black/white) against [background] using WCAG contrast ratio.
  static Color bestForegroundOn(Color background) {
    final double bgLum = _relativeLuminance(background);
    const Color black = Colors.black;
    const Color white = Colors.white;
    final double blackContrast =
        _contrastRatio(bgLum, _relativeLuminance(black));
    final double whiteContrast =
        _contrastRatio(bgLum, _relativeLuminance(white));
    return whiteContrast >= blackContrast ? white : black;
  }

  static double _relativeLuminance(Color color) {
    // Use Flutter's internal method for accuracy if available.
    // Compute from linearized sRGB if needed.
    return color.computeLuminance();
  }

  static double _contrastRatio(double lumA, double lumB) {
    final double l1 = math.max(lumA, lumB);
    final double l2 = math.min(lumA, lumB);
    return (l1 + 0.05) / (l2 + 0.05);
  }
}
