class MSAConstants {
  static bool isDebug = true;
  static String appVersion = "1.0";
  static String dbVersion = "v2";

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
