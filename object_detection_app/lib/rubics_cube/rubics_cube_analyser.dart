import 'package:camera/camera.dart';
import 'package:delta_e/delta_e.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:image/image.dart';

/// parses the subimage (x, y, width, height) containing the side of a rubicscube
RubicsCubeSideState parsePartOfCameraImageOfRubicsCubeSide(CameraImage image, int x, int y, int width, int height) {
  Image rgbImage = convertYUV420toImageColor(image);

  LabColor topLeftHue = getLabColorFromRotatedPosition(
    rgbImage,
    Point(x + (width * 1 ~/ 6), y + (height * 1 ~/ 6)),
    image.height,
  );

  LabColor topMidHue = getLabColorFromRotatedPosition(
    rgbImage,
    Point(x + (width * 3 ~/ 6), y + (height * 1 ~/ 6)),
    image.height,
  );

  LabColor topRightHue = getLabColorFromRotatedPosition(
    rgbImage,
    Point(x + (width * 5 ~/ 6), y + (height * 1 ~/ 6)),
    image.height,
  );

  LabColor leftHue = getLabColorFromRotatedPosition(
    rgbImage,
    Point(x + (width * 1 ~/ 6), y + (height * 3 ~/ 6)),
    image.height,
  );

  LabColor centerHue = getLabColorFromRotatedPosition(
    rgbImage,
    Point(x + (width * 3 ~/ 6), y + (height * 3 ~/ 6)),
    image.height,
  );

  LabColor rightHue = getLabColorFromRotatedPosition(
    rgbImage,
    Point(x + (width * 5 ~/ 6), y + (height * 3 ~/ 6)),
    image.height,
  );

  LabColor bottomLeftHue = getLabColorFromRotatedPosition(
    rgbImage,
    Point(x + (width * 1 ~/ 6), y + (height * 5 ~/ 6)),
    image.height,
  );

  LabColor bottomMidHue = getLabColorFromRotatedPosition(
    rgbImage,
    Point(x + (width * 3 ~/ 6), y + (height * 5 ~/ 6)),
    image.height,
  );

  LabColor bottomRightHue = getLabColorFromRotatedPosition(
    rgbImage,
    Point(x + (width * 5 ~/ 6), y + (height * 5 ~/ 6)),
    image.height,
  );

  return RubicsCubeSideState.fromLabColors(
    topLeftHue,
    topMidHue,
    topRightHue,
    leftHue,
    centerHue,
    rightHue,
    bottomLeftHue,
    bottomMidHue,
    bottomRightHue,
  );
}

/// returns a labcolor from a given coordinate in an image stored vertically (CameraImage -> Image) with a given height
LabColor getLabColorFromRotatedPosition(Image image, Point point, int height) {
  Point pointRotated = rotate(point, height);
  int argb = image.getPixel(pointRotated.x, pointRotated.y);
  return fromARGBReversed(argb);
}

/// rotates a point by 90 degrees in an image with a given height
/// disclaimer: needed because camera images are stored rotated
Point rotate(Point point, int height) => Point(point.y, height - point.x);

/// restructures argb from 01234567 (argb) to 01674523 (abgr)
LabColor fromARGBReversed(int reversedArgb) {
  String s = reversedArgb.toRadixString(16);
  String s1 = s[0] + "" + s[1] + "" + s[6] + "" + s[7] + "" + s[4] + "" + s[5] + "" + s[2] + "" + s[3];
  int reversedARGB = int.parse(s1, radix: 16);
  return LabColor.fromRGBValue(reversedARGB, RGBStructure.argb);
}

/// represents all colors of the rubicscube
enum RubicsCubeColor {
  WHITE,
  YELLOW,
  BLUE,
  GREEN,
  ORANGE,
  RED,
}

/// extends the RubicsCubeColor enum by some methods
extension on RubicsCubeColor {
  /// gives access to hues map
  LabColor get labColor => hues[this];

  /// gives access to colors map
  flutter.Color color() => colors[this];

  /// converts RubicsCubeColor to json
  String toJson() => this.toString().replaceFirst("RubicsCubeColor.", "").toLowerCase();
}

/// assigns every rubicscube color a flutter color which can be used in the ui
Map<RubicsCubeColor, flutter.Color> colors = {
  RubicsCubeColor.WHITE: flutter.Colors.white,
  RubicsCubeColor.YELLOW: flutter.Colors.yellow,
  RubicsCubeColor.BLUE: flutter.Colors.blue,
  RubicsCubeColor.GREEN: flutter.Colors.green,
  RubicsCubeColor.ORANGE: flutter.Colors.orange,
  RubicsCubeColor.RED: flutter.Colors.red,
};

