class AppConfig {
  AppConfig._();

  static const int routePointBufferSize = 100;
  static const double maxGpsAccuracyMeters = 20.0;
  static const bool showLocationDebug = true;
  static const String locationServiceDisabledError = 'locationServiceDisabled';
  static const String backgroundPermissionError = 'backgroundPermissionInsufficient';
}
