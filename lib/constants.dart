import 'package:flutter/material.dart';

import 'models/coordinates.dart';

class MSAConstants {
  static bool isDebug = true;
  @protected
  static String appVersion = "1.0";
  @protected
  static String dbVersion = "v2";

  static double defaultLatitude = 42.2733150;
  static double defaultLongitude = -83.7380000;

  static Coordinates getInitialMapCoordinates() {
    Coordinates coordinates = Coordinates();
    return coordinates;
  }

  static String getDbRootPath() {
    String path = '';

    if (isDebug) {
      path += "test/";
    } else {
      path += "prod/";
    }

    path += dbVersion + '/';

    return path;
  }
}
