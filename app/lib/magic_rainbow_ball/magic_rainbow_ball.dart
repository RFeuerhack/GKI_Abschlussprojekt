import 'dart:math';

import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

import 'ball.dart';
import 'move.dart';
import 'ring.dart';

/// Represents a Magic Rainbow Ball.
class MagicRainbowBall {
  /// Contains information regarding: Which ball is in which ring. (reversed map of _ringWith)
  Map<Ring, Ball> _ballWith = Map();
  /// Contains informatin regarding: Which ring is in which ball. (reversed map of _ballWith)
  Map<Ball, Ring> _ringWith = Map();

  /// Creates MagicRainbowBall by using information which ball is in which ring.
  MagicRainbowBall(
    Ball inWhiteRing,
    Ball inBlackRing,
    Ball inLightGreenRing,
    Ball inDarkGreenRing,
    Ball inLightBlueRing,
    Ball inDarkBlueRing,
    Ball inYellowRing,
    Ball inOrangeRing,
    Ball inRedRing,
    Ball inPinkRing,
    Ball inPurpleRing,
    Ball inCyanRing,
  ) {
    _ballWith[Ring.WHITE] = inWhiteRing;
    _ballWith[Ring.BLACK] = inBlackRing;
    _ballWith[Ring.LIGHT_GREEN] = inLightGreenRing;
    _ballWith[Ring.DARK_GREEN] = inDarkGreenRing;
    _ballWith[Ring.LIGHT_BLUE] = inLightBlueRing;
    _ballWith[Ring.DARK_BLUE] = inDarkBlueRing;
    _ballWith[Ring.YELLOW] = inYellowRing;
    _ballWith[Ring.ORANGE] = inOrangeRing;
    _ballWith[Ring.RED] = inRedRing;
    _ballWith[Ring.PINK] = inPinkRing;
    _ballWith[Ring.PURPLE] = inPurpleRing;
    _ballWith[Ring.CYAN] = inCyanRing;
    _ringWith[inWhiteRing] = Ring.WHITE;
    _ringWith[inBlackRing] = Ring.BLACK;
    _ringWith[inLightGreenRing] = Ring.LIGHT_GREEN;
    _ringWith[inDarkGreenRing] = Ring.DARK_GREEN;
    _ringWith[inLightBlueRing] = Ring.LIGHT_BLUE;
    _ringWith[inDarkBlueRing] = Ring.DARK_BLUE;
    _ringWith[inYellowRing] = Ring.YELLOW;
    _ringWith[inOrangeRing] = Ring.ORANGE;
    _ringWith[inRedRing] = Ring.RED;
    _ringWith[inPinkRing] = Ring.PINK;
    _ringWith[inPurpleRing] = Ring.PURPLE;
    _ringWith[inCyanRing] = Ring.CYAN;
  }

