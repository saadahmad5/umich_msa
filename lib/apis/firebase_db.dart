import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umich_msa/models/room.dart';
import 'package:umich_msa/constants.dart';

getUsers() async {
  //print({'lol', MSAConstants.getDbRootPath() + 'users/'});
  var userRef = FirebaseFirestore.instance
      .doc(MSAConstants.getDbRootPath() + 'users/' + 'RfRAxMmssyxxQChro4GX/');

  userRef.get().then((value) {
    print(value.data());
  });

  var users = FirebaseFirestore.instance
      .collection(MSAConstants.getDbRootPath() + 'users/');

  users.get().then((values) {
    values.docs.forEach((element) {
      print({'here', element.data()});
    });
  });
}

Future<List<Room>> getReflectionRooms() async {
  var refRoomRef = FirebaseFirestore.instance
      .collection(MSAConstants.getDbRootPath() + 'rooms/');

  QuerySnapshot listOfReflectionRooms = await refRoomRef.get();
  List<QueryDocumentSnapshot> queryDocument = listOfReflectionRooms.docs;
  List<Room> rooms = <Room>[];
  for (var element in queryDocument) {
    if (element.exists) {
      Room room = Room();

      room.coordinates.assignGeoPointValues(element.get('coordinates'));
      room.description = element.get('description');
      room.imageUrl = element.get('imageUrl');
      room.mCard = element.get('mCard');
      room.name = element.get('name');
      room.room = element.get('room');
      room.whereAt = element.get('whereAt');

      rooms.add(room);
    }
  }
  return rooms;
}
