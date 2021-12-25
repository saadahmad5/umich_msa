import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/models/room.dart';
import 'package:umich_msa/models/coordinates.dart';

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

    return Scaffold(
      body: SizedBox(
        height: availWidgetHeight,
        width: availWidgetWidth,
        child: GoogleMap(
          compassEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          buildingsEnabled: false,
          mapToolbarEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(MSAConstants.getInitialMapCoordinates().latitude,
                MSAConstants.getInitialMapCoordinates().longitude),
            zoom: 12,
          ),
          onMapCreated: _onMapCreated,
          markers: getmarkers(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FloatingActionButton(
              tooltip: 'My Location',
              backgroundColor: Colors.green[700],
              onPressed: () {
                _location.onLocationChanged.listen((l) {
                  myLocation.latitude = l.latitude;
                  myLocation.longitude = l.longitude;
                });
                _controller.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(
                          myLocation.latitude,
                          myLocation.longitude,
                        ),
                        zoom: 12)));
              },
              child: const Icon(Icons.location_pin),
            ),
            FloatingActionButton(
              tooltip: 'Default View',
              backgroundColor: Colors.blue[800],
              onPressed: () {
                _controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        MSAConstants.getInitialMapCoordinates().latitude,
                        MSAConstants.getInitialMapCoordinates().longitude,
                      ),
                      zoom: 12,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.map_outlined),
            ),
            FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              tooltip: 'Show as List',
              onPressed: () {},
              child: const Icon(Icons.business_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Set<Marker> getmarkers() {
    // markers to place on map
    var listOfRooms = getReflectionRooms();
    listOfRooms.then(
      (value) => value.forEach(
        (element) {
          setState(
            () {
              markers.add(
                Marker(
                  markerId: MarkerId(element.name),
                  position: LatLng(element.coordinates.latitude,
                      element.coordinates.longitude),
                  infoWindow: InfoWindow(
                    title: element.name,
                    snippet: element.description,
                    onTap: () => {_showRoomDetailsDialog(element)},
                  ),
                  icon: element.mCard
                      ? BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed)
                      : BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                ),
              );
            },
          );
        },
      ),
    );

    return markers;
  }

  Future<void> _showRoomDetailsDialog(Room room) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            room.name,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    imageUrl: room.imageUrl,
                  ),
                ),
                Text(room.description),
                Text(room.room),
                Text('Near ' + room.whereAt + ' campus'),
                room.mCard
                    ? const Text(
                        'MCard Required',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    : const Text(
                        'MCard not required',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Start Navigation',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {},
            ),
            TextButton(
              child: const Text(
                'Dismiss',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
