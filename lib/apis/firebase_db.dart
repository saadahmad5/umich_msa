import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';

getUsers() async {
  print({'lol', MSAConstants.getDbRootPath() + 'users/'});
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
