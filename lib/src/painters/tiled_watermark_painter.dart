import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A custom painter that tiles a repeated diagonal watermark text across the canvas.
///
/// This painter draws the specified [text] repeatedly in a diagonal pattern,
/// creating a tiled watermark effect with the given [color].
class TiledWatermarkPainter extends CustomPainter {
  /// Creates a [TiledWatermarkPainter] with the given [text] and [color].
  ///
  /// The [text] is the watermark string to be painted repeatedly.
  /// The [color] defines the color of the watermark text.
  TiledWatermarkPainter({required this.text, required this.color});

  /// The watermark text to be painted repeatedly.
  final String? text;

  /// The color of the watermark text.
  final Color color;

  /// Paints the repeated diagonal watermark text on the given [canvas] with the specified [size].
  ///
  /// If [text] is null or empty, nothing is painted.
  @override
  void paint(Canvas canvas, Size size) {
    if (text == null || text!.trim().isEmpty) {
      return;
    }

    final TextPainter tp = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(
              fontSize: 60, fontWeight: FontWeight.bold, color: color)),
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    const double stepY = 200;
    const double stepX = 200;

    for (double y = 0; y < size.height; y += stepY) {
      for (double x = -size.width; x < size.width * 2; x += stepX) {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(-math.pi / 6);
        tp.paint(canvas, Offset.zero);
        canvas.restore();
      }
    }
  }

  /// Determines whether this painter should repaint when [oldDelegate] changes.
  ///
  /// Returns true if the [text] or [color] has changed, indicating that the watermark
  /// appearance needs to be updated.
  @override
  bool shouldRepaint(covariant TiledWatermarkPainter oldDelegate) {
    return oldDelegate.text != text || oldDelegate.color != color;
  }
}
