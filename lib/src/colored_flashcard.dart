import 'package:colored_flashcard/src/enums/flashcard_background_style.dart';
import 'package:colored_flashcard/src/enums/flashcard_flip_behavior.dart';
import 'package:colored_flashcard/src/utilities/flashcard_constrast.dart';
import 'package:colored_flashcard/src/widgets/card_side.dart';
import 'package:flutter/material.dart';

/// A lightweight, accessible ColoredFlashcard widget for Q&A content.
///
/// This widget displays a question on the front and an answer on the back.
/// It supports flipping interactions, automatic text contrast, optional
/// watermarks, and built-in text auto-fit.
///
/// ### Features
/// - Flip on tap or swipe (configurable via [FlashcardFlipBehavior]).
/// - Automatic foreground text contrast (WCAG-based).
/// - Optional tiled diagonal watermark via [CustomPainter].
/// - Built-in text auto-fit (no external dependencies).
/// - Null safety, minimal API surface.
///
/// ### Example
/// ```dart
/// ColoredFlashcard(
///   questionText: 'What is the capital of France?',
///   answerText: 'Paris',
///   frontColor: Colors.amber,
///   backColor: Colors.teal,
///   flipBehavior: FlashcardFlipBehavior.tap,
///   backgroundStyle: FlashcardBackgroundStyle.pattern,
///   watermarkTextFront: 'Question',
///   watermarkTextBack: 'Answer',
/// )
/// ```
///
/// This widget is stateful because it manages the "flipped" state internally.
/// If you need to control the state externally, consider wrapping this widget
/// and exposing your own controller pattern.
class ColoredFlashcard extends StatefulWidget {
  const ColoredFlashcard({
    super.key,
    required this.questionText,
    required this.answerText,
    required this.frontColor,
    this.backColor,
    this.flipBehavior = FlashcardFlipBehavior.tap,
    this.backgroundStyle = FlashcardBackgroundStyle.solid,
    this.watermarkTextFront,
    this.watermarkTextBack,
    this.autoForegroundColor = true,
    this.questionTextStyle,
    this.answerTextStyle,
    this.autoFitText = true,
    this.minFontSize = 16,
    this.maxLines = 10,
    this.borderRadius = 16,
    this.elevation = 2,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  })  : assert(minFontSize > 0, 'minFontSize must be > 0'),
        assert(maxLines > 0, 'maxLines must be > 0'),
        assert(borderRadius >= 0, 'borderRadius must be >= 0'),
        assert(elevation >= 0, 'elevation must be >= 0');

  /// The question text shown on the front side.
  final String questionText;

  /// The answer text shown on the back side.
  final String answerText;

  /// Front background color.
  final Color frontColor;

  /// Back background color (defaults to slightly adjusted [frontColor] if null).
  final Color? backColor;

  /// How the card flips (tap/swipe/none).
  final FlashcardFlipBehavior flipBehavior;

  /// Background style (solid vs pattern).
  final FlashcardBackgroundStyle backgroundStyle;

  /// Optional watermark text on the front (question) side.
  final String? watermarkTextFront;

  /// Optional watermark text on the back (answer) side.
  final String? watermarkTextBack;

  /// If true, automatically choose black/white text for best contrast.
  final bool autoForegroundColor;

  /// Custom text style for the question. Color may be overridden by auto-contrast.
  final TextStyle? questionTextStyle;

  /// Custom text style for the answer. Color may be overridden by auto-contrast.
  final TextStyle? answerTextStyle;

  /// If true, the text auto-fits within available space (down to [minFontSize]).
  final bool autoFitText;

  /// Minimum font size used by the auto-fit algorithm.
  final double minFontSize;

  /// Maximum number of lines used when rendering text.
  final int maxLines;

  /// Card border radius.
  final double borderRadius;

  /// Material elevation.
  final double elevation;

  /// Inner padding for text content.
  final EdgeInsetsGeometry padding;

