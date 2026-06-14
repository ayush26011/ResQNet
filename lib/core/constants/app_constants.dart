class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'ResQNet';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Emergency Response Network';

  // Spacing
  static const double spaceXXS = 4.0;
  static const double spaceXS = 8.0;
  static const double spaceSM = 12.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 20.0;
  static const double spaceXL = 24.0;
  static const double spaceXXL = 32.0;
  static const double spaceXXXL = 48.0;

  // Border Radius
  static const double radiusXS = 8.0;
  static const double radiusSM = 12.0;
  static const double radiusMD = 16.0;
  static const double radiusLG = 24.0;
  static const double radiusXL = 32.0;
  static const double radiusXXL = 40.0;
  static const double radiusCircle = 999.0;

  // Padding
  static const double paddingXS = 8.0;
  static const double paddingSM = 12.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 20.0;
  static const double paddingXL = 24.0;
  static const double horizontalPadding = 20.0;

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);

  // Neumorphic
  static const double neuElevation = 8.0;
  static const double neuBlurRadius = 20.0;
  static const double neuSpreadRadius = 0.0;
  static const double neuOffset = 6.0;

  // Navigation
  static const String homeRoute = '/';
  static const String sosRoute = '/sos';
  static const String firstAidRoute = '/first-aid';
  static const String mapsRoute = '/maps';
  static const String profileRoute = '/profile';
  static const String firstAidDetailRoute = '/first-aid/detail';
}
