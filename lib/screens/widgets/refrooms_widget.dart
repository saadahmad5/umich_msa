import 'package:flutter/material.dart';
import 'package:umich_msa/models/room.dart';

class RefRoomsWidget extends StatelessWidget {
  RefRoomsWidget({required this.rooms});

  late List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    print({'saad', rooms});
    return Container(
      child: ElevatedButton(
        child: Text('Close me'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
