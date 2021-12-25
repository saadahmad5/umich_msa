import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import '../../models/coordinates.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Set<Marker> markers = new Set();
  Coordinates myLocation = Coordinates();
  late GoogleMapController _controller;
  final Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr) async {
    _controller = _cntlr;
    PermissionStatus _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _location.onLocationChanged.listen((l) {
      myLocation.latitude = l.latitude;
      myLocation.longitude = l.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var availWidgetHeight = MediaQuery.of(context).size.height;
    var availWidgetWidth = MediaQuery.of(context).size.width;
    double mapHeight;
    if (Platform.isAndroid) {
      mapHeight = availWidgetHeight - 210;
    } else if (Platform.isIOS) {
      mapHeight = availWidgetHeight - 260;
    } else {
      throw Exception('Unhandled Operating System');
    }

    return SizedBox(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: mapHeight,
                width: availWidgetWidth,
                child: GoogleMap(
                  compassEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  buildingsEnabled: false,
                  mapToolbarEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(42.2733150, -83.7380000),
                    zoom: 12,
                  ),
                  onMapCreated: _onMapCreated,
                  markers: getmarkers(),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ButtonBar(
              children: [
                ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.location_pin),
                      Padding(padding: EdgeInsets.only(right: 4.0)),
                      Text(
                        'My Location',
                      )
                    ],
                  ),
                  onPressed: () {
                    _location.onLocationChanged.listen((l) {
                      myLocation.latitude = l.latitude;
                      myLocation.longitude = l.longitude;
                    });
                    _controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(
                                myLocation.latitude, myLocation.longitude),
                            zoom: 12)));
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.map_outlined),
                      Padding(padding: EdgeInsets.only(right: 4.0)),
                      Text(
                        'Back to Default View',
                      ),
                    ],
                  ),
                  onPressed: () {
                    _controller.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(42.2733150, -83.7380000),
                      zoom: 12,
                    )));
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
                  child: Row(
                    children: [
                      Icon(Icons.maps_home_work_outlined),
                      Padding(padding: EdgeInsets.only(right: 4.0)),
                      Text(
                        'View List of Ref. Rooms',
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: Text(
                    'My Location',
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> getmarkers() {
    // markers to place on map
    var listOfRooms = getReflectionRooms();
    listOfRooms.then((value) => value.forEach((element) {
          setState(() {
            markers.add(Marker(
              onTap: () => {showBottomModal(element.description)},
              markerId: MarkerId(element.name),
              position: LatLng(
                  element.coordinates.latitude, element.coordinates.longitude),
              infoWindow: InfoWindow(
                title: element.name,
                snippet: element.description,
              ),
              icon: element.mCard
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed)
                  : BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
            ));
          });
        }));

    return markers;
  }

  void showBottomModal(String name) {
    print({'saad', name});
    showModalBottomSheet<String>(
      context: context,
      builder: (context) => Container(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}

/*Column(
  children: [
    Container(
      child: Text(
        "Reflection Rooms",
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontFamily: "Cronos-Pro",
            fontSize: 24.0),
      ),
      alignment: AlignmentGeometry.lerp(
          Alignment.center, Alignment.center, 0),
      padding: EdgeInsets.symmetric(vertical: 10.0),
    ),
  ],
),
// const TabBarView(
//   children: [
//     Icon(Icons.access_alarm_outlined),
//     Icon(Icons.add_task_outlined)
//   ],
// ),*/