/// assigns every rubicscube color a labcolor representing the color
/// the values where measured in a room at daytime with, while the sun was not shining very bright
Map<RubicsCubeColor, LabColor> hues = {
  RubicsCubeColor.WHITE: LabColor.fromRGBValue(4291811288, RGBStructure.argb),
  RubicsCubeColor.YELLOW: LabColor.fromRGBValue(4289579308, RGBStructure.argb),
  RubicsCubeColor.BLUE: LabColor.fromRGBValue(4278551999, RGBStructure.argb),
  RubicsCubeColor.GREEN: LabColor.fromRGBValue(4278233924, RGBStructure.argb),
  RubicsCubeColor.ORANGE: LabColor.fromRGBValue(4294794566, RGBStructure.argb),
  RubicsCubeColor.RED: LabColor.fromRGBValue(4289010460, RGBStructure.argb),
};

class RubicsCubeState {
  /// state of rubics cube with blue center tile
  RubicsCubeSideState blue;
  /// state of rubics cube with orange center tile
  RubicsCubeSideState orange;
  /// state of rubics cube with green center tile
  RubicsCubeSideState green;
  /// state of rubics cube with red center tile
  RubicsCubeSideState red;
  /// state of rubics cube with yellow center tile
  RubicsCubeSideState yellow;
  /// state of rubics cube with white center tile
  RubicsCubeSideState white;

  /// default constructor
  RubicsCubeState(
    this.blue,
    this.orange,
    this.green,
    this.red,
    this.yellow,
    this.white,
  );

  /// converts RubicsCubeState to json
  Map<String, dynamic> toJson() => {
        '\"' + "blue" + '\"': blue.toJson(),
        '\"' + "orange" + '\"': orange.toJson(),
        '\"' + "green" + '\"': green.toJson(),
        '\"' + "red" + '\"': red.toJson(),
        '\"' + "yellow" + '\"': yellow.toJson(),
        '\"' + "white" + '\"': white.toJson(),
      };
}

/// represents the state of a side of a rubicscube
class RubicsCubeSideState {
  /// color of top left tile of rubicscube side
  RubicsCubeColor topLeft;
  /// color of top mid tile of rubicscube side
  RubicsCubeColor topMid;
  /// color of top right tile of rubicscube side
  RubicsCubeColor topRight;
  /// color of left tile of rubicscube side
  RubicsCubeColor left;
  /// color of center tile of rubicscube side
  RubicsCubeColor center;
  /// color of right tile of rubicscube side
  RubicsCubeColor right;
  /// color of bottom left tile of rubicscube side
  RubicsCubeColor bottomLeft;
  /// color of bottom mid tile of rubicscube side
  RubicsCubeColor bottomMid;
  /// color of bottom right tile of rubicscube side
  RubicsCubeColor bottomRight;

  /// default constructor
  RubicsCubeSideState(
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

  /// converts RubicsCubeSideState to json
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

  /// creates a RubicsCubeSideState from every labcolor found on the side of the rubicscube
  RubicsCubeSideState.fromLabColors(
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
    this.topLeft = rubicsCubeColorFromHue(topLeftHue);
    this.topMid = rubicsCubeColorFromHue(topMidHue);
    this.topRight = rubicsCubeColorFromHue(topRightHue);
    this.left = rubicsCubeColorFromHue(leftHue);
    this.center = rubicsCubeColorFromHue(centerHue);
    this.right = rubicsCubeColorFromHue(rightHue);
    this.bottomLeft = rubicsCubeColorFromHue(bottomLeftHue);
    this.bottomMid = rubicsCubeColorFromHue(bottomMidHue);
    this.bottomRight = rubicsCubeColorFromHue(bottomRightHue);
  }
}


/// determines a color e.g. "red" from a given labcolor by comparing the value of the labcolor to the constant labcolor representing each rubicscube color
RubicsCubeColor rubicsCubeColorFromHue(LabColor labColor) {
  return RubicsCubeColor.values.map((rubicsCubeColor) => {"rubicsCubeColor": rubicsCubeColor, "deltaE": deltaE00(rubicsCubeColor.labColor, labColor)}).reduce((v, e) {
    double vHueDelta = v["deltaE"] as double;
    double eHueDelta = e["deltaE"] as double;
    return vHueDelta < eHueDelta ? v : e;
  })["rubicsCubeColor"];
}

/// code snippet taken from: "https://stackoverflow.com/questions/57603146/how-to-convert-camera-image-to-image-in-flutter"
/// converts CameraImage to Image (Image class allows reading rgb at a given coordinate)
Image convertYUV420toImageColor(CameraImage image) {
  try {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel;

    // imgLib -> Image package from https://pub.dartlang.org/packages/image
    var img = Image(width, height); // Create Image buffer

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex = uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91).round().clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data[index] = (0xFF << 24) | (b << 16) | (g << 8) | r;
      }
    }

    return img;
  } catch (e) {
    print(">>>>>>>>>>>> ERROR:" + e.toString());
  }
  return null;
}
