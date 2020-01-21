import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection_app/rubics_cube/ball_side_analyser.dart';
import 'package:object_detection_app/util/detection.dart';
import 'package:object_detection_app/reusable/object_detection_camera.dart';

class CubeStateDetectionPage extends StatefulWidget {
  final CameraController cameraController;

  CubeStateDetectionPage(this.cameraController);

  @override
  _CubeStateDetectionPageState createState() => _CubeStateDetectionPageState(cameraController);
}

class _CubeStateDetectionPageState extends State<CubeStateDetectionPage> {
  CameraController cameraController;
  RubicsCubeSide rubicsCubeSide;

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
              rubicsCubeSide = parseImageOfRubicsCubeSide(
                image,
                (detection.x * image.height).toInt(),
                (detection.y * image.width).toInt(),
                (detection.w * image.height).toInt(),
                (detection.h * image.width).toInt(),
              );
            });
          },
          0.7,
        ),
        SizedBox.expand(child: CustomPaint(painter: CubeStatePainter(rubicsCubeSide))),
      ],
    );
  }
}

class CubeStatePainter extends CustomPainter {
  RubicsCubeSide rubicsCubeSide;

  CubeStatePainter(this.rubicsCubeSide);

  @override
  void paint(Canvas canvas, Size size) {
    if (rubicsCubeSide != null) {
      canvas.drawRect(Rect.fromLTWH(10, 10, 10, 10), Paint()..color = rubicsCubeSide.topLeft.color);
      canvas.drawRect(Rect.fromLTWH(30, 10, 10, 10), Paint()..color = rubicsCubeSide.topMid.color);
      canvas.drawRect(Rect.fromLTWH(50, 10, 10, 10), Paint()..color = rubicsCubeSide.topRight.color);
      canvas.drawRect(Rect.fromLTWH(10, 30, 10, 10), Paint()..color = rubicsCubeSide.left.color);
      canvas.drawRect(Rect.fromLTWH(30, 30, 10, 10), Paint()..color = rubicsCubeSide.center.color);
      canvas.drawRect(Rect.fromLTWH(50, 30, 10, 10), Paint()..color = rubicsCubeSide.right.color);
      canvas.drawRect(Rect.fromLTWH(10, 50, 10, 10), Paint()..color = rubicsCubeSide.bottomLeft.color);
      canvas.drawRect(Rect.fromLTWH(30, 50, 10, 10), Paint()..color = rubicsCubeSide.bottomMid.color);
      canvas.drawRect(Rect.fromLTWH(50, 50, 10, 10), Paint()..color = rubicsCubeSide.bottomRight.color);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

extension on RubicsCubeColor {
  Color get color => colors[this];
}

Map<RubicsCubeColor, Color> colors = {
  RubicsCubeColor.WHITE: Colors.white,
  RubicsCubeColor.YELLOW: Colors.yellow,
  RubicsCubeColor.BLUE: Colors.blue,
  RubicsCubeColor.GREEN: Colors.green,
  RubicsCubeColor.ORANGE: Colors.orange,
  RubicsCubeColor.RED: Colors.red,
};
