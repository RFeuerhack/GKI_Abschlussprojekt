import 'package:flutter/material.dart' as flutter;

/// Represents the balls of the Magic Rainbow Ball.
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

/// Extension of [Ball].
extension BallExtension on Ball {
  /// Gives access to colors map.
  flutter.Color get color => _ballColors[this];
}

/// Assigns every Ball a color, which is usable in Flutter.
Map<Ball, flutter.Color> _ballColors = {
  Ball.EMPTY: flutter.Colors.grey,
  Ball.BLACK: flutter.Colors.black,
  Ball.LIGHT_GREEN: flutter.Colors.lightGreen,
  Ball.DARK_GREEN: flutter.Colors.green,
  Ball.LIGHT_BLUE: flutter.Colors.lightBlue,
  Ball.DARK_BLUE: flutter.Colors.blue,
  Ball.YELLOW: flutter.Colors.yellow,
  Ball.ORANGE: flutter.Colors.orange,
  Ball.RED: flutter.Colors.red,
  Ball.PINK: flutter.Colors.pink,
  Ball.PURPLE: flutter.Colors.purple,
  Ball.CYAN: flutter.Colors.cyan,
};
