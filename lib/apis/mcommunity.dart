import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/models/user.dart';

Future<User?> getUserDetails(String uniqname) async {
  bool resp = await useMCommunityLogin();

  if (resp) {
    Map<String, dynamic> res = {
      "person": {
        "displayName": null,
      },
    };

    String request = MSAConstants.mCommunityApi + uniqname;
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      res = jsonDecode(response.body);

      String displayName = res['person']['displayName'].toString();
      //print('** response ' + displayName);
      if (displayName != 'null') {
        return User(displayName);
      } else {
        return null;
      }
    } else {
      return null;
    }
  } else {
    return User(uniqname);
  }
}
