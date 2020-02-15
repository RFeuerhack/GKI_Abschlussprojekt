import 'ball.dart';
import 'ring.dart';

/// Represents a move on the magic rainbow ball.
class Move {
  /// Ball which is moved.
  Ball ball;
  /// Ring the ball is moved from.
  Ring from;
  /// Ring the ball is moved to.
  Ring to;

  Move(
    this.ball,
    this.from,
    this.to,
  );
}
