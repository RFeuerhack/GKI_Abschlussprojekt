import 'package:app/cube/rubics_cube.dart';
import 'package:app/util/detection.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'object_detection_camera.dart';

/// Defines the structure of the UI, which allows the user to detect [MagicRainbowBall]s and [RubicsCube]s via the smartphone camera.
class BallAndCubeDetectionPage extends StatefulWidget {
  /// The camera that is used for the detection task.
  final CameraController cameraController;

  /// Default Constructor.
  BallAndCubeDetectionPage(this.cameraController);

  @override
  _BallAndCubeDetectionPageState createState() => _BallAndCubeDetectionPageState(cameraController);
}

/// State of the [BallAndCubeDetectionPage].
class _BallAndCubeDetectionPageState extends State<BallAndCubeDetectionPage> {
  /// The camera that is used for the detection task.
  CameraController cameraController;

  /// Default constructor.
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
