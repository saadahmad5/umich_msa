import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umich_msa/models/boardmember.dart';
import 'package:umich_msa/models/quicklink.dart';
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
  bool? response = false;
  try {
    var cms = FirebaseFirestore.instance
        .doc(MSAConstants.getGeneralDbRootPath() + 'cms/');
    await cms
        .get()
        .then((value) => response = value.data()['enableAppLogins'])
        .timeout(const Duration(seconds: 5), onTimeout: () {
      response = false;
      return false;
    });
  } on Error catch (_) {
    return false;
  }
  return response ?? false;
}

Future<bool> useMCommunityLogin() async {
  bool? response = false;
  try {
    var cms = FirebaseFirestore.instance
        .doc(MSAConstants.getGeneralDbRootPath() + 'cms/');
    await cms
        .get()
        .then((value) => response = value.data()['enableMCommAuth'])
        .timeout(const Duration(seconds: 5), onTimeout: () {
      response = false;
      return false;
    });
  } on Error catch (_) {
    return false;
  }
  return response ?? false;
}

Future<bool> addUsers(String emailAddress, bool isAdmin) async {
  bool response = false;

  var users = FirebaseFirestore.instance.collection('users/');

  var newUser = <String, String>{};
  newUser[emailAddress] = DateTime.now().toString();
  await users
      .doc(isAdmin ? 'admins' : 'members')
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

Future<List<BoardMember>> getBoardMemberInfo() async {
  List<BoardMember> boardMembers = <BoardMember>[];

  try {
    var boardMemberRef = FirebaseFirestore.instance
        .collection(MSAConstants.getDbRootPath() + 'boardmembers/');

    QuerySnapshot listOfBoardMembers = await boardMemberRef.get();
    List<QueryDocumentSnapshot> queryDocument = listOfBoardMembers.docs;
    for (var element in queryDocument) {
      if (element.exists) {
        BoardMember boardMember = BoardMember.noparams();
        boardMember.order = element.get('order');
        boardMember.name = element.get('name');
        boardMember.position = element.get('position');
        boardMember.emailAddress = element.get('emailAddress');
        boardMember.details = element.get('details');

        boardMembers.add(boardMember);
      }
    }
  } on Error catch (_) {}
  return boardMembers;
}

Future<List<QuickLink>> getQuickLinks() async {
  List<QuickLink> quickLinks = <QuickLink>[];

  try {
    var quickLinkRef = FirebaseFirestore.instance
        .collection(MSAConstants.getDbRootPath() + 'quicklinks/');

    QuerySnapshot listOfQuickLinks = await quickLinkRef.get();
    List<QueryDocumentSnapshot> queryDocument = listOfQuickLinks.docs;
    for (var element in queryDocument) {
      if (element.exists) {
        QuickLink quickLink = QuickLink.noparams();

        quickLink.icon = element.get('icon');
        quickLink.title = element.get('title');
        quickLink.linkUrl = element.get('linkUrl');
        quickLink.order = element.get('order');

        quickLinks.add(quickLink);
      }
    }
  } on Error catch (_) {}
  return quickLinks;
}

Future<Map<String, dynamic>> getSocialMediaLinks() async {
  dynamic resp;
  try {
    var smlinks = FirebaseFirestore.instance.doc(MSAConstants.getDbRootPath());
    await smlinks
        .get()
        .then((value) => resp = value.data()['socialMediaLinks'])
        .timeout(const Duration(seconds: 5), onTimeout: () {
      resp = null;
      return resp;
    });
  } on Error catch (_) {
    return {};
  }
  return resp;
}
