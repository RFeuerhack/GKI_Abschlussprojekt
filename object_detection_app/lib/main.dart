import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'frontend/object_detection_app.dart';

/// list of available cameras
List<CameraDescription> cameras;

/// entry point of the app
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(ObjectDetectionApp());
}
