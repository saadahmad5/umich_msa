import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umich_msa/models/room.dart';
import 'package:umich_msa/constants.dart';

getUsers() async {
  //print({'lol', MSAConstants.getDbRootPath() + 'users/'});
  // var userRef = FirebaseFirestore.instance
  //     .doc(MSAConstants.getDbRootPath() + 'users/' + 'RfRAxMmssyxxQChro4GX/');

  // userRef.get().then((value) {
  //   print(value.data());
  // });

  // var users = FirebaseFirestore.instance
  //     .collection(MSAConstants.getDbRootPath() + 'users/');

  // users.get().then((values) {
  //   values.docs.forEach((element) {
  //     print({'here', element.data()});
  //   });
  // });

  // users.doc().set({'role': 'saad'});
}

Future<bool> hasGoodConnectivity() async {
  bool response = false;
  try {
    var metaData = FirebaseFirestore.instance
        .doc(MSAConstants.getGeneralDbRootPath() + 'metadata/');
    await metaData
        .get()
        .then((value) => response = value.data()['enableApp'])
        .timeout(const Duration(seconds: 5), onTimeout: () {
      response = false;
      return false;
    });
  } on Error catch (_) {
    return false;
  }

  return response;
}

Future<bool> addMembers(String emailAddress) async {
  bool response = false;

  var users = FirebaseFirestore.instance
      .collection(MSAConstants.getDbRootPath() + 'users/');

  var newUser = <String, String>{};
  newUser[emailAddress] = emailAddress;
  await users
      .doc('members')
      .set(newUser, SetOptions(merge: true))
      .then((value) => response = true)
      .timeout(const Duration(seconds: 5), onTimeout: () {
    response = false;
    return false;
  });

  return response;
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
