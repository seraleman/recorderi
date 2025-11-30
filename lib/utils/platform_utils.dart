import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Utility class to detect the current platform
class PlatformUtils {
  /// Returns true if running on iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Returns true if running on Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Returns true if running on Web
  static bool get isWeb => kIsWeb;

  /// Returns true if running on a mobile platform (iOS or Android)
  static bool get isMobile => isIOS || isAndroid;

  /// Returns true if running on a desktop platform
  static bool get isDesktop =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  /// Returns true if Cupertino-style widgets should be used
  static bool get useCupertino => isIOS;

  /// Returns true if Material Design widgets should be used
  static bool get useMaterial => isAndroid || isWeb || isDesktop;
}
