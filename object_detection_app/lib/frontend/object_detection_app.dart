import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:object_detection_app/frontend/ball_and_cube_detection_page.dart';
import 'package:object_detection_app/frontend/ball_state_detection_page.dart';
import 'package:object_detection_app/frontend/cube_state_detection_page.dart';
import 'package:tflite/tflite.dart';

class ObjectDetectionApp extends StatefulWidget {
  @override
  _ObjectDetectionAppState createState() => _ObjectDetectionAppState();
}

enum ObjectDetectionAppModes {
  BALL_AND_CUBE_DETECTION,
  BALL_STATE_DETECTION,
  CUBE_STATE_DETECTION,
}

class _ObjectDetectionAppState extends State<ObjectDetectionApp> {
  ObjectDetectionAppModes mode = ObjectDetectionAppModes.BALL_AND_CUBE_DETECTION;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: "GKI",
      home: Scaffold(
        appBar: AppBar(title: Text("GKI")),
        drawer: Builder(
          builder: (context) {
            return Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(),
                  ListTile(
                    trailing: Text("Cube & Ball Detection"),
                    onTap: () => setState(() {
                      mode = ObjectDetectionAppModes.BALL_AND_CUBE_DETECTION;
                      Navigator.of(context).pop();
                    }),
                  ),
                  ListTile(
                    trailing: Text("Cube State Detection"),
                    onTap: () => setState(() {
                      mode = ObjectDetectionAppModes.CUBE_STATE_DETECTION;
                      Navigator.of(context).pop();
                    }),
                  ),
                  ListTile(
                    trailing: Text("Ball State Detection"),
                    onTap: () => setState(() {
                      mode = ObjectDetectionAppModes.BALL_STATE_DETECTION;
                      Navigator.of(context).pop();
                    }),
                  ),
                ],
              ),
            );
          },
        ),
        body: FutureBuilder(
          future: availableCameras(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CameraDescription> cameras = snapshot.data;
              CameraController cameraController = CameraController(cameras[0], ResolutionPreset.ultraHigh);
              return FutureBuilder(
                future: cameraController.initialize(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    switch (mode) {
                      case ObjectDetectionAppModes.BALL_AND_CUBE_DETECTION:
                        return FutureBuilder(
                          future: Tflite.loadModel(
                            model: "assets/ball&cube.tflite",
                            labels: "assets/ball&cube.txt",
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return BallAndCubeDetectionPage(cameraController);
                            } else {
                              return Container();
                            }
                          },
                        );
                      case ObjectDetectionAppModes.BALL_STATE_DETECTION:
                        return FutureBuilder(
                          future: Tflite.loadModel(
                            model: "assets/ball_state.tflite",
                            labels: "assets/ball_state.txt",
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return BallStateDetectionPage(cameraController);
                            } else {
                              return Container();
                            }
                          },
                        );
                      case ObjectDetectionAppModes.CUBE_STATE_DETECTION:
                        return FutureBuilder(
                          future: Tflite.loadModel(
                            model: "assets/cube_state.tflite",
                            labels: "assets/cube_state.txt",
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return CubeStateDetectionPage(cameraController);
                            } else {
                              return Container();
                            }
                          },
                        );
                    }
                    throw Exception();
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
