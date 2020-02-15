import 'rubics_cube_side.dart';

/// Represents the state of a Rubic's Cube.
class RubicsCube {
  /// [RubicsCubeSide] with blue center tile..
  RubicsCubeSide blue;

  /// [RubicsCubeSide] with orange center tile.
  RubicsCubeSide orange;

  /// [RubicsCubeSide] with green center tile.
  RubicsCubeSide green;

  ///[RubicsCubeSide] with red center tile.
  RubicsCubeSide red;

  /// [RubicsCubeSide] with yellow center tile.
  RubicsCubeSide yellow;

  /// [RubicsCubeSide] with white center tile.
  RubicsCubeSide white;

  /// Default constructor.
  RubicsCube(
    this.blue,
    this.orange,
    this.green,
    this.red,
    this.yellow,
    this.white,
  );

  /// Converts the [RubicsCube] to json.
  Map<String, dynamic> toJson() => {
        '\"' + "blue" + '\"': blue.toJson(),
        '\"' + "orange" + '\"': orange.toJson(),
        '\"' + "green" + '\"': green.toJson(),
        '\"' + "red" + '\"': red.toJson(),
        '\"' + "yellow" + '\"': yellow.toJson(),
        '\"' + "white" + '\"': white.toJson(),
      };
}
