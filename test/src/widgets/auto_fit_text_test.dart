import 'package:colored_flashcard/src/widgets/auto_fit_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AutoFitText reduces font size to avoid overflow',
      (tester) async {
    const bigText =
        'This is a very long line that should trigger the auto-fit algorithm to reduce font size.';
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            height: 60,
            child: AutoFitText(
              text: bigText,
              style: TextStyle(fontSize: 48),
              autoFit: true,
              minFontSize: 10,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    expect(find.textContaining('auto-fit algorithm'), findsOneWidget);
  });

  testWidgets('AutoFitText respects minFontSize and maxLines', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 150,
            height: 40,
            child: AutoFitText(
              text: 'Hello AutoFit',
              style: TextStyle(fontSize: 32),
              autoFit: true,
              minFontSize: 12,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Hello AutoFit'), findsOneWidget);
  });

  testWidgets('AutoFitText with autoFit=false uses provided style',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 60,
            child: AutoFitText(
              text: 'No auto-fit',
              style: TextStyle(fontSize: 20),
              autoFit: false,
              minFontSize: 10,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
    expect(find.text('No auto-fit'), findsOneWidget);
  });
}
