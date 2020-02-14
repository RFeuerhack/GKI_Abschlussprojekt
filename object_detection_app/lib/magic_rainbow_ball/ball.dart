import 'package:flutter/material.dart' as flutter;

/// represents the balls of a magic rainbow ball
enum Ball {
  EMPTY,
  BLACK,
  LIGHT_GREEN,
  DARK_GREEN,
  LIGHT_BLUE,
  DARK_BLUE,
  YELLOW,
  ORANGE,
  RED,
  PINK,
  PURPLE,
  CYAN,
}

/// assigns every Ball a flutter color, which is usable in the frontend
Map<Ball, flutter.Color> colors = {
  Ball.EMPTY : flutter.Colors.grey,
  Ball.BLACK : flutter.Colors.black,
  Ball.LIGHT_GREEN : flutter.Colors.lightGreen,
  Ball.DARK_GREEN : flutter.Colors.green,
  Ball.LIGHT_BLUE : flutter.Colors.lightBlue,
  Ball.DARK_BLUE : flutter.Colors.blue,
  Ball.YELLOW : flutter.Colors.yellow,
  Ball.ORANGE : flutter.Colors.orange,
  Ball.RED : flutter.Colors.red,
  Ball.PINK : flutter.Colors.pink,
  Ball.PURPLE : flutter.Colors.purple,
  Ball.CYAN : flutter.Colors.cyan,
};

/// extends the enum Ball by some methods
extension on Ball {
  /// gives access to colors map
  flutter.Color get color => colors[this];
}
