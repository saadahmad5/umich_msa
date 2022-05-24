import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/models/user.dart';

Future<User?> getUserDetails(String uniqname) async {
  Map<String, dynamic> res = {
    "person": {
      "displayName": null,
    },
    "affiliation": null
  };

  String request = MSAConstants.mCommunityApi + uniqname;
  final response = await http.get(Uri.parse(request));

  if (response.statusCode == 200) {
    res = jsonDecode(response.body);

    String displayName = res['person']['displayName'].toString();
    String affiliation = res['person']['affiliation'].toString();
    //print('** response ' + displayName + ' as ' + affiliation.toString());
    if (displayName != 'null') {
      return User(displayName, affiliation);
    } else {
      return null;
    }
  } else {
    return null;
  }
}
