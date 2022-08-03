import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/apis/firebase_storage.dart';
import 'package:umich_msa/models/room.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/components/confirmation_dialog_component.dart';
import 'package:umich_msa/screens/room_modify_screen.dart';

Future<void> showRoomDetailsDialog(
    BuildContext context, Room room, dynamic getMarkers, bool isAdmin) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Text(
              room.name,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            if (isAdmin)
              IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.orange,
                ),
                tooltip: 'Edit Room',
                onPressed: () {
                  showEditRoomScreen(room, getMarkers);
                },
              ),
            if (isAdmin)
              IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                ),
                tooltip: 'Delete Room',
                onPressed: () {
                  showDeleteRoomDialog(context, room, getMarkers);
                },
              ),
          ],
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
              Text(room.address),
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

showEditRoomScreen(Room room, dynamic getMarkers) {
  MsaRouter.instance
      .push(
        RoomModifyScreen.routeForEdit(room),
      )
      .then((value) => getMarkers());
}

showDeleteRoomDialog(BuildContext context, Room room, dynamic getMarkers) {
  showConfirmationDialog(
    context,
    'Confirm delete?',
    'Are you sure want to delete this reflection room?',
    'Delete',
    Colors.red,
    () async => {
      await removeRoom(room)
          .then(
            (value) => deleteReflectionRoomImage(room.roomId),
          )
          .then(
            (value) => getMarkers(),
          ),
    },
  );
}
