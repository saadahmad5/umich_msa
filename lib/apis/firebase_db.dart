import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:umich_msa/models/boardmember.dart';
import 'package:umich_msa/models/event.dart';
import 'package:umich_msa/models/quicklink.dart';
import 'package:umich_msa/models/room.dart';
import 'package:umich_msa/constants.dart';

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
  print('** querying for rooms');
  var refRoomRef = FirebaseFirestore.instance
      .collection(MSAConstants.getDbRootPath() + 'rooms/');

  QuerySnapshot listOfReflectionRooms = await refRoomRef.get();
  List<QueryDocumentSnapshot> queryDocument = listOfReflectionRooms.docs;
  List<Room> rooms = <Room>[];
  for (var element in queryDocument) {
    if (element.exists) {
      Room room = Room.noparams();

      room.roomId = element.get('roomId');
      room.coordinates.assignGeoPointValues(element.get('coordinates'));
      room.description = element.get('description') ?? 'undefined';
      room.imageUrl = element.get('imageUrl') ?? 'undefined';
      room.mCard = element.get('mCard');
      room.name = element.get('name') ?? 'undefined';
      room.room = element.get('room') ?? 'undefined';
      room.address = element.get('address') ?? 'undefined';
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
        quickLink.description = element.get('description');

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

Future<bool> updateSocialMediaLinks(
  String facebook,
  String venmo,
  String instagram,
  String linktree,
) async {
  bool resp = false;

  try {
    var smlinks = FirebaseFirestore.instance.doc(MSAConstants.getDbRootPath());
    await smlinks
        .set({
          'socialMediaLinks': {
            'facebook': facebook,
            'venmo': venmo,
            'instagram': instagram,
            'linktree': linktree
          }
        }, SetOptions(merge: true))
        .then((value) => resp = true)
        .timeout(const Duration(seconds: 5), onTimeout: () {
          resp = false;
          return resp;
        });
  } on Error catch (_) {
    return false;
  }

  return resp;
}

Future<List<MsaEvent>> getEventsForTheMonth(DateTime focusedDay) async {
  List<MsaEvent> events = <MsaEvent>[];
  print('** called api');
  try {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    DataSnapshot response = await ref
        .child(
            "${MSAConstants.getDbRootPath()}/events/${focusedDay.year}-${focusedDay.month}/")
        .once();

    dynamic eventsInADay;
    if (response.value.runtimeType.toString() ==
        "_InternalLinkedHashMap<Object?, Object?>") {
      eventsInADay = response.value;
      if (eventsInADay.isNotEmpty) {
        for (Map eventInADay in eventsInADay.values) {
          for (Map rawEvent in eventInADay.values) {
            MsaEvent event = MsaEvent.params(
              rawEvent['id'],
              rawEvent['title'],
              rawEvent['description'],
              DateTime.parse(rawEvent['dateTime']),
              rawEvent['roomInfo'],
              rawEvent['address'],
              rawEvent['socialMediaLink'],
              rawEvent['meetingLink'],
            );
            events.add(event);
          }
        }
      }
    } else if (response.value.runtimeType.toString() == "List<Object?>") {
      eventsInADay = response.value[1];
      for (Map rawEvent in eventsInADay.values) {
        MsaEvent event = MsaEvent.params(
          rawEvent['id'],
          rawEvent['title'],
          rawEvent['description'],
          DateTime.parse(rawEvent['dateTime']),
          rawEvent['roomInfo'],
          rawEvent['address'],
          rawEvent['socialMediaLink'],
          rawEvent['meetingLink'],
        );
        events.add(event);
      }
    } else {
      eventsInADay = [];
    }
  } on Error catch (_) {}

  return events;
}

modifyMsaEvent(MsaEvent msaEvent) async {
  try {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    await ref
        .reference()
        .child(
            "${MSAConstants.getDbRootPath()}/events/${msaEvent.dateTime.year}-${msaEvent.dateTime.month}/${msaEvent.dateTime.day}/")
        .update(
      {
        msaEvent.id: {
          'id': msaEvent.id,
          'title': (msaEvent.title.length > 20)
              ? msaEvent.title.substring(0, 20)
              : msaEvent.title,
          'description': msaEvent.description ?? '',
          'dateTime': msaEvent.dateTime.toString(),
          'roomInfo': msaEvent.roomInfo ?? '',
          'address': msaEvent.address ?? '',
          'socialMediaLink': msaEvent.socialMediaLink ?? '',
          'meetingLink': msaEvent.meetingLink ?? '',
        }
      },
    );
  } on Error catch (_) {}
}

removeMsaEvent(MsaEvent msaEvent) async {
  try {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    await ref
        .reference()
        .child(
            "${MSAConstants.getDbRootPath()}/events/${msaEvent.dateTime.year}-${msaEvent.dateTime.month}/${msaEvent.dateTime.day}/${msaEvent.id}")
        .remove();
  } on Error catch (_) {}
}

Future<bool> modifyRoom(Room room) async {
  bool response = false;

  var roomRef = FirebaseFirestore.instance
      .collection(MSAConstants.getDbRootPath() + 'rooms/');

  try {
    await roomRef
        .doc(room.roomId)
        .set(
          {
            'roomId': room.roomId,
            'address': room.address,
            'coordinates':
                GeoPoint(room.coordinates.latitude, room.coordinates.longitude),
            'description': room.description,
            'imageUrl': room.imageUrl,
            'mCard': room.mCard,
            'name': room.name,
            'room': room.room,
            'whereAt': room.whereAt
          },
          //SetOptions(merge: true),
        )
        .then((value) => response = true)
        .timeout(const Duration(seconds: 5), onTimeout: () {
          response = false;
          return false;
        });
  } on Error catch (e) {
    print('** error while adding ref room' + e.toString());
  }

  return response;
}

Future<bool> removeRoom(Room room) async {
  bool response = false;
  try {
    var roomRef = FirebaseFirestore.instance
        .collection(MSAConstants.getDbRootPath() + 'rooms/')
        .doc(room.roomId);
    await roomRef.delete().then((value) => response = true);
  } on Error catch (_) {
    print('! Error while deleting the reflection room');
  }
  return response;
}
