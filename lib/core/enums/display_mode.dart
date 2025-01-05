enum DisplayMode { normal, temperature, humidity, ppm }

extension DisplayModeExtension on DisplayMode {
  String get toApiString {
    switch (this) {
      case DisplayMode.normal:
        return 'normal';
      case DisplayMode.temperature:
        return 'temperature';
      case DisplayMode.humidity:
        return 'humidity';
      case DisplayMode.ppm:
        return 'ppm';
      default:
        return 'normal';
    }
  }
}
