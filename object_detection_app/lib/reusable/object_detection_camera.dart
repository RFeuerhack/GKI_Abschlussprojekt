import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection_app/rubics_cube/ball_side_analyser.dart';
import 'package:object_detection_app/util/detection.dart';
import 'package:tflite/tflite.dart';

class ObjectDetectionCamera extends StatefulWidget {
  final CameraController cameraController;
  final Function onDetection;
  final double threshhold;

  ObjectDetectionCamera(this.cameraController, this.onDetection, this.threshhold);

  @override
  _ObjectDetectionCameraState createState() => _ObjectDetectionCameraState(cameraController, onDetection, threshhold);
}

class _ObjectDetectionCameraState extends State<ObjectDetectionCamera> {
  CameraController cameraController;
  Function onDetection;
  double threshhold;

  _ObjectDetectionCameraState(this.cameraController, this.onDetection, this.threshhold);

  bool isDetecting = false;
  List<Detection> detections = [];

  @override
  void initState() {
    super.initState();
    cameraController.startImageStream((CameraImage image) {
      if (!isDetecting) {
        isDetecting = true;
        Tflite.detectObjectOnFrame(
          bytesList: image.planes.map((plane) => plane.bytes).toList(),
          imageHeight: image.height,
          imageWidth: image.width,
        ).then((detections) {
          if (mounted) {
            setState(() {
              isDetecting = false;
              this.detections = detections.map((detection) => Detection.fromJson(Map<String, dynamic>.from(detection))).toList();
            });
            if (detections.length != 0) {
              onDetection(image, this.detections);
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController.value.isInitialized) {
      return AspectRatio(
        aspectRatio: cameraController.value.aspectRatio,
        child: Stack(
          children: <Widget>[
            CameraPreview(cameraController),
            SizedBox.expand(child: CustomPaint(painter: ObjectDetectionPainter(detections, threshhold))),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class ObjectDetectionPainter extends CustomPainter {
  List<Detection> detections;
  double threshhold;

  ObjectDetectionPainter(this.detections, this.threshhold);

  @override
  void paint(Canvas canvas, Size size) {
    detections.forEach((detection) {
      if (detection.confidenceInClass > threshhold) {
        canvas.drawRect(
          Rect.fromLTWH(
            detection.x * size.width,
            detection.y * size.height,
            detection.w * size.width,
            detection.h * size.height,
          ),
          Paint()
            ..color = Colors.black
            ..strokeWidth = 5
            ..style = PaintingStyle.stroke,
        );
        TextSpan textSpan = TextSpan(text: detection.detectedClass + ": " + (detection.confidenceInClass * 100).round().toString() + "%", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20));
        TextPainter textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
        textPainter.layout();
        textPainter.paint(canvas, Offset(detection.x * size.width + 0.5 * detection.w * size.width - 0.5 * textPainter.width, detection.y * size.height + 0.5 * detection.h * size.height));
      }
    });
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
