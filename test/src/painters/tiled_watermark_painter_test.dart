import 'package:colored_flashcard/src/painters/tiled_watermark_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TiledWatermarkPainter paints without crashing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomPaint(
            painter:
                TiledWatermarkPainter(text: 'WATERMARK', color: Colors.black12),
            child: const SizedBox(width: 200, height: 120),
          ),
        ),
      ),
    );
    final finder = find.byWidgetPredicate(
      (w) => w is CustomPaint && w.painter is TiledWatermarkPainter,
    );
    expect(finder, findsOneWidget);
  });

  testWidgets('TiledWatermarkPainter should repaint when text or color changes',
      (tester) async {
    final first = TiledWatermarkPainter(text: 'A', color: Colors.black12);
    final second = TiledWatermarkPainter(text: 'B', color: Colors.black12);
    final third = TiledWatermarkPainter(text: 'A', color: Colors.black26);

    expect(first.shouldRepaint(second), isTrue);
    expect(first.shouldRepaint(third), isTrue);
  });
}
