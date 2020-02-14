import 'ball.dart';
import 'ring.dart';

/// represents a move on the magic rainbow ball
class Move {
  /// ball which is moved
  Ball ball;
  /// ring the ball is moved away from
  Ring from;
  /// ring the ball is moved to
  Ring to;

  /// default constructor
  Move(
    this.ball,
    this.from,
    this.to,
  );

  /// toString method for debug purposes
  @override
  String toString() {
    return "Move{" + "ball:" + ball.toString() + ",from:" + from.toString() + ",to:" + to.toString() + "}";
  }
}
