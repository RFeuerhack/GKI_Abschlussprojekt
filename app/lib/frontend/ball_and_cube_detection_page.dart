import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:app/frontend/object_detection_camera.dart';
import 'package:app/util/detection.dart';

class BallAndCubeDetectionPage extends StatefulWidget {
  final CameraController cameraController;

  BallAndCubeDetectionPage(this.cameraController);

  @override
  _BallAndCubeDetectionPageState createState() => _BallAndCubeDetectionPageState(cameraController);
}

class _BallAndCubeDetectionPageState extends State<BallAndCubeDetectionPage> {
  CameraController cameraController;

  _BallAndCubeDetectionPageState(this.cameraController);

  @override
  Widget build(BuildContext context) {
    return ObjectDetectionCamera(
      cameraController,
      (image, List<Detection> detections) {},
      0.8,
    );
  }
}
