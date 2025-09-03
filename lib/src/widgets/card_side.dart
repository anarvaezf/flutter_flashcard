import 'package:colored_flashcard/src/enums/flashcard_background_style.dart';
import 'package:colored_flashcard/src/enums/flashcard_flip_behavior.dart';
import 'package:colored_flashcard/src/painters/tiled_watermark_painter.dart';
import 'package:colored_flashcard/src/widgets/auto_fit_text.dart';
import 'package:flutter/material.dart';

/// Widget used by [Flashcard] to render each side of the card.
class CardSide extends StatelessWidget {
  /// Creates a widget that displays one side of a flashcard.
  const CardSide({
    super.key,
    required this.text,
    required this.background,
    required this.foreground,
    required this.backgroundStyle,
    required this.watermarkText,
    required this.textStyle,
    required this.autoFitText,
    required this.minFontSize,
    required this.maxLines,
    required this.borderRadius,
    required this.elevation,
    required this.padding,
    required this.semanticsLabel,
    required this.flipBehavior,
  });

  /// The main text displayed on this side of the card.
  final String text;

  /// The background color of the card side.
  final Color background;

  /// The foreground color, typically used for text and patterns.
  final Color foreground;

  /// The style of the card background (solid or patterned).
  final FlashcardBackgroundStyle backgroundStyle;

  /// Optional watermark text displayed in a tiled pattern behind the main text.
  final String? watermarkText;

  /// The text style applied to the main text.
  final TextStyle? textStyle;

  /// Whether the text should automatically fit within the available space.
  final bool autoFitText;

  /// The minimum font size to use when auto-fitting text.
  final double minFontSize;

  /// The maximum number of lines allowed for the main text.
  final int maxLines;

  /// The border radius applied to the card's corners.
  final double borderRadius;

  /// The elevation (shadow depth) of the card.
  final double elevation;

  /// Padding around the main text inside the card.
  final EdgeInsetsGeometry padding;

  /// Semantic label used for accessibility to describe this side of the card.
  final String semanticsLabel;

  /// The flip behavior controlling interactivity and accessibility semantics.
  final FlashcardFlipBehavior flipBehavior;

  /// Builds the widget tree for this card side, including background,
  /// text content, and accessibility semantics.
  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = (textStyle ??
            Theme.of(context).textTheme.displayLarge ??
            const TextStyle(fontSize: 36))
        .copyWith(color: foreground, fontWeight: FontWeight.bold);

    final Widget content = Padding(
      padding: padding,
      child: Center(
        child: AutoFitText(
          text: text,
          style: baseStyle,
          autoFit: autoFitText,
          minFontSize: minFontSize,
          maxLines: maxLines,
          textAlign: TextAlign.center,
        ),
      ),
    );

    final Widget painted = switch (backgroundStyle) {
      FlashcardBackgroundStyle.solid => content,
      FlashcardBackgroundStyle.pattern => Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: TiledWatermarkPainter(
                text: (watermarkText ?? '').isEmpty ? null : watermarkText,
                color: foreground.withAlpha(30),
              ),
            ),
            content,
          ],
        ),
    };

    return ExcludeSemantics(
      excluding: false,
      child: Material(
        color: background,
        elevation: elevation,
        borderRadius: BorderRadius.circular(borderRadius),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Semantics(
            label: semanticsLabel,
            // Present as a control only when interactive.
            button: flipBehavior != FlashcardFlipBehavior.none,
            child: painted,
          ),
        ),
      ),
    );
  }
}
