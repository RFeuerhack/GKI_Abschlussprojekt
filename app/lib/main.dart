/// This dart file contains the main function of the app.

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'frontend/object_detection_app.dart';

/// Contains all available cameras.
List<CameraDescription> cameras;

/// Entry point of the app.
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(ObjectDetectionApp());
}
