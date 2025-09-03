import 'package:colored_flashcard/colored_flashcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlashCard', () {
    testWidgets('renders question text on front side', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              height: 200,
              child: ColoredFlashcard(
                questionText: 'Q: 2 + 2 = ?',
                answerText: 'A: 4',
                frontColor: Colors.orange,
                backColor: Colors.blue,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Q: 2 + 2 = ?'), findsOneWidget);
      expect(find.text('A: 4'), findsNothing);
    });

    testWidgets('tap flip toggles to answer and back', (tester) async {
      const String q = 'Q: Long question text goes here?';
      const String a = 'A: Long answer text goes here.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 340,
              height: 220,
              child: ColoredFlashcard(
                questionText: q,
                answerText: a,
                frontColor: Colors.amber,
                backColor: Colors.green,
                flipBehavior: FlashcardFlipBehavior.tap,
              ),
            ),
          ),
        ),
      );

      // Initially shows question.
      expect(find.text(q), findsOneWidget);
      expect(find.text(a), findsNothing);

      // Tap to flip to answer.
      await tester.tap(find.byType(ColoredFlashcard));
      await tester.pumpAndSettle();

      expect(find.text(a), findsOneWidget);
      expect(find.text(q), findsNothing);

      // Tap again flips back to question.
      await tester.tap(find.byType(ColoredFlashcard));
      await tester.pumpAndSettle();

      expect(find.text(q), findsOneWidget);
      expect(find.text(a), findsNothing);
    });

    testWidgets('semantics label switches between question/answer',
        (tester) async {
      // This test checks that the semantics labels reflect the currently visible side.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              height: 200,
              child: ColoredFlashcard(
                questionText: 'Question side',
                answerText: 'Answer side',
                frontColor: Colors.pink,
                backColor: Colors.indigo,
                flipBehavior: FlashcardFlipBehavior.tap,
              ),
            ),
          ),
        ),
      );

      // Expect the question semantics label initially.
      expect(
          find.bySemanticsLabel('Flashcard: question shown'), findsOneWidget);

      // Flip to answer.
      await tester.tap(find.byType(ColoredFlashcard));
      await tester.pumpAndSettle();

      // Expect the answer semantics label now.
      expect(find.bySemanticsLabel('Flashcard: answer shown'), findsOneWidget);
    });

    testWidgets('horizontal swipe flip works when enabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              height: 200,
              child: ColoredFlashcard(
                questionText: 'Swipe horizontally',
                answerText: 'Flipped!',
                frontColor: Colors.yellow,
                backColor: Colors.blueGrey,
                flipBehavior: FlashcardFlipBehavior.horizontalSwipe,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Swipe horizontally'), findsOneWidget);
      expect(find.text('Flipped!'), findsNothing);

      // Simulate a fast horizontal swipe to trigger flip.
      await tester.fling(
          find.byType(ColoredFlashcard), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();

      expect(find.text('Flipped!'), findsOneWidget);
    });

    testWidgets('no flip occurs when flipBehavior is none', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              height: 200,
              child: ColoredFlashcard(
                questionText: 'Static',
                answerText: 'Should not appear',
                frontColor: Colors.cyan,
                backColor: Colors.red,
                flipBehavior: FlashcardFlipBehavior.none,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Static'), findsOneWidget);
      expect(find.text('Should not appear'), findsNothing);

      // Tap should do nothing.
      await tester.tap(find.byType(ColoredFlashcard));
      await tester.pumpAndSettle();

      expect(find.text('Static'), findsOneWidget);
      expect(find.text('Should not appear'), findsNothing);
    });

    testWidgets('vertical swipe with sufficient velocity flips the card',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              height: 200,
              child: ColoredFlashcard(
                questionText: 'Swipe vertically',
                answerText: 'Flipped!',
                frontColor: Colors.orange,
                backColor: Colors.blueGrey,
                flipBehavior: FlashcardFlipBehavior.verticalSwipe,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Swipe vertically'), findsOneWidget);
      expect(find.text('Flipped!'), findsNothing);

      // Fast vertical fling to trigger flip (velocity > threshold).
      await tester.fling(
          find.byType(ColoredFlashcard), const Offset(0, -300), 1000);
      await tester.pumpAndSettle();

      expect(find.text('Flipped!'), findsOneWidget);
    });

    testWidgets('slow horizontal and vertical drags do not flip',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              height: 200,
              child: ColoredFlashcard(
                questionText: 'Slow drags',
                answerText: 'Should not flip',
                frontColor: Colors.teal,
                backColor: Colors.indigo,
                flipBehavior: FlashcardFlipBehavior.horizontalSwipe,
              ),
            ),
          ),
        ),
      );

      // Slow horizontal "drag" (velocity below threshold): should NOT flip.
      await tester.drag(find.byType(ColoredFlashcard), const Offset(-30, 0));
      await tester.pumpAndSettle();
      expect(find.text('Slow drags'), findsOneWidget);
      expect(find.text('Should not flip'), findsNothing);

      // Rebuild with vertical behavior to test the vertical slow drag.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              height: 200,
              child: ColoredFlashcard(
                questionText: 'Slow drags',
                answerText: 'Should not flip',
                frontColor: Colors.teal,
                backColor: Colors.indigo,
                flipBehavior: FlashcardFlipBehavior.verticalSwipe,
              ),
            ),
          ),
        ),
      );

      // Slow vertical drag: should NOT flip.
      await tester.drag(find.byType(ColoredFlashcard), const Offset(0, -30));
      await tester.pumpAndSettle();
      expect(find.text('Slow drags'), findsOneWidget);
      expect(find.text('Should not flip'), findsNothing);
    });
  });

  testWidgets('when autoForegroundColor=false, explicit text colors are used',
      (tester) async {
    const qStyle = TextStyle(color: Colors.red, fontSize: 24);
    const aStyle = TextStyle(color: Colors.green, fontSize: 24);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            height: 200,
            child: ColoredFlashcard(
              questionText: 'Q Color',
              answerText: 'A Color',
              frontColor: Colors.yellow,
              // Important: backColor left as null to exercise derived color path too.
              backColor: null,
              autoForegroundColor: false,
              questionTextStyle: qStyle,
              answerTextStyle: aStyle,
              flipBehavior: FlashcardFlipBehavior.tap,
            ),
          ),
        ),
      ),
    );

    // Front side should use the explicit question color (red).
    final frontText = tester.widget<Text>(find.text('Q Color'));
    expect(frontText.style?.color, Colors.red);

    // Flip to back side.
    await tester.tap(find.byType(ColoredFlashcard));
    await tester.pumpAndSettle();

    // Back side should use the explicit answer color (green), even with derived backColor.
    final backText = tester.widget<Text>(find.text('A Color'));
    expect(backText.style?.color, Colors.green);
  });

  testWidgets('uses default padding when not provided', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            height: 200,
            child: ColoredFlashcard(
              questionText: 'Q',
              answerText: 'A',
              frontColor: Colors.orange,
              backColor: Colors.blueGrey,
              // padding is omitted to exercise the default
            ),
          ),
        ),
      ),
    );

    // Look for the specific Padding used by the Flashcard content.
    const expected = EdgeInsets.symmetric(horizontal: 16);
    final paddingFinder = find.descendant(
      of: find.byType(ColoredFlashcard),
      matching: find.byWidgetPredicate(
        (w) => w is Padding && w.padding == expected,
      ),
    );

    expect(paddingFinder, findsOneWidget);
  });

  testWidgets('respects custom padding when provided', (tester) async {
    const customPadding = EdgeInsets.fromLTRB(8, 12, 20, 24);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            height: 200,
            child: ColoredFlashcard(
              questionText: 'Q',
              answerText: 'A',
              frontColor: Colors.orange,
              backColor: Colors.blueGrey,
              padding: customPadding,
            ),
          ),
        ),
      ),
    );

    final paddingFinder = find.descendant(
      of: find.byType(ColoredFlashcard),
      matching: find.byWidgetPredicate(
        (w) => w is Padding && w.padding == customPadding,
      ),
    );

    expect(paddingFinder, findsOneWidget);
  });

  test(
      'constructor asserts validate inputs (minFontSize, maxLines, borderRadius, elevation)',
      () {
    // Base valid values used across cases.
    const String q = 'q';
    const String a = 'a';
    const Color front = Colors.red;

    // Invalid: minFontSize must be > 0
    expect(
      () => ColoredFlashcard(
        questionText: q,
        answerText: a,
        frontColor: front,
        backColor: Colors.blue, // optional, valid
        flipBehavior: FlashcardFlipBehavior.tap,
        backgroundStyle: FlashcardBackgroundStyle.solid,
        watermarkTextFront: 'Q',
        watermarkTextBack: 'A',
        autoForegroundColor: true,
        questionTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
        answerTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
        autoFitText: true,
        minFontSize: 0, // <-- invalid
        maxLines: 10,
        borderRadius: 16,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      throwsAssertionError,
    );

    // Invalid: maxLines must be > 0
    expect(
      () => ColoredFlashcard(
        questionText: q,
        answerText: a,
        frontColor: front,
        backColor: Colors.blue,
        flipBehavior: FlashcardFlipBehavior.tap,
        backgroundStyle: FlashcardBackgroundStyle.pattern,
        watermarkTextFront: 'Q',
        watermarkTextBack: 'A',
        autoForegroundColor: true,
        questionTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
        answerTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
        autoFitText: true,
        minFontSize: 16,
        maxLines: 0, // <-- invalid
        borderRadius: 16,
        elevation: 2,
        padding: const EdgeInsets.all(12),
      ),
      throwsAssertionError,
    );

    // Invalid: borderRadius must be >= 0
    expect(
      () => ColoredFlashcard(
        questionText: q,
        answerText: a,
        frontColor: front,
        backColor: Colors.blue,
        flipBehavior: FlashcardFlipBehavior.horizontalSwipe,
        backgroundStyle: FlashcardBackgroundStyle.solid,
        watermarkTextFront: 'Q',
        watermarkTextBack: 'A',
        autoForegroundColor: false, // exercise explicit styles path
        questionTextStyle: const TextStyle(fontSize: 18, color: Colors.red),
        answerTextStyle: const TextStyle(fontSize: 18, color: Colors.green),
        autoFitText: true,
        minFontSize: 12,
        maxLines: 5,
        borderRadius: -1, // <-- invalid
        elevation: 1,
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      ),
      throwsAssertionError,
    );

    // Invalid: elevation must be >= 0
    expect(
      () => ColoredFlashcard(
        questionText: q,
        answerText: a,
        frontColor: front,
        backColor: Colors.blue,
        flipBehavior: FlashcardFlipBehavior.verticalSwipe,
        backgroundStyle: FlashcardBackgroundStyle.pattern,
        watermarkTextFront: 'Q',
        watermarkTextBack: 'A',
        autoForegroundColor: true,
        questionTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        answerTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        autoFitText: false, // exercise non-autofit path
        minFontSize: 10,
        maxLines: 3,
        borderRadius: 8,
        elevation: -0.1, // <-- invalid
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
      throwsAssertionError,
    );
  });
}
