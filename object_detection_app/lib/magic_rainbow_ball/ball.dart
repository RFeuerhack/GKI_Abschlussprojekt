import 'package:flutter/material.dart' as flutter;

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

Map<Ball, flutter.Color> colors = {
  Ball.EMPTY : flutter.Colors.transparent,
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

extension on Ball {
  flutter.Color get color => colors[this];
}