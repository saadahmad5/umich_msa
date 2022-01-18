import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/models/room.dart';
import 'package:umich_msa/models/coordinates.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/components/refroom_dialog_component.dart';
import 'package:umich_msa/screens/room_modify_screen.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Set<Marker> markers = {};
  Coordinates myLocation = Coordinates();
  late GoogleMapController _googleMapController;
  final Location location = Location();
  late List<Room> rooms;

  void onMapCreated(GoogleMapController _cntlr) async {
    _googleMapController = _cntlr;
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.onLocationChanged.listen((l) {
      myLocation.latitude = l.latitude;
      myLocation.longitude = l.longitude;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getMarkers();
  }

  @override
  Widget build(BuildContext context) {
    var availWidgetHeight = MediaQuery.of(context).size.height;
    var availWidgetWidth = MediaQuery.of(context).size.width;

    return markers.isNotEmpty
        ? Scaffold(
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
                  target: LatLng(
                      MSAConstants.getInitialMapCoordinates().latitude,
                      MSAConstants.getInitialMapCoordinates().longitude),
                  zoom: 12,
                ),
                onMapCreated: onMapCreated,
                markers: markers,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: 'location',
                    tooltip: 'My Location',
                    backgroundColor: Colors.green[700],
                    onPressed: () {
                      _googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: LatLng(
                                myLocation.latitude,
                                myLocation.longitude,
                              ),
                              zoom: 12),
                        ),
                      );
                    },
                    child: const Icon(Icons.location_pin),
                  ),
                  FloatingActionButton(
                    heroTag: 'default',
                    tooltip: 'Default View',
                    backgroundColor: Colors.blue[800],
                    onPressed: () {
                      _googleMapController.animateCamera(
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
                    heroTag: 'addRefRoom',
                    backgroundColor: Colors.deepOrange,
                    tooltip: 'Add Ref. Room',
                    onPressed: () {
                      MsaRouter.instance.push(RoomModifyScreen.route());
                    },
                    child: const Icon(
                      Icons.add,
                    ),
                  )
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  getMarkers() {
    var listOfRooms = getReflectionRooms();
    listOfRooms
        .then(
      (value) => {
        setState(() {
          rooms = value;
        }),
        rooms.forEach(
          (room) {
            markers.add(
              Marker(
                markerId: MarkerId(room.name),
                position: LatLng(
                    room.coordinates.latitude, room.coordinates.longitude),
                infoWindow: InfoWindow(
                  title: room.name,
                  snippet: room.room,
                  onTap: () => {
                    showRoomDetailsDialog(context, room),
                  },
                ),
                icon: room.mCard
                    ? BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed)
                    : BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
              ),
            );
          },
        ),
      },
    )
        .catchError(
      (e) {
        markers.clear();
      },
    );
  }
}
