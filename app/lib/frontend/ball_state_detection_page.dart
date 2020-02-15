import 'package:app/ball/ring.dart';
import 'package:app/util/detection.dart';
import 'package:camera/camera.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../ball/ball.dart';
import '../ball/magic_rainbow_ball.dart';
import '../ball/move.dart';
import 'object_detection_camera.dart';

/// Defines the structure of the UI, which allows the user to ...
/// ... detect the State of a [MagicRainbowBall] via the smartphone camera.
/// ... solving the detected [MagicRainbowBall].
/// ... testing if the detected [MagicRainbowBall] is consistent.
/// ... exporting the detected [MagicRainbowBall] as json.
class BallStateDetectionPage extends StatefulWidget {
  /// The camera that is used for the detection task.
  final CameraController cameraController;

  /// Default constructor.
  BallStateDetectionPage(this.cameraController);

  @override
  _BallStateDetectionPageState createState() => _BallStateDetectionPageState(cameraController);
}

/// State of the [BallStateDetectionPage].
class _BallStateDetectionPageState extends State<BallStateDetectionPage> {
  /// The camera that is used for the detection task.
  CameraController cameraController;

  /// Default constructor.
  _BallStateDetectionPageState(this.cameraController) {
    Ring.values.forEach((ring) {
      ballState[ring] = null;
      lockedRings[ring] = true;
    });
  }

  /// Holds the state of the detected [MagicRainbowBall].
  Map<Ring, Ball> ballState = Map();

  /// Saves which [Ring]s are currently locked and should not be updated by new [Detection]s.
  Map<Ring, bool> lockedRings = Map();

  /// Creates a [String] representation of a [Ball] that can be used in the UI.
  String ballToString(Ball ball) {
    String name1 = ball.toString().replaceAll("Ball.", "").toLowerCase();
    String name = name1[0].toUpperCase() + name1.substring(1);
    if (name.contains("_")) {
      int i = name.indexOf("_");
      name = name.substring(0, i) + " " + name[i + 1].toUpperCase() + name.substring(i + 2);
    }
    return name;
  }

  /// Creates a [String] representation of a [Ring] that can be used in the UI.
  String ringToString(Ring ring) {
    String name1 = ring.toString().replaceAll("Ring.", "").toLowerCase();
    String name = name1[0].toUpperCase() + name1.substring(1);
    if (name.contains("_")) {
      int i = name.indexOf("_");
      name = name.substring(0, i) + " " + name[i + 1].toUpperCase() + name.substring(i + 2);
    }
    return name;
  }

  /// Assigns every possible [Detection] of a [Ball] (assuming the model is right) the corresponding [Ball].
  Ball ballFromDetection(Detection detection) {
    switch (detection.detectedClass) {
      case "empty":
        return Ball.EMPTY;
      case "blackball":
        return Ball.BLACK;
      case "lightblueball":
        return Ball.LIGHT_BLUE;
      case "darkblueball":
        return Ball.DARK_BLUE;
      case "lightgreenball":
        return Ball.LIGHT_GREEN;
      case "darkgreenball":
        return Ball.DARK_GREEN;
      case "yellowball":
        return Ball.YELLOW;
      case "orangeball":
        return Ball.ORANGE;
      case "redball":
        return Ball.RED;
      case "pinkball":
        return Ball.PINK;
      case "purpleball":
        return Ball.PURPLE;
      case "cyanball":
        return Ball.CYAN;
      default:
        return null;
    }
  }

