import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(42.2733150, -83.7380000),
        zoom: 12,
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