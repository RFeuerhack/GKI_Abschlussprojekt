import 'package:delta_e/delta_e.dart';
import 'package:flutter/material.dart';

/// Contains all colors of the [RubicsCube].
enum RubicsCubeColor {
  WHITE,
  YELLOW,
  BLUE,
  GREEN,
  ORANGE,
  RED,
}

/// Extension of [RubicsCubeColor].
extension RubicsCubeColorExtension on RubicsCubeColor {
  /// Gives access to the [labColorsOfCubeColors] map.
  LabColor get labColor => labColorsOfCubeColors[this];

  /// Gives access to [colors] map.
  Color get color => colors[this];

  /// Converts a [RubicsCubeColor] to json.
  String toJson() => this.toString().replaceFirst("RubicsCubeColor.", "").toLowerCase();
}

/// Assigns every [RubicsCubeColor] a [Color], which can be used in Flutter.
Map<RubicsCubeColor, Color> colors = {
  RubicsCubeColor.WHITE: Colors.white,
  RubicsCubeColor.YELLOW: Colors.yellow,
  RubicsCubeColor.BLUE: Colors.blue,
  RubicsCubeColor.GREEN: Colors.green,
  RubicsCubeColor.ORANGE: Colors.orange,
  RubicsCubeColor.RED: Colors.red,
};

/// Assigns every [RubicsCubeColor] a [LabColor] representing the [Color].
Map<RubicsCubeColor, LabColor> labColorsOfCubeColors = {
  RubicsCubeColor.WHITE: LabColor.fromRGBValue(4291811288, RGBStructure.argb),
  RubicsCubeColor.YELLOW: LabColor.fromRGBValue(4289579308, RGBStructure.argb),
  RubicsCubeColor.BLUE: LabColor.fromRGBValue(4278551999, RGBStructure.argb),
  RubicsCubeColor.GREEN: LabColor.fromRGBValue(4278233924, RGBStructure.argb),
  RubicsCubeColor.ORANGE: LabColor.fromRGBValue(4294794566, RGBStructure.argb),
  RubicsCubeColor.RED: LabColor.fromRGBValue(4289010460, RGBStructure.argb),
};
