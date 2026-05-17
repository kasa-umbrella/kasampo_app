class AppConfig {
  AppConfig._();

  static const double initialMapZoom = 17;
  static const int heatmapSampleRate = 5;
  static const int routePointBufferSize = 100;
  static const double maxGpsAccuracyMeters = 20.0;
  static const String locationServiceDisabledError = 'locationServiceDisabled';
  static const String backgroundPermissionError =
      'backgroundPermissionInsufficient';
}
