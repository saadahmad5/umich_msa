import 'package:flutter/material.dart';

import 'models/coordinates.dart';

class MSAConstants {
  static bool isDebug = true;
  static String appName = "University of Michigan Muslims Students Association";
  static String appVersion = "1.0";
  static String aboutMessage =
      "This freely distributable app is developed for the Muslims Student Association (UMICH MSA) organization at the University of Michigan. If you have any suggestions or if you discover any bugs, please feel free to email me at ";
  static String developersEmail = "saadahm@umich.edu";
  @protected
  static String dbVersion = "v2";

  static double defaultLatitude = 42.2733150;
  static double defaultLongitude = -83.7380000;

  static Coordinates getInitialMapCoordinates() {
    Coordinates coordinates = Coordinates();
    return coordinates;
  }

  static List<String> campusLocations = [
    'Central',
    'North',
    'South',
    'Medical'
  ];

  static Color yellowColor = const Color.fromARGB(255, 252, 210, 12);
  static Color blueColor = const Color.fromARGB(255, 30, 48, 96);

  static Color grayTextBoxBackgroundColor =
      const Color.fromARGB(255, 238, 238, 238);

  static EdgeInsets textBoxPadding = const EdgeInsets.symmetric(
    vertical: 6.0,
    horizontal: 18.0,
  );

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
