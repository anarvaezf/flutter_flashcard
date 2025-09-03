import 'package:flutter/material.dart';

/// A widget that automatically adjusts the font size of the given text
/// to fit within its constraints, optionally limiting the number of lines.
///
/// When [autoFit] is true, the widget attempts to find the largest font size
/// between [minFontSize] and the style's font size that fits within the available space.
/// Otherwise, it displays the text with the provided style without resizing.
class AutoFitText extends StatelessWidget {
  /// Creates an [AutoFitText] widget.
  ///
  /// The [text], [style], [autoFit], [minFontSize], [maxLines], and [textAlign]
  /// parameters must not be null.
  const AutoFitText({
    super.key,
    required this.text,
    required this.style,
    required this.autoFit,
    required this.minFontSize,
    required this.maxLines,
    required this.textAlign,
  });

  /// The text to display.
  final String text;

  /// The base text style to use for rendering.
  /// The font size in this style is used as the maximum font size when auto-fitting.
  final TextStyle style;

  /// Whether to automatically adjust the font size to fit the available space.
  final bool autoFit;

  /// The minimum font size to use when auto-fitting.
  final double minFontSize;

  /// The maximum number of lines to display.
  final int maxLines;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// Builds the widget, adjusting the font size to fit the text within the layout constraints
  /// if [autoFit] is true, otherwise displaying the text with the given style.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (!autoFit) {
        return Text(
          text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        );
      }

      final double maxW = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : double.infinity;
      final double maxH = constraints.maxHeight.isFinite
          ? constraints.maxHeight
          : double.infinity;

      double low = minFontSize;
      double high = style.fontSize ?? 48;
      high = high < low ? low : high;

      bool fits(double size) {
        final TextPainter painter = TextPainter(
          text: TextSpan(text: text, style: style.copyWith(fontSize: size)),
          textDirection: TextDirection.ltr,
          textAlign: textAlign,
          maxLines: maxLines,
          ellipsis: '…',
        )..layout(maxWidth: maxW);
        final bool overflow = painter.didExceedMaxLines ||
            painter.width > maxW ||
            painter.height > maxH;
        return !overflow;
      }

      double best = low;
      for (int i = 0; i < 12; i++) {
        final double mid = (low + high) / 2;
        if (fits(mid)) {
          best = mid;
          low = mid + 0.5;
        } else {
          high = mid - 0.5;
        }
        if ((high - low).abs() < 0.75) break;
      }
      best = best.clamp(minFontSize, style.fontSize ?? 48);

      return Text(
        text,
        style: style.copyWith(fontSize: best),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      );
    });
  }
}
