import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:umich_msa/constants.dart';

class Coordinates {
  late double latitude;
  late double longitude;

  Coordinates() {
    latitude = MSAConstants.defaultLatitude;
    longitude = MSAConstants.defaultLongitude;
  }

  Coordinates.params(this.latitude, this.longitude);

  assignGeoPointValues(GeoPoint geoPoint) {
    latitude = geoPoint.latitude;
    longitude = geoPoint.longitude;
  }

  assignLatLngValues(LatLng latLng) {
    latitude = latLng.latitude;
    longitude = latLng.longitude;
  }
}
