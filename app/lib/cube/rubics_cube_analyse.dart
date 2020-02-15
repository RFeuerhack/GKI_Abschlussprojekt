import 'package:camera/camera.dart';
import 'package:delta_e/delta_e.dart';
import 'package:image/image.dart';

import 'rubics_cube_color.dart';
import 'rubics_cube_side.dart';

/// Parses the subimage (x, y, width, height) containing a side of a [RubicsCube] to a [RubicsCubeSide].
RubicsCubeSide parsePartOfCameraImageOfRubicsCubeSide(CameraImage image, int x, int y, int width, int height) {
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

  return RubicsCubeSide.fromLabColors(
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

/// Returns a [LabColor] from a given coordinate in an [Image] stored vertically ([CameraImage] -> [Image]) with a given height.
LabColor getLabColorFromRotatedPosition(Image image, Point point, int height) {
  Point pointRotated = rotate(point, height);
  int argb = image.getPixel(pointRotated.x, pointRotated.y);
  return fromARGBReversed(argb);
}

/// Rotates a [Point] by 90 degrees in an image with a given height.
/// Disclaimer: Needed because [CameraImage]s are stored rotated.
Point rotate(Point point, int height) => Point(point.y, height - point.x);

/// Restructures a given hex value ([int]) with 8 characters from abcd to adcb an creates a [LabColor] from the result.
LabColor fromARGBReversed(int reversedArgb) {
  String s = reversedArgb.toRadixString(16);
  String s1 = s[0] + "" + s[1] + "" + s[6] + "" + s[7] + "" + s[4] + "" + s[5] + "" + s[2] + "" + s[3];
  int reversedARGB = int.parse(s1, radix: 16);
  return LabColor.fromRGBValue(reversedARGB, RGBStructure.argb);
}

/// Determines a [RubicsCubeColor] e.g. [RubicsCubeColor.RED] from a given [LabColor] by comparing the value of the [LabColor] to the constant [LabColor] representing each [RubicsCubeColor].
RubicsCubeColor rubicsCubeColorLabColor(LabColor labColor) {
  return RubicsCubeColor.values.map((rubicsCubeColor) => {"rubicsCubeColor": rubicsCubeColor, "deltaE": deltaE00(rubicsCubeColor.labColor, labColor)}).reduce((v, e) {
    double vDeltaE = v["deltaE"] as double;
    double eDeltaE = e["deltaE"] as double;
    return vDeltaE < eDeltaE ? v : e;
  })["rubicsCubeColor"];
}

/// Code snippet taken from: "https://stackoverflow.com/questions/57603146/how-to-convert-camera-image-to-image-in-flutter"
/// Converts a [CameraImage] to an [Image]. ([Image] class allows reading rgb at a given coordinate)
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
