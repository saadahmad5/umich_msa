import 'models/coordinates.dart';

class MSAConstants {
  static bool isDebug = true;
  static String appVersion = "1.0";
  static String dbVersion = "v2";

  static Coordinates getInitialMapCoordinates() {
    Coordinates coordinates = Coordinates();
    coordinates.latitude = 42.2733150;
    coordinates.longitude = -83.7380000;
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
