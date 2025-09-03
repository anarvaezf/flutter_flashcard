import 'package:colored_flashcard/src/utilities/flashcard_constrast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlashcardContrast.bestForegroundOn', () {
    test('white on black background', () {
      expect(FlashcardContrast.bestForegroundOn(Colors.black), Colors.white);
    });

    test('black on white background', () {
      expect(FlashcardContrast.bestForegroundOn(Colors.white), Colors.black);
    });

    test('mid gray background picks a valid contrast color', () {
      const mid = Color(0xFF888888);
      final fg = FlashcardContrast.bestForegroundOn(mid);
      expect(fg == Colors.black || fg == Colors.white, isTrue);
    });
  });
}
