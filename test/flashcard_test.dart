import 'package:colored_flashcard/colored_flashcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('barrel exposes public API types', () {
    const FlashcardFlipBehavior flip = FlashcardFlipBehavior.tap;
    const FlashcardBackgroundStyle bg = FlashcardBackgroundStyle.pattern;
    expect(flip, FlashcardFlipBehavior.tap);
    expect(bg, FlashcardBackgroundStyle.pattern);
    final Color onBlack = FlashcardContrast.bestForegroundOn(Colors.black);
    expect(onBlack, Colors.white);
  });

  testWidgets('barrel import is enough to render Flashcard', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 200,
            child: ColoredFlashcard(
              questionText: 'Q: Capital of France?',
              answerText: 'A: Paris',
              frontColor: Colors.amber,
              backColor: Colors.teal,
            ),
          ),
        ),
      ),
    );
    expect(find.textContaining('Capital of France'), findsOneWidget);
  });
}
