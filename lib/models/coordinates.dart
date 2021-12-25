import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Coordinates {
  late double latitude;
  late double longitude;

  assignGeoPointValues(GeoPoint geoPoint) {
    latitude = geoPoint.latitude;
    longitude = geoPoint.longitude;
  }

  assignLatLngValues(LatLng latLng) {
    latitude = latLng.latitude;
    longitude = latLng.longitude;
  }
}
