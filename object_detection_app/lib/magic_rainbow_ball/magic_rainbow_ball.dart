import 'dart:math';

import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

import 'ball.dart';
import 'move.dart';
import 'ring.dart';

class MagicRainbowBall {
  Map<Ring, Ball> _ballWith = Map();
  Map<Ball, Ring> _ringWith = Map();

  MagicRainbowBall() {
    _ballWith[Ring.WHITE] = Ball.EMPTY;
    _ballWith[Ring.BLACK] = Ball.BLACK;
    _ballWith[Ring.LIGHT_GREEN] = Ball.LIGHT_GREEN;
    _ballWith[Ring.DARK_GREEN] = Ball.DARK_GREEN;
    _ballWith[Ring.LIGHT_BLUE] = Ball.LIGHT_BLUE;
    _ballWith[Ring.DARK_BLUE] = Ball.DARK_BLUE;
    _ballWith[Ring.YELLOW] = Ball.YELLOW;
    _ballWith[Ring.ORANGE] = Ball.ORANGE;
    _ballWith[Ring.RED] = Ball.RED;
    _ballWith[Ring.PINK] = Ball.PINK;
    _ballWith[Ring.PURPLE] = Ball.PURPLE;
    _ballWith[Ring.CYAN] = Ball.CYAN;
    _ringWith[Ball.EMPTY] = Ring.WHITE;
    _ringWith[Ball.BLACK] = Ring.BLACK;
    _ringWith[Ball.LIGHT_GREEN] = Ring.LIGHT_GREEN;
    _ringWith[Ball.DARK_GREEN] = Ring.DARK_GREEN;
    _ringWith[Ball.LIGHT_BLUE] = Ring.LIGHT_BLUE;
    _ringWith[Ball.DARK_BLUE] = Ring.DARK_BLUE;
    _ringWith[Ball.YELLOW] = Ring.YELLOW;
    _ringWith[Ball.ORANGE] = Ring.ORANGE;
    _ringWith[Ball.RED] = Ring.RED;
    _ringWith[Ball.PINK] = Ring.PINK;
    _ringWith[Ball.PURPLE] = Ring.PURPLE;
    _ringWith[Ball.CYAN] = Ring.CYAN;
  }

  MagicRainbowBall.copy(MagicRainbowBall magicRainbowBall)
      : _ballWith = Map.from(magicRainbowBall._ballWith),
        _ringWith = Map.from(magicRainbowBall._ringWith);

  List<Move> possibleMoves() => _ringWith[Ball.EMPTY].neighbors.map((e) => Move(_ballWith[e], e, _ringWith[Ball.EMPTY])).toList();

  void move(Move move) {
    assert(move.ball == _ballWith[move.from]);
    assert(_ballWith[move.to] == Ball.EMPTY);
    _ballWith[move.to] = move.ball;
    _ballWith[move.from] = Ball.EMPTY;
    _ringWith[move.ball] = move.to;
    _ringWith[Ball.EMPTY] = move.from;
  }

  bool isSolved() => !Ring.values.any((ring) => ring.index != _ballWith[ring].index);

  void shuffle(Random random) {
    List<Ball> balls = Ball.values.toList()..shuffle(random);
    List<Ring> rings = Ring.values.toList()..shuffle(random);
    for (int i = 0; i < balls.length; i++) {
      Ball ball = balls[i];
      Ring ring = rings[i];
      _ringWith[ball] = ring;
      _ballWith[ring] = ball;
    }
  }

  MagicRainbowBall copyAndMove(Move move) => MagicRainbowBall.copy(this)..move(move);

  int manhattanDistance() => Ball.values.fold(0, (distance, ball) => distance += _ringWith[ball].distance(Ring.values[ball.index]));

  Map<String, dynamic> toJson() => {
        Ring.values[0].toString(): _ballWith[Ring.values[0]],
        Ring.values[1].toString(): _ballWith[Ring.values[1]],
        Ring.values[2].toString(): _ballWith[Ring.values[2]],
        Ring.values[3].toString(): _ballWith[Ring.values[3]],
        Ring.values[4].toString(): _ballWith[Ring.values[4]],
        Ring.values[5].toString(): _ballWith[Ring.values[5]],
        Ring.values[6].toString(): _ballWith[Ring.values[6]],
        Ring.values[7].toString(): _ballWith[Ring.values[7]],
        Ring.values[8].toString(): _ballWith[Ring.values[8]],
        Ring.values[9].toString(): _ballWith[Ring.values[9]],
        Ring.values[10].toString(): _ballWith[Ring.values[10]],
        Ring.values[11].toString(): _ballWith[Ring.values[11]],
      };

  List<Move> generateSolution() {
    PriorityQueue<Tuple3<MagicRainbowBall, int, List<Move>>> priorityQueue = PriorityQueue((mrb1, mrb2) => mrb1.item2.compareTo(mrb2.item2));
    priorityQueue.add(Tuple3(this, manhattanDistance() + 0, []));
    Tuple3<MagicRainbowBall, int, List<Move>> first = priorityQueue.first;
    while (first.item1.manhattanDistance() != 0) {
      first = priorityQueue.first;
      priorityQueue.removeFirst();
      first.item1.possibleMoves().forEach((move) {
        List<Move> solution = first.item3.toList()..add(move);
        MagicRainbowBall magicRainbowBall = first.item1.copyAndMove(move);
        int rating = magicRainbowBall.manhattanDistance() + solution.length;
        priorityQueue.add(Tuple3(magicRainbowBall, rating, solution));
      });
    }
    return first.item3;
  }
}
