/// This dart file contains the Detection class.

/// Convinience class for parsing a detection in json format returned by the TFLite plugin.
class Detection {
  /// X of coordinate of upper left corner of rectangle, which describes the location of the detection.
  double x;

  /// Y of coordinate of upper left corner of rectangle, which describes the location of the detection.
  double y;

  /// Width of Rectangle, which describes the location of the detection.
  double w;

  /// Height of Rectangle, which describes the location of the detection.
  double h;

  /// Name of detected class.
  String detectedClass;

  /// Confidence that the detected class is a actually what the class stands for.
  double confidenceInClass;

  /// Default constructor.
  Detection(
    this.x,
    this.y,
    this.w,
    this.h,
    this.detectedClass,
    this.confidenceInClass,
  );

  /// Parses a Detection Object from a given json.
  Detection.fromJson(Map<String, dynamic> json) {
    x = json["rect"]["x"];
    y = json["rect"]["y"];
    w = json["rect"]["w"];
    h = json["rect"]["h"];
    detectedClass = json["detectedClass"];
    confidenceInClass = json["confidenceInClass"];
  }
}
