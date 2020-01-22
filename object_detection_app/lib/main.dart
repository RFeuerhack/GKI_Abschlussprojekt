import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'frontend/object_detection_app.dart';

List<CameraDescription> cameras;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(ObjectDetectionApp());
}
