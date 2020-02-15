import 'dart:ui';

import 'package:app/util/detection.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

/// Custom widget that contains a camera view in which detections are marked with black rectangles surrounding them.
/// Disclaimer: In order for this widget to work there has to be a model loaded into the TFLite plugin.
class ObjectDetectionCamera extends StatefulWidget {
  /// The camera that is used for the detection task.
  final CameraController cameraController;

  /// [Function] that gets called, when something is detected.
  final Function onDetection;

  /// Threshhold for confidence, that needs to be surpassed in order for a detection to be accepted.
  final double threshhold;

  /// [Function] that gets called, when nothing is detected.
  final Function onNoDetection;

  /// Default constructor.
  ObjectDetectionCamera(this.cameraController, this.onDetection, this.threshhold, [this.onNoDetection]);

  @override
  _ObjectDetectionCameraState createState() => _ObjectDetectionCameraState(cameraController, onDetection, threshhold, onNoDetection);
}

/// State of the [ObjectDetectionCamera].
class _ObjectDetectionCameraState extends State<ObjectDetectionCamera> {
  /// The camera that is used for the detection task.
  CameraController cameraController;

  /// [Function] that gets called, when something is detected.
  Function onDetection;

  /// Threshhold for confidence, that needs to be surpassed in order for a detection to be accepted.
  double threshhold;

  /// [Function] that gets called, when nothing is detected.
  Function onNoDetection;

  /// Default constructor.
  _ObjectDetectionCameraState(this.cameraController, this.onDetection, this.threshhold, this.onNoDetection);

  /// [bool] that indicates whether or not the TFLite plugin is busy with analyzing a frame.
  bool isDetecting = false;

  /// Contains all current [Detection]s.
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
            } else {
              if (onNoDetection != null) {
                onNoDetection(image);
              }
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

/// [CustomPainter] that can be used in the [CustomPaint] widget and laid over a [CameraPreview] to mark detections in the video.
class ObjectDetectionPainter extends CustomPainter {
  /// All detections that should get marked.
  List<Detection> detections;

  /// Treshhold which the confindenceScore of a [Detection] has to surpass in order to get marked.
  double threshhold;

  /// Default constructor.
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