  /// Assigns every possible [Detection] of a [Ring] (assuming the model is right) the corresponding [Ring].
  Ring ringFromDetection(Detection detection) {
    switch (detection.detectedClass) {
      case "whitering":
        return Ring.WHITE;
      case "blackring":
        return Ring.BLACK;
      case "lightbluering":
        return Ring.LIGHT_BLUE;
      case "darkbluering":
        return Ring.DARK_BLUE;
      case "lightgreenring":
        return Ring.LIGHT_GREEN;
      case "darkgreenring":
        return Ring.DARK_GREEN;
      case "yellowring":
        return Ring.YELLOW;
      case "orangering":
        return Ring.ORANGE;
      case "redring":
        return Ring.RED;
      case "pinkring":
        return Ring.PINK;
      case "purplering":
        return Ring.PURPLE;
      case "cyanring":
        return Ring.CYAN;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    MagicRainbowBall mrb = MagicRainbowBall(
      ballState[Ring.WHITE],
      ballState[Ring.BLACK],
      ballState[Ring.LIGHT_GREEN],
      ballState[Ring.DARK_GREEN],
      ballState[Ring.LIGHT_BLUE],
      ballState[Ring.DARK_BLUE],
      ballState[Ring.YELLOW],
      ballState[Ring.ORANGE],
      ballState[Ring.RED],
      ballState[Ring.PINK],
      ballState[Ring.PURPLE],
      ballState[Ring.CYAN],
    );
    return Stack(
      children: <Widget>[
        ObjectDetectionCamera(
          cameraController,
          (image, List<Detection> detections) {
            List<Tuple2<Ring, Rect>> ringBoxPairs = detections
                .map((detection) {
                  Ring ring = ringFromDetection(detection);
                  if (ring == null) return null;
                  return Tuple2(ring, Rect.fromLTWH(detection.x, detection.y, detection.w, detection.h));
                })
                .where((ringDetectionPair) => ringDetectionPair != null)
                .toList();

            List<Tuple2<Ball, Rect>> ballBoxPairs = detections
                .map((detection) {
                  Ball ball = ballFromDetection(detection);
                  if (ball == null) return null;
                  return Tuple2(ball, Rect.fromLTWH(detection.x, detection.y, detection.w, detection.h));
                })
                .where((ringDetectionPair) => ringDetectionPair != null)
                .toList();
            setState(() {
              ringBoxPairs.forEach((ringBoxPair) {
                ballBoxPairs.forEach((ballBoxPair) {
                  Rect intersectionRect = ringBoxPair.item2.intersect(ballBoxPair.item2);
                  if (!intersectionRect.width.isNegative && !intersectionRect.height.isNegative) {
                    if (!lockedRings[ringBoxPair.item1]) {
                      ballState[ringBoxPair.item1] = ballBoxPair.item1;
                    }
                  }
                });
              });
            });
          },
          0.8,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Wrap(
                spacing: 10.0,
                children: ballState.entries
                    .map(
                      (ringBall) => Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                lockedRings[ringBall.key] = !lockedRings[ringBall.key];
                              });
                            },
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text("Ballfarbe auswählen\nAktuell: " + ballToString(ballState[ringBall.key])),
                                    content: Column(
                                      children: List.generate(Ball.values.length, (index) {
                                        Ball ball = Ball.values[index];
                                        return Column(
                                          children: <Widget>[
                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    ballState[ringBall.key] = ball;
                                                    lockedRings[ringBall.key] = true;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(ballToString(ball), style: TextStyle(color: ball.color == Colors.white ? Colors.black : ball.color))),
                                            SizedBox(height: 10),
                                          ],
                                        );
                                      }),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Abbrechen"),
                                        onPressed: () => Navigator.of(context).pop(),
                                      )
                                    ],
                                  ));
                            },
                            child: CustomPaint(
                              painter: RingStatePainter(ringBall.key.color, ringBall.value.color, lockedRings[ringBall.key]),
                              child: Container(
                                width: 50,
                                height: 50,
                                child: lockedRings[ringBall.key]
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.lock,
                                          color: Colors.black,
                                          size: 32,
                                        ),
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text("Prüfen", style: TextStyle(color: Colors.white)),
                  onPressed: mrb.isConsistent()
                      ? () {
                          MagicRainbowBall mrb = MagicRainbowBall(
                            ballState[Ring.WHITE],
                            ballState[Ring.BLACK],
                            ballState[Ring.LIGHT_GREEN],
                            ballState[Ring.DARK_GREEN],
                            ballState[Ring.LIGHT_BLUE],
                            ballState[Ring.DARK_BLUE],
                            ballState[Ring.YELLOW],
                            ballState[Ring.ORANGE],
                            ballState[Ring.RED],
                            ballState[Ring.PINK],
                            ballState[Ring.PURPLE],
                            ballState[Ring.CYAN],
                          );
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Ok"),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ],
                                  title: Text("Ist das erkannte Modell konsistent?"),
                                  content: mrb.isConsistent()
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 50,
                                        )
                                      : Icon(
                                          Icons.clear,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                );
                              });
                        }
                      : null,
                ),
                FlatButton(
                  child: Text("Lösen", style: TextStyle(color: mrb.isConsistent() ? Colors.white : Colors.grey)),
                  onPressed: mrb.isConsistent()
                      ? () {
                          MagicRainbowBall mrb = MagicRainbowBall(
                            ballState[Ring.WHITE],
                            ballState[Ring.BLACK],
                            ballState[Ring.LIGHT_GREEN],
                            ballState[Ring.DARK_GREEN],
                            ballState[Ring.LIGHT_BLUE],
                            ballState[Ring.DARK_BLUE],
                            ballState[Ring.YELLOW],
                            ballState[Ring.ORANGE],
                            ballState[Ring.RED],
                            ballState[Ring.PINK],
                            ballState[Ring.PURPLE],
                            ballState[Ring.CYAN],
                          );
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Ok"),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ],
                                  title: Text("Lösungsweg"),
                                  content: FutureBuilder(
                                    future: mrb.generateSolution(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<Move> solution = snapshot.data;
                                        return SingleChildScrollView(
                                          child: Column(
                                            children: List.generate(solution.length, (index) {
                                              Move move = solution[index];
                                              return Row(
                                                children: <Widget>[
                                                  SizedBox(width: 10),
                                                  Text(ballToString(move.ball), style: TextStyle(color: move.ball.color)),
                                                  SizedBox(width: 10),
                                                  Text(":"),
                                                  SizedBox(width: 10),
                                                  Text(ringToString(move.from), style: TextStyle(color: move.from.color)),
                                                  SizedBox(width: 10),
                                                  Icon(Icons.arrow_forward),
                                                  SizedBox(width: 10),
                                                  Text(ringToString(move.to), style: TextStyle(color: move.to.color)),
                                                ],
                                              );
                                            }),
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                );
                              });
                        }
                      : null,
                ),
                FlatButton(
                  child: Text("Exportieren", style: TextStyle(color: mrb.isConsistent() ? Colors.white : Colors.grey)),
                  onPressed: mrb.isConsistent()
                      ? () {
                          MagicRainbowBall mrb = MagicRainbowBall(
                            ballState[Ring.WHITE],
                            ballState[Ring.BLACK],
                            ballState[Ring.LIGHT_GREEN],
                            ballState[Ring.DARK_GREEN],
                            ballState[Ring.LIGHT_BLUE],
                            ballState[Ring.DARK_BLUE],
                            ballState[Ring.YELLOW],
                            ballState[Ring.ORANGE],
                            ballState[Ring.RED],
                            ballState[Ring.PINK],
                            ballState[Ring.PURPLE],
                            ballState[Ring.CYAN],
                          );
                          ClipboardManager.copyToClipBoard(mrb.toJson().toString()).then((result) {
                            final snackBar = SnackBar(content: Text("JSON in Zwischenablage kopiert"));
                            Scaffold.of(context).showSnackBar(snackBar);
                          });
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// [CustomPainter] that can be used in the [CustomPaint] widget to visualize the state of a [Ring] in the UI.
class RingStatePainter extends CustomPainter {
  /// [Color] of the [Ring].
  Color ringColor;

  /// [Color] of the [Ball] in the [Ring].
  Color ballColor;

  /// Indicates whether or not the state is locked.
  bool locked;

  /// Default constructor.
  RingStatePainter(this.ringColor, this.ballColor, this.locked);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, Paint()..color = ringColor.withOpacity(locked ? 0.5 : 1));
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2.5, Paint()..color = Colors.white.withOpacity(locked ? 0.5 : 1));
    if (ballColor != null) {
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 3, Paint()..color = ballColor.withOpacity(locked ? 0.5 : 1));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
