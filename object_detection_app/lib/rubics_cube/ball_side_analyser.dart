import 'package:camera/camera.dart';
import 'package:delta_e/delta_e.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:image/image.dart';

RubicsCubeSideState parseImageOfRubicsCubeSide(CameraImage image, int x, int y, int width, int height) {
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

LabColor getLabColorFromRotatedPosition(Image image, Point point, int height) {
  Point pointRotated = rotate(point, height);
  int argb = image.getPixel(pointRotated.x, pointRotated.y);
  return fromARGBReversed(argb);
}

LabColor fromARGBReversed(int argb) {
  String s = argb.toRadixString(16);
  String s1 = s[0] + "" + s[1] + "" + s[6] + "" + s[7] + "" + s[4] + "" + s[5] + "" + s[2] + "" + s[3];
  int reversedARGB = int.parse(s1, radix: 16);
  print(reversedARGB);
  print(reversedARGB.toRadixString(16));
  return LabColor.fromRGBValue(reversedARGB, RGBStructure.argb);
}

Point rotate(Point point, int height) => Point(point.y, height - point.x);

enum RubicsCubeColor {
  WHITE,
  YELLOW,
  BLUE,
  GREEN,
  ORANGE,
  RED,
}

extension on RubicsCubeColor {
  LabColor get labColor => hues[this];

  flutter.Color color() => colors[this];

  String toJson() => this.toString().replaceFirst("RubicsCubeColor.", "").toLowerCase();
}

Map<RubicsCubeColor, flutter.Color> colors = {
  RubicsCubeColor.WHITE: flutter.Colors.white,
  RubicsCubeColor.YELLOW: flutter.Colors.yellow,
  RubicsCubeColor.BLUE: flutter.Colors.blue,
  RubicsCubeColor.GREEN: flutter.Colors.green,
  RubicsCubeColor.ORANGE: flutter.Colors.orange,
  RubicsCubeColor.RED: flutter.Colors.red,
};

Map<RubicsCubeColor, LabColor> hues = {
  RubicsCubeColor.WHITE: LabColor.fromRGBValue(4291811288, RGBStructure.argb),
  RubicsCubeColor.YELLOW: LabColor.fromRGBValue(4289579308, RGBStructure.argb),
  RubicsCubeColor.BLUE: LabColor.fromRGBValue(4278551999, RGBStructure.argb),
  RubicsCubeColor.GREEN: LabColor.fromRGBValue(4278233924, RGBStructure.argb),
  RubicsCubeColor.ORANGE: LabColor.fromRGBValue(4294794566, RGBStructure.argb),
  RubicsCubeColor.RED: LabColor.fromRGBValue(4289010460, RGBStructure.argb),
};

class RubicsCubeState {
  RubicsCubeSideState blue;
  RubicsCubeSideState orange;
  RubicsCubeSideState green;
  RubicsCubeSideState red;
  RubicsCubeSideState yellow;
  RubicsCubeSideState white;

  RubicsCubeState(
    this.blue,
    this.orange,
    this.green,
    this.red,
    this.yellow,
    this.white,
  );

  Map<String, dynamic> toJson() => {
        '\"' + "blue" + '\"': blue.toJson(),
        '\"' + "orange" + '\"': orange.toJson(),
        '\"' + "green" + '\"': green.toJson(),
        '\"' + "red" + '\"': red.toJson(),
        '\"' + "yellow" + '\"': yellow.toJson(),
        '\"' + "white" + '\"': white.toJson(),
      };
}

class RubicsCubeSideState {
  RubicsCubeColor topLeft;
  RubicsCubeColor topMid;
  RubicsCubeColor topRight;
  RubicsCubeColor left;
  RubicsCubeColor center;
  RubicsCubeColor right;
  RubicsCubeColor bottomLeft;
  RubicsCubeColor bottomMid;
  RubicsCubeColor bottomRight;

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

  Map<String, dynamic> toJson() => {
        '\"' + "top_left" + '\"': '\"' + topLeft.toJson()+ '\"',
        '\"' + "top_mid" + '\"': '\"' + topMid.toJson()+ '\"',
        '\"' + "top_right" + '\"': '\"' + topRight.toJson()+ '\"',
        '\"' + "left" + '\"': '\"' + left.toJson()+ '\"',
        '\"' + "center" + '\"': '\"' + center.toJson()+ '\"',
        '\"' + "right" + '\"': '\"' + right.toJson()+ '\"',
        '\"' + "bottom_left" + '\"': '\"' + bottomLeft.toJson()+ '\"',
        '\"' + "bottom_mid" + '\"': '\"' + bottomMid.toJson()+ '\"',
        '\"' + "bottom_right" + '\"': '\"' + bottomRight.toJson()+ '\"',
      };

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
    this.topLeft = rCCfromHue(topLeftHue);
    this.topMid = rCCfromHue(topMidHue);
    this.topRight = rCCfromHue(topRightHue);
    this.left = rCCfromHue(leftHue);
    this.center = rCCfromHue(centerHue);
    this.right = rCCfromHue(rightHue);
    this.bottomLeft = rCCfromHue(bottomLeftHue);
    this.bottomMid = rCCfromHue(bottomMidHue);
    this.bottomRight = rCCfromHue(bottomRightHue);
  }
}

RubicsCubeColor rCCfromHue(LabColor labColor) {
  return RubicsCubeColor.values.map((rubicsCubeColor) => {"rubicsCubeColor": rubicsCubeColor, "deltaE": deltaE00(rubicsCubeColor.labColor, labColor)}).reduce((v, e) {
    double vHueDelta = v["deltaE"] as double;
    double eHueDelta = e["deltaE"] as double;
    return vHueDelta < eHueDelta ? v : e;
  })["rubicsCubeColor"];
}

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