  /// Creates a solved MagicRainbowBall.
  MagicRainbowBall.solved() {
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

  /// Creates a deep copy of a MagicRainbowBall.
  MagicRainbowBall.copy(MagicRainbowBall magicRainbowBall)
      : _ballWith = Map.from(magicRainbowBall._ballWith),
        _ringWith = Map.from(magicRainbowBall._ringWith);

  /// Returns a list of all possible moves that can be applied to the MagicRainbowBall.
  List<Move> possibleMoves() => _ringWith[Ball.EMPTY].neighbors.map((e) => Move(_ballWith[e], e, _ringWith[Ball.EMPTY])).toList();

  /// Applies the given Move to the MagicRainbowBall.
  void move(Move move) {
    assert(move.ball == _ballWith[move.from]);
    assert(_ballWith[move.to] == Ball.EMPTY);
    _ballWith[move.to] = move.ball;
    _ballWith[move.from] = Ball.EMPTY;
    _ringWith[move.ball] = move.to;
    _ringWith[Ball.EMPTY] = move.from;
  }

  /// Returns true if the MagicRainbowBall is solved.
  bool isSolved() => !Ring.values.any((ring) => ring.index != _ballWith[ring].index);

  /// Shuffles the MagicRainbowBall.
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

  /// Creates a deep copy of a MagicRainbowBall and applies the given Move to the copy.
  MagicRainbowBall copyAndMove(Move move) => MagicRainbowBall.copy(this)..move(move);

  /// Calculates the manhattan distance of the MagicRainbowBall.
  int manhattanDistance() => Ball.values.fold(0, (distance, ball) => distance += _ringWith[ball].distance(Ring.values[ball.index]));

  /// Converts the MagicRainbowBall to json.
  Map<String, dynamic> toJson() => {
        '\"' + Ring.values[0].toString().replaceFirst("Ring.", "").toLowerCase() + '\"': '\"' + _ballWith[Ring.values[0]].toString().replaceFirst("Ball.", "").toLowerCase() + '\"',
        '\"' + Ring.values[1].toString().replaceFirst("Ring.", "").toLowerCase() + '\"': '\"' + _ballWith[Ring.values[1]].toString().replaceFirst("Ball.", "").toLowerCase() + '\"',
        '\"' + Ring.values[2].toString().replaceFirst("Ring.", "").toLowerCase() + '\"': '\"' + _ballWith[Ring.values[2]].toString().replaceFirst("Ball.", "").toLowerCase() + '\"',
        '\"' + Ring.values[3].toString().replaceFirst("Ring.", "").toLowerCase() + '\"': '\"' + _ballWith[Ring.values[3]].toString().replaceFirst("Ball.", "").toLowerCase() + '\"',
        '\"' + Ring.values[4].toString().replaceFirst("Ring.", "").toLowerCase() + '\"': '\"' + _ballWith[Ring.values[4]].toString().replaceFirst("Ball.", "").toLowerCase() + '\"',
        '\"' + Ring.values[5].toString().replaceFirst("Ring.", "").toLowerCase() + '\"': '\"' + _ballWith[Ring.values[5]].toString().replaceFirst("Ball.", "").toLowerCase() + '\"',
        '\"' + Ring.values[6].toString().replaceFirst("Ring.", "").toLowerCase() + '\"': '\"' + _ballWith[Ring.values[6]].toString().replaceFirst("Ball.", "").toLowerCase() + '\"',
        '\"' + Ring.values[7].toString().replaceFirst("Ring.", "").toLowerCase() + '\"': '\"' + _ballWith[Ring.values[7]].toString().replaceFirst("Ball.", "").toLowerCase() + '\"',
        '\"' + Ring.values[8].toString().replaceFirst("Ring.", "").toLowerCase() + '\"': '\"' + _ballWith[Ring.values[8]].toString().replaceFirst("Ball.", "").toLowerCase() + '\"',
        '\"' + Ring.values[9].toString().replaceFirst("Ring.", "").toLowerCase() + '\"': '\"' + _ballWith[Ring.values[9]].toString().replaceFirst("Ball.", "").toLowerCase() + '\"',
        '\"' + Ring.values[10].toString().replaceFirst("Ring.", "").toLowerCase() + '\"': '\"' + _ballWith[Ring.values[10]].toString().replaceFirst("Ball.", "").toLowerCase() + '\"',
        '\"' + Ring.values[11].toString().replaceFirst("Ring.", "").toLowerCase() + '\"': '\"' + _ballWith[Ring.values[11]].toString().replaceFirst("Ball.", "").toLowerCase() + '\"',
      };

  /// Creates a list with moves representing a possible solution path.
  Future<List<Move>> generateSolution() async {
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

  /// Returns true if the state of the MagicRainbowBall is possible in reality.
  bool isConsistent() {
    if (Ring.values.any((ring) => _ringWith[_ballWith[ring]] != ring)) return false;
    if (Ball.values.any((ball) => _ballWith[_ringWith[ball]] != ball)) return false;
    Map<Ring, int> ringCounter = {};
    Ring.values.forEach((ring) => ringCounter[ring] = 0);
    print(ringCounter.toString());
    Ball.values.forEach((ball) => ringCounter[_ringWith[ball]]++);
    if (ringCounter.entries.any((entry) => entry.value != 1)) return false;
    Map<Ball, int> ballCounter = {};
    Ball.values.forEach((ball) => ballCounter[ball] = 0);
    Ring.values.forEach((ring) => ballCounter[_ballWith[ring]]++);
    if (ballCounter.entries.any((entry) => entry.value != 1)) return false;
    return true;
  }
}
