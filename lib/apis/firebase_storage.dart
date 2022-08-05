import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:umich_msa/constants.dart';

Future<String?> uploadReflectionRoomImage(File file, String filename) async {
  String? response;

  final storageRef = FirebaseStorage.instance.ref();
  final reflectionRoomImagesRef =
      storageRef.child("${MSAConstants.getStorageRootPath()}rooms/$filename");

  try {
    await reflectionRoomImagesRef.putFile(
      file,
      SettableMetadata(
        contentType: "image/jpeg",
      ),
    );
    response = await reflectionRoomImagesRef.getDownloadURL();
  } on FirebaseException catch (e) {
    //print('** firebase exception occurred while file upload ' + e.toString());
  } on Error catch (_) {
    //print('** An exception was thrown at the target of its invocation.');
  }
  //print('** upload file name: ' + response!);
  return response;
}

Future deleteReflectionRoomImage(String filename) async {
  final storageRef = FirebaseStorage.instance.ref();
  final reflectionRoomImagesRef =
      storageRef.child("${MSAConstants.getStorageRootPath()}rooms/$filename");

  try {
    await reflectionRoomImagesRef.delete();
    //print('** successful delete of blob');
  } on FirebaseException catch (e) {
    //print('** firebase exception occurred while file delete ' + e.toString());
  } on Error catch (_) {
    //print('** An exception was thrown at the target of its invocation.');
  }
}
