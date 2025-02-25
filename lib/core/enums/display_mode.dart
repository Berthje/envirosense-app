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

  String get toDisplayString {
    switch (this) {
      case DisplayMode.normal:
        return 'Default View';
      case DisplayMode.temperature:
        return 'Temperature';
      case DisplayMode.humidity:
        return 'Humidity';
      case DisplayMode.ppm:
        return 'CO2 Level';
      default:
        return 'Default View';
    }
  }

  static DisplayMode fromString(String value) {
    switch (value) {
      case 'normal':
        return DisplayMode.normal;
      case 'temperature':
        return DisplayMode.temperature;
      case 'humidity':
        return DisplayMode.humidity;
      case 'ppm':
        return DisplayMode.ppm;
      default:
        return DisplayMode.normal;
    }
  }
}
