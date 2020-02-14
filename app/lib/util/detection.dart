/// Convinience class for parsing a detection in json format returned by the TFLite plugin.
class Detection {
  double x;
  double y;
  double w;
  double h;
  String detectedClass;
  double confidenceInClass;

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
