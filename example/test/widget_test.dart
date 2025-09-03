import 'package:colored_flashcard/colored_flashcard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('Example app renders a Flashcard', (tester) async {
    await tester.pumpWidget(const FlashcardExampleApp());
    expect(find.text('Flashcard Examples'), findsOneWidget);
    expect(find.byType(ColoredFlashcard), findsWidgets);
    expect(find.textContaining('capital of France'), findsOneWidget);
  });
}
