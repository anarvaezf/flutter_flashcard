import 'package:flutter/material.dart';
import 'package:colored_flashcard/colored_flashcard.dart';

void main() {
  runApp(const FlashcardExampleApp());
}

class FlashcardExampleApp extends StatelessWidget {
  const FlashcardExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const ExampleHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Examples'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'fullscreen') {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const FullscreenFlashcardPage(),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'fullscreen',
                child: Text('Fullscreen demo'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionTitle('1) Basic flashcard (tap to flip)'),
          SizedBox(height: 12),
          _DemoCard(
            question: 'What is the capital of France?',
            answer: 'Paris',
            front: Colors.amber,
            back: Colors.deepPurple,
            flip: FlashcardFlipBehavior.tap,
            style: FlashcardBackgroundStyle.pattern,
            wmFront: 'Question',
            wmBack: 'Answer',
          ),
          SizedBox(height: 24),
          _SectionTitle('2) Pattern watermark with horizontal swipe'),
          SizedBox(height: 12),
          _DemoCard(
            question: '2 + 2 = ?',
            answer: '4',
            front: Color(0xFF4DD0E1),
            back: Color(0xFF006064),
            flip: FlashcardFlipBehavior.horizontalSwipe,
            style: FlashcardBackgroundStyle.solid,
          ),
          SizedBox(height: 24),
          _SectionTitle('3) Long text with vertical swipe and auto-fit'),
          SizedBox(height: 12),
          _DemoCard(
            question:
                'Name the three primary colors of light and briefly describe how they combine to form white.',
            answer:
                'Red, Green, Blue (RGB). When combined at full intensity, they produce white light due to additive color mixing.',
            front: Color(0xFFB2FF59),
            back: Color(0xFF1B5E20),
            flip: FlashcardFlipBehavior.verticalSwipe,
            style: FlashcardBackgroundStyle.pattern,
            wmFront: 'Q',
            wmBack: 'A',
          ),
          SizedBox(height: 24),
          _SectionTitle('4) No interaction (presentation only)'),
          SizedBox(height: 12),
          _DemoCard(
            question: 'Static card (no flip)',
            answer: 'This back side is never shown.',
            front: Color(0xFFFFCDD2),
            back: Color(0xFFB71C1C),
            flip: FlashcardFlipBehavior.none,
            style: FlashcardBackgroundStyle.solid,
          ),
          SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.question,
    required this.answer,
    required this.front,
    required this.back,
    required this.flip,
    required this.style,
    this.wmFront,
    this.wmBack,
  });

  final String question;
  final String answer;
  final Color front;
  final Color back;
  final FlashcardFlipBehavior flip;
  final FlashcardBackgroundStyle style;
  final String? wmFront;
  final String? wmBack;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ColoredFlashcard(
            questionText: question,
            answerText: answer,
            frontColor: front,
            backColor: back,
            flipBehavior: flip,
            backgroundStyle: style,
            watermarkTextFront: wmFront,
            watermarkTextBack: wmBack,
            autoFitText: true,
            minFontSize: 14,
            maxLines: 8,
            borderRadius: 16,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          if (flip != FlashcardFlipBehavior.none)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(100),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Text(
                  switch (flip) {
                    FlashcardFlipBehavior.tap => 'Tap to flip',
                    FlashcardFlipBehavior.horizontalSwipe =>
                      'Swipe horizontally to flip',
                    FlashcardFlipBehavior.verticalSwipe =>
                      'Swipe vertically to flip',
                    FlashcardFlipBehavior.none => '',
                  },
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleLarge);
  }
}

class FullscreenFlashcardPage extends StatelessWidget {
  const FullscreenFlashcardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fullscreen Flashcard')),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ColoredFlashcard(
              questionText:
                  'This flashcard uses the full screen area.\nTap or swipe to flip.',
              answerText:
                  'Fullscreen answer side.\nTry rotating the device, or changing themes.',
              frontColor: const Color(0xFF80DEEA),
              backColor: const Color(0xFF006064),
              flipBehavior: FlashcardFlipBehavior.tap,
              backgroundStyle: FlashcardBackgroundStyle.pattern,
              watermarkTextFront: 'Fullscreen',
              watermarkTextBack: 'Answer',
              autoFitText: true,
              minFontSize: 14,
              maxLines: 10,
              borderRadius: 16,
              elevation: 2,
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ),
    );
  }
}
