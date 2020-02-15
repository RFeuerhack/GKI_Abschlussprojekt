import 'package:delta_e/delta_e.dart';

import 'rubics_cube_analyse.dart';
import 'rubics_cube_color.dart';

/// Represents the state of a [RubicsCubeSide] of a [RubicsCube].
class RubicsCubeSide {
  /// [RubicsCubeColor] of the top left tile of a [RubicsCubeSide].
  RubicsCubeColor topLeft;

  /// [RubicsCubeColor] of the top mid tile of a [RubicsCubeSide].
  RubicsCubeColor topMid;

  /// [RubicsCubeColor] of the top right tile of a [RubicsCubeSide].
  RubicsCubeColor topRight;

  /// [RubicsCubeColor] of the left tile of a [RubicsCubeSide].
  RubicsCubeColor left;

  /// [RubicsCubeColor] of the center tile of a [RubicsCubeSide].
  RubicsCubeColor center;

  /// [RubicsCubeColor] of the right tile of a [RubicsCubeSide].
  RubicsCubeColor right;

  /// [RubicsCubeColor] of the bottom left tile of a [RubicsCubeSide].
  RubicsCubeColor bottomLeft;

  /// [RubicsCubeColor] of the bottom mid tile of a [RubicsCubeSide].
  RubicsCubeColor bottomMid;

  /// [RubicsCubeColor] of the bottom right tile of a [RubicsCubeSide].
  RubicsCubeColor bottomRight;

  /// Default constructor.
  RubicsCubeSide(
    this.topLeft,
    this.topMid,
    this.topRight,
    this.left,
    this.center,
    this.right,
    this.bottomLeft,
    this.bottomMid,
    this.bottomRight,
  );

  /// Converts a [RubicsCubeSideState] to json.
  Map<String, dynamic> toJson() => {
        '\"' + "top_left" + '\"': '\"' + topLeft.toJson() + '\"',
        '\"' + "top_mid" + '\"': '\"' + topMid.toJson() + '\"',
        '\"' + "top_right" + '\"': '\"' + topRight.toJson() + '\"',
        '\"' + "left" + '\"': '\"' + left.toJson() + '\"',
        '\"' + "center" + '\"': '\"' + center.toJson() + '\"',
        '\"' + "right" + '\"': '\"' + right.toJson() + '\"',
        '\"' + "bottom_left" + '\"': '\"' + bottomLeft.toJson() + '\"',
        '\"' + "bottom_mid" + '\"': '\"' + bottomMid.toJson() + '\"',
        '\"' + "bottom_right" + '\"': '\"' + bottomRight.toJson() + '\"',
      };

  /// Creates a [RubicsCubeSide] from every [LabColor] of every tile on the [RubicsCubeSide].
  RubicsCubeSide.fromLabColors(
    LabColor topLeftHue,
    LabColor topMidHue,
    LabColor topRightHue,
    LabColor leftHue,
    LabColor centerHue,
    LabColor rightHue,
    LabColor bottomLeftHue,
    LabColor bottomMidHue,
    LabColor bottomRightHue,
  ) {
    this.topLeft = rubicsCubeColorLabColor(topLeftHue);
    this.topMid = rubicsCubeColorLabColor(topMidHue);
    this.topRight = rubicsCubeColorLabColor(topRightHue);
    this.left = rubicsCubeColorLabColor(leftHue);
    this.center = rubicsCubeColorLabColor(centerHue);
    this.right = rubicsCubeColorLabColor(rightHue);
    this.bottomLeft = rubicsCubeColorLabColor(bottomLeftHue);
    this.bottomMid = rubicsCubeColorLabColor(bottomMidHue);
    this.bottomRight = rubicsCubeColorLabColor(bottomRightHue);
  }
}
