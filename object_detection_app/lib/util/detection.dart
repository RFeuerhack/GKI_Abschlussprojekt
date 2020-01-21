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

  Detection.fromJson(Map<String, dynamic> json) {
    x = json["rect"]["x"];
    y = json["rect"]["y"];
    w = json["rect"]["w"];
    h = json["rect"]["h"];
    detectedClass = json["detectedClass"];
    confidenceInClass = json["confidenceInClass"];
  }
}
