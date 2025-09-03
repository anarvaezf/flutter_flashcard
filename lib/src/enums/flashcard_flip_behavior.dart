/// Determines how the flashcard flips between question and answer.
enum FlashcardFlipBehavior {
  /// No flipping interaction is enabled.
  none,

  /// Flip on tap.
  tap,

  /// Flip on vertical swipe (up or down).
  verticalSwipe,

  /// Flip on horizontal swipe (left or right).
  horizontalSwipe,
}
