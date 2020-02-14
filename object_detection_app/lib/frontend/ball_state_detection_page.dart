import 'package:camera/camera.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:object_detection_app/magic_rainbow_ball/ball.dart';
import 'package:object_detection_app/magic_rainbow_ball/magic_rainbow_ball.dart';
import 'package:object_detection_app/magic_rainbow_ball/move.dart';
import 'package:object_detection_app/magic_rainbow_ball/ring.dart';
import 'package:object_detection_app/frontend/object_detection_camera.dart';
import 'package:object_detection_app/util/detection.dart';
import 'package:tuple/tuple.dart';

/// ball state detection page
class BallStateDetectionPage extends StatefulWidget {
  final CameraController cameraController;

  BallStateDetectionPage(this.cameraController);

  @override
  _BallStateDetectionPageState createState() => _BallStateDetectionPageState(cameraController);
}

/// assigns every possible ball detection (assuming the model is right) a Ball from the Ball enum
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

/// assigns every possible ring detection (assuming the model is right) a Ring from the Ring enum
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

class _BallStateDetectionPageState extends State<BallStateDetectionPage> {
  CameraController cameraController;

  _BallStateDetectionPageState(this.cameraController) {
    Ring.values.forEach((ring) {
      ballState[ring] = null;
      lockedRings[ring] = true;
    });
  }

  Map<Ring, Ball> ballState = Map();
  Map<Ring, bool> lockedRings = Map();

  /// converts a Ball to a String
  String ballToString(Ball ball) {
    String name1 = ball.toString().replaceAll("Ball.", "").toLowerCase();
    String name = name1[0].toUpperCase() + name1.substring(1);
    if (name.contains("_")) {
      int i = name.indexOf("_");
      name = name.substring(0, i) + " " + name[i + 1].toUpperCase() + name.substring(i + 2);
    }
    return name;
  }

  /// converts a Ring to a String
  String ringToString(Ring ring) {
    String name1 = ring.toString().replaceAll("Ring.", "").toLowerCase();
    String name = name1[0].toUpperCase() + name1.substring(1);
    if (name.contains("_")) {
      int i = name.indexOf("_");
      name = name.substring(0, i) + " " + name[i + 1].toUpperCase() + name.substring(i + 2);
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
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
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
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
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("Prüfen", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (ballState[Ring.WHITE] == null || ballState[Ring.BLACK] == null || ballState[Ring.LIGHT_GREEN] == null || ballState[Ring.DARK_GREEN] == null || ballState[Ring.LIGHT_BLUE] == null || ballState[Ring.DARK_BLUE] == null || ballState[Ring.YELLOW] == null || ballState[Ring.ORANGE] == null || ballState[Ring.RED] == null || ballState[Ring.PINK] == null || ballState[Ring.PURPLE] == null || ballState[Ring.CYAN] == null) {
                    return;
                  }
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
                },
              ),
              FlatButton(
                child: Text("Lösen", style: TextStyle(color: Colors.white)),
                onPressed: () {
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
                },
              ),
              FlatButton(
                child: Text("Exportieren", style: TextStyle(color: Colors.white)),
                onPressed: () {
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
                    final snackBar = SnackBar(
                      content: Text("JSON in Zwischenablage kopiert"),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RingStatePainter extends CustomPainter {
  Color ringColor;
  Color ballColor;
  bool locked;

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

Map<Ball, Color> colors = {
  Ball.EMPTY: Colors.grey,
  Ball.BLACK: Colors.black,
  Ball.LIGHT_GREEN: Colors.lightGreen,
  Ball.DARK_GREEN: Colors.green,
  Ball.LIGHT_BLUE: Colors.lightBlue,
  Ball.DARK_BLUE: Colors.blue,
  Ball.YELLOW: Colors.yellow,
  Ball.ORANGE: Colors.orange,
  Ball.RED: Colors.red,
  Ball.PINK: Colors.pink,
  Ball.PURPLE: Colors.purple,
  Ball.CYAN: Colors.cyan,
};

extension on Ball {
  Color get color => colors[this];
}
