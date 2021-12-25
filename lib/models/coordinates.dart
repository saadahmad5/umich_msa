import 'package:cloud_firestore/cloud_firestore.dart';

class Coordinates {
  late double latitude;
  late double longitude;

  assignValues(GeoPoint geoPoint) {
    latitude = geoPoint.latitude;
    longitude = geoPoint.longitude;
  }
}
