import 'package:flutter/material.dart';

import 'models/coordinates.dart';

class MSAConstants {
  static bool isDebug = false;
  static String appName = "University of Michigan Muslims Students Association";
  static String appVersion = "1.0";
  static String aboutMessage =
      "This freely distributable app is developed for the Muslims Student Association (UMICH MSA) organization at the University of Michigan. If you have any suggestions or if you discover any bugs, please feel free to email me at ";
  static String developersEmail = "saadahm@umich.edu";
  @protected
  static String dbVersion = "v2";
  @protected
  static String storageVersion = "v2";

  static double defaultLatitude = 42.2733150;
  static double defaultLongitude = -83.7380000;

  static Size imageDimensions = const Size(640, 480);
  static int maxImageSize = 122880;

  static String mCommunityApi = "https://mcommunity-api.dsc.umich.edu/people/";
  //"https://mcommunity.umich.edu/mcPeopleService/people/";

  static String welcomeMessage = """Welcome to the UMICH's MSA app!
  \nThis app will help you to:
  \n1. Find & navigate to the reflection rooms on the campus.
  \n2. See MSA events on the calendar.
  \n3. Quick links to the MSA resources/ social media.
  \n4. Contact details of the MSA Board members""";

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

  static List<String> positions = [
    'President', // 0
    'Vice President Internal', // 1
    'Vice President External', // 2
    'Operations', // 3
    'Brotherhood Chair', // 4
    'Sisterhood Chair', // 5
    'Treasurer', // 6
    'Chair', // 7
    'Other', // 8
  ];

  static List<String> iconTypes = ['form', 'spreadsheet', 'link', 'chat'];

  static int getOrder() {
    DateTime utcNow = DateTime.now().toUtc();
    int orderNumber = utcNow.microsecondsSinceEpoch;
    return orderNumber;
  }

  static Color yellowColor = const Color.fromARGB(255, 252, 210, 12);
  static Color blueColor = const Color.fromARGB(255, 30, 48, 96);

  static Color grayTextBoxBackgroundColor =
      const Color.fromARGB(255, 238, 238, 238);

  static EdgeInsets textBoxPadding = const EdgeInsets.symmetric(
    vertical: 6.0,
    horizontal: 18.0,
  );

  static String getDbRootPath() {
    String path = getGeneralDbRootPath();
    path += dbVersion + '/';
    return path;
  }

  static String getStorageRootPath() {
    String path = getGeneralDbRootPath();
    path += storageVersion + '/';
    return path;
  }

  static String getGeneralDbRootPath() {
    String path = '';

    if (isDebug) {
      path += "test/";
    } else {
      path += "prod/";
    }

    return path;
  }
}
