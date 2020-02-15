import 'ball.dart';
import 'ring.dart';

/// Represents a move that can be applied to a [MagicRainbowBall].
class Move {
  /// [Ball] which is moved.
  Ball ball;

  /// [Ring] the [Ball] is moved from.
  Ring from;

  /// [Ring] the [Ball] is moved to.
  Ring to;

  /// Defaul constructor.
  Move(
    this.ball,
    this.from,
    this.to,
  );
}
