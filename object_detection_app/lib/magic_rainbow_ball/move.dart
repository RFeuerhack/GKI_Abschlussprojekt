import 'ball.dart';
import 'ring.dart';

class Move {
  Ball ball;
  Ring from;
  Ring to;

  Move(
    this.ball,
    this.from,
    this.to,
  );

  @override
  String toString() {
    return "Move{" + "ball:" + ball.toString() + ",from:" + from.toString() + ",to:" + to.toString() + "}";
  }
}
