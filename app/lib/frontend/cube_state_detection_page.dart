import 'package:app/cube/rubics_cube.dart';
import 'package:app/cube/rubics_cube_analyse.dart';
import 'package:app/cube/rubics_cube_color.dart';
import 'package:app/cube/rubics_cube_side.dart';
import 'package:app/util/detection.dart';
import 'package:camera/camera.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';

import 'object_detection_camera.dart';

/// Defines the structure of the UI, which allows the user to detect the State of a [RubicsCube] via the smartphone camera.
class CubeStateDetectionPage extends StatefulWidget {
  /// The camera that is used for the detection task.
  final CameraController cameraController;

  /// Default constructor.
  CubeStateDetectionPage(this.cameraController);

  @override
  _CubeStateDetectionPageState createState() => _CubeStateDetectionPageState(cameraController);
}

class _CubeStateDetectionPageState extends State<CubeStateDetectionPage> {
  /// The camera that is used for the detection task.
  CameraController cameraController;

  /// Currently detected state of the [RubicsCubeSide].
  RubicsCubeSide rubicsCubeSide;

  /// Saved state of the detected blue [RubicsCubeSide].
  RubicsCubeSide rubicsCubeSideBlue;

  /// Saved state of the detected orange [RubicsCubeSide].
  RubicsCubeSide rubicsCubeSideOrange;

  /// Saved state of the detected green [RubicsCubeSide].
  RubicsCubeSide rubicsCubeSideGreen;

  /// Saved state of the detected red [RubicsCubeSide].
  RubicsCubeSide rubicsCubeSideRed;

  /// Saved state of the detected yellow [RubicsCubeSide].
  RubicsCubeSide rubicsCubeSideYellow;

  /// Saved state of the detected white [RubicsCubeSide].
  RubicsCubeSide rubicsCubeSideWhite;

  /// Default constructor.
  _CubeStateDetectionPageState(this.cameraController);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ObjectDetectionCamera(
          cameraController,
          (image, detections) {
            Detection detection = detections[0];
            setState(() {
              rubicsCubeSide = parsePartOfCameraImageOfRubicsCubeSide(
                image,
                (detection.x * image.height).toInt(),
                (detection.y * image.width).toInt(),
                (detection.w * image.height).toInt(),
                (detection.h * image.width).toInt(),
              );
            });
          },
          0.4,
          (image) {
            setState(() {
              rubicsCubeSide = null;
            });
          },
        ),
        Align(
          alignment: Alignment.center,
          child: CustomPaint(
            painter: CubeStatePainter(rubicsCubeSide, Colors.transparent),
            child: Container(
              width: 50,
              height: 50,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () => rubicsCubeSideBlue = rubicsCubeSide,
                  child: CustomPaint(
                    painter: CubeStatePainter(rubicsCubeSideBlue, RubicsCubeColor.BLUE.color),
                    child: Container(
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => rubicsCubeSideOrange = rubicsCubeSide),
                  child: CustomPaint(
                    painter: CubeStatePainter(rubicsCubeSideOrange, RubicsCubeColor.ORANGE.color),
                    child: Container(
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => rubicsCubeSideGreen = rubicsCubeSide),
                  child: CustomPaint(
                    painter: CubeStatePainter(rubicsCubeSideGreen, RubicsCubeColor.GREEN.color),
                    child: Container(
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => rubicsCubeSideRed = rubicsCubeSide),
                  child: CustomPaint(
                    painter: CubeStatePainter(rubicsCubeSideRed, RubicsCubeColor.RED.color),
                    child: Container(
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => rubicsCubeSideYellow = rubicsCubeSide),
                  child: CustomPaint(
                    painter: CubeStatePainter(rubicsCubeSideYellow, RubicsCubeColor.YELLOW.color),
                    child: Container(
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => rubicsCubeSideWhite = rubicsCubeSide),
                  child: CustomPaint(
                    painter: CubeStatePainter(rubicsCubeSideWhite, RubicsCubeColor.WHITE.color),
                    child: Container(
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: rubicsCubeSideBlue != null && rubicsCubeSideOrange != null && rubicsCubeSideGreen != null && rubicsCubeSideRed != null && rubicsCubeSideYellow != null && rubicsCubeSideWhite != null
                      ? () {
                          RubicsCube rubicsCube = RubicsCube(
                            rubicsCubeSideBlue,
                            rubicsCubeSideOrange,
                            rubicsCubeSideGreen,
                            rubicsCubeSideRed,
                            rubicsCubeSideYellow,
                            rubicsCubeSideWhite,
                          );
                          ClipboardManager.copyToClipBoard(rubicsCube.toJson().toString()).then((result) {
                            final snackBar = SnackBar(
                              content: Text("JSON in Zwischenablage kopiert"),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          });
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// [CustomPainter] that can be used in the [CustomPaint] widget to visualize the state of a [RubicsCubeSide] in the UI.
class CubeStatePainter extends CustomPainter {
  /// The [RubicsCubeSide] to visualize.
  RubicsCubeSide rubicsCubeSide;

  /// [Color] of the center tile of a [RubicsCubeSide].
  Color centerColor;

  /// Default Constructor.
  CubeStatePainter(this.rubicsCubeSide, this.centerColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (rubicsCubeSide != null) {
      canvas.drawRect(Rect.fromLTWH(0 * size.height / 3, 0 * size.height / 3, size.width / 3, size.height / 3), Paint()..color = rubicsCubeSide.topLeft.color);
      canvas.drawRect(Rect.fromLTWH(1 * size.height / 3, 0 * size.height / 3, size.width / 3, size.height / 3), Paint()..color = rubicsCubeSide.topMid.color);
      canvas.drawRect(Rect.fromLTWH(2 * size.height / 3, 0 * size.height / 3, size.width / 3, size.height / 3), Paint()..color = rubicsCubeSide.topRight.color);
      canvas.drawRect(Rect.fromLTWH(0 * size.height / 3, 1 * size.height / 3, size.width / 3, size.height / 3), Paint()..color = rubicsCubeSide.left.color);
      canvas.drawRect(Rect.fromLTWH(1 * size.height / 3, 1 * size.height / 3, size.width / 3, size.height / 3), Paint()..color = rubicsCubeSide.center.color);
      canvas.drawRect(Rect.fromLTWH(2 * size.height / 3, 1 * size.height / 3, size.width / 3, size.height / 3), Paint()..color = rubicsCubeSide.right.color);
      canvas.drawRect(Rect.fromLTWH(0 * size.height / 3, 2 * size.height / 3, size.width / 3, size.height / 3), Paint()..color = rubicsCubeSide.bottomLeft.color);
      canvas.drawRect(Rect.fromLTWH(1 * size.height / 3, 2 * size.height / 3, size.width / 3, size.height / 3), Paint()..color = rubicsCubeSide.bottomMid.color);
      canvas.drawRect(Rect.fromLTWH(2 * size.height / 3, 2 * size.height / 3, size.width / 3, size.height / 3), Paint()..color = rubicsCubeSide.bottomRight.color);
    } else {
      canvas.drawRect(Rect.fromLTWH(1 * size.height / 3, 1 * size.height / 3, size.width / 3, size.height / 3), Paint()..color = centerColor);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
