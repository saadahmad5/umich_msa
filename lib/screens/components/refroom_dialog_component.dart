import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:umich_msa/models/room.dart';

Future<void> showRoomDetailsDialog(BuildContext context, Room room) async {
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
              SizedBox(
                height: 200.0,
                child: Center(
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    imageUrl: room.imageUrl,
                    fit: BoxFit.contain,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error_outline_outlined),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Text(room.description),
              Text(room.room),
              Text('In the ' + room.whereAt + ' campus'),
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
            onPressed: () async {
              await MapsLauncher.launchCoordinates(
                room.coordinates.latitude,
                room.coordinates.longitude,
                room.name,
              );
            },
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