  @override
  State<ColoredFlashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<ColoredFlashcard> {
  bool _flipped = false;

  Color get _frontFg => widget.autoForegroundColor
      ? FlashcardContrast.bestForegroundOn(widget.frontColor)
      : _explicitOrDefaultColor(widget.questionTextStyle);

  Color get _backFg {
    final Color bg = widget.backColor ?? _derivedBackColor(widget.frontColor);
    return widget.autoForegroundColor
        ? FlashcardContrast.bestForegroundOn(bg)
        : _explicitOrDefaultColor(widget.answerTextStyle);
  }

  static Color _explicitOrDefaultColor(TextStyle? style) =>
      style?.color ?? Colors.black;

  static Color _derivedBackColor(Color base) {
    final hsl = HSLColor.fromColor(base);
    // Slightly adjust lightness to differentiate sides.
    final adjusted = hsl.withLightness((hsl.lightness * 0.9).clamp(0.0, 1.0));
    return adjusted.toColor();
  }

  void _flip() {
    if (widget.flipBehavior == FlashcardFlipBehavior.none) return;
    setState(() => _flipped = !_flipped);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (widget.flipBehavior != FlashcardFlipBehavior.horizontalSwipe) return;
    final double vx = details.velocity.pixelsPerSecond.dx;
    if (vx.abs() > 100) {
      _flip();
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (widget.flipBehavior != FlashcardFlipBehavior.verticalSwipe) return;
    final double vy = details.velocity.pixelsPerSecond.dy;
    if (vy.abs() > 100) {
      _flip();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backBg =
        widget.backColor ?? _derivedBackColor(widget.frontColor);

    final Widget front = CardSide(
      text: widget.questionText,
      background: widget.frontColor,
      foreground: _frontFg,
      backgroundStyle: widget.backgroundStyle,
      watermarkText: widget.watermarkTextFront,
      textStyle: widget.questionTextStyle,
      autoFitText: widget.autoFitText,
      minFontSize: widget.minFontSize,
      maxLines: widget.maxLines,
      borderRadius: widget.borderRadius,
      elevation: widget.elevation,
      padding: widget.padding,
      semanticsLabel: 'Flashcard, question side',
      flipBehavior: widget.flipBehavior,
    );

    final Widget back = CardSide(
      text: widget.answerText,
      background: backBg,
      foreground: _backFg,
      backgroundStyle: widget.backgroundStyle,
      watermarkText: widget.watermarkTextBack,
      textStyle: widget.answerTextStyle,
      autoFitText: widget.autoFitText,
      minFontSize: widget.minFontSize,
      maxLines: widget.maxLines,
      borderRadius: widget.borderRadius,
      elevation: widget.elevation,
      padding: widget.padding,
      semanticsLabel: 'Flashcard, answer side',
      flipBehavior: widget.flipBehavior,
    );

    final Widget child = _flipped ? back : front;

    final bool tappable = widget.flipBehavior == FlashcardFlipBehavior.tap;

    return Semantics(
      button: widget.flipBehavior != FlashcardFlipBehavior.none,
      label: _flipped ? 'Flashcard: answer shown' : 'Flashcard: question shown',
      hint: switch (widget.flipBehavior) {
        FlashcardFlipBehavior.none => 'No flip interaction.',
        FlashcardFlipBehavior.tap => 'Double tap or tap to flip.',
        FlashcardFlipBehavior.verticalSwipe => 'Swipe up or down to flip.',
        FlashcardFlipBehavior.horizontalSwipe => 'Swipe left or right to flip.',
      },
      onTap: tappable ? _flip : null,
      child: GestureDetector(
        onTap: tappable ? _flip : null,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        onVerticalDragEnd: _onVerticalDragEnd,
        behavior: HitTestBehavior.opaque,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (widget, animation) =>
              FadeTransition(opacity: animation, child: widget),
          layoutBuilder: (currentChild, previousChildren) =>
              Stack(children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ]),
          child: SizedBox.expand(key: ValueKey<bool>(_flipped), child: child),
        ),
      ),
    );
  }
}
