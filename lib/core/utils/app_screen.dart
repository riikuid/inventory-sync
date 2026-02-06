import 'dart:ui';

/// Prevent using MediaQuery
/// Because MediaQuery make InputField always rebuild when onFocus
class AppScreen {
  static width() {
    FlutterView view = PlatformDispatcher.instance.views.first;
    double physicalWidth = view.physicalSize.width;
    double devicePixelRatio = view.devicePixelRatio;
    double screenWidth = physicalWidth / devicePixelRatio;

    return screenWidth;
  }

  static height() {
    FlutterView view = PlatformDispatcher.instance.views.first;
    double physicalHeight = view.physicalSize.height;
    double devicePixelRatio = view.devicePixelRatio;
    double screenHeight = physicalHeight / devicePixelRatio;

    return screenHeight;
  }
}
