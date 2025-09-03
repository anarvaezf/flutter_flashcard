import 'package:colored_flashcard/src/enums/flashcard_background_style.dart';
import 'package:colored_flashcard/src/enums/flashcard_flip_behavior.dart';
import 'package:colored_flashcard/src/painters/tiled_watermark_painter.dart';
import 'package:colored_flashcard/src/widgets/card_side.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("CardSide", () {
    testWidgets('CardSide renders text and semantics label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 200,
              child: CardSide(
                text: 'Question text',
                background: Colors.amber,
                foreground: Colors.black,
                backgroundStyle: FlashcardBackgroundStyle.solid,
                watermarkText: null,
                textStyle: TextStyle(fontSize: 24),
                autoFitText: true,
                minFontSize: 12,
                maxLines: 2,
                borderRadius: 12,
                elevation: 1,
                padding: EdgeInsets.all(8),
                semanticsLabel: 'Flashcard, question side',
                flipBehavior: FlashcardFlipBehavior.tap,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Question text'), findsOneWidget);
    });

    testWidgets(
        'CardSide with pattern paints TiledWatermarkPainter when watermark is non-empty',
        (tester) async {
      const foreground = Colors.black;
      const wmText = 'WATERMARK';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 200,
              child: CardSide(
                text: 'Question text',
                background: Colors.amber,
                foreground: foreground,
                backgroundStyle: FlashcardBackgroundStyle.pattern,
                watermarkText: wmText,
                textStyle: TextStyle(fontSize: 24),
                autoFitText: true,
                minFontSize: 12,
                maxLines: 2,
                borderRadius: 12,
                elevation: 1,
                padding: EdgeInsets.all(8),
                semanticsLabel: 'Flashcard, question side',
                flipBehavior: FlashcardFlipBehavior.tap,
              ),
            ),
          ),
        ),
      );
      final finder = find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is TiledWatermarkPainter,
      );
      expect(finder, findsOneWidget);

      final customPaint = tester.widget<CustomPaint>(finder);
      final painter = customPaint.painter! as TiledWatermarkPainter;

      expect(painter.text, wmText);

      expect(painter.color, foreground.withAlpha(30));
    });

    testWidgets(
        'CardSide with pattern does NOT paint watermark when watermark is empty or null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 200,
              child: CardSide(
                text: 'No watermark',
                background: Colors.amber,
                foreground: Colors.black,
                backgroundStyle: FlashcardBackgroundStyle.pattern,
                watermarkText: '', // empty
                textStyle: TextStyle(fontSize: 24),
                autoFitText: true,
                minFontSize: 12,
                maxLines: 2,
                borderRadius: 12,
                elevation: 1,
                padding: EdgeInsets.all(8),
                semanticsLabel: 'Flashcard, question side',
                flipBehavior: FlashcardFlipBehavior.tap,
              ),
            ),
          ),
        ),
      );

      var finder = find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is TiledWatermarkPainter,
      );
      expect(finder, findsOneWidget);

      var customPaint = tester.widget<CustomPaint>(finder);
      var painter = customPaint.painter! as TiledWatermarkPainter;

      expect(painter.text, isNull);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 200,
              child: CardSide(
                text: 'No watermark',
                background: Colors.amber,
                foreground: Colors.black,
                backgroundStyle: FlashcardBackgroundStyle.pattern,
                watermarkText: null, // null
                textStyle: TextStyle(fontSize: 24),
                autoFitText: true,
                minFontSize: 12,
                maxLines: 2,
                borderRadius: 12,
                elevation: 1,
                padding: EdgeInsets.all(8),
                semanticsLabel: 'Flashcard, question side',
                flipBehavior: FlashcardFlipBehavior.tap,
              ),
            ),
          ),
        ),
      );

      finder = find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is TiledWatermarkPainter,
      );
      expect(finder, findsOneWidget);

      customPaint = tester.widget<CustomPaint>(finder);
      painter = customPaint.painter! as TiledWatermarkPainter;

      expect(painter.text, isNull);
    });
  });
}
