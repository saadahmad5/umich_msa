import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/apis/mcommunity.dart';
import 'package:umich_msa/models/user.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/components/error_dialog_component.dart';
import 'package:umich_msa/screens/components/pleasewait_dialog_component.dart';
import 'package:umich_msa/screens/components/welcome_dialog_component.dart';
import 'package:umich_msa/screens/home_screen.dart';

Future<void> showMemberSignInDialog(BuildContext context) async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController _memberEmailAddressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Welcome to UMICH\'s MSA'),
        content: SizedBox(
          height: 90,
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your uniqname';
                    }
                    if (value.contains(RegExp(r"^[^0-9]+$")) &&
                        value.length <= 8) {
                      return null;
                    }
                    return 'Invalid UMICH uniqname';
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: _memberEmailAddressController,
                  decoration: const InputDecoration(
                    labelText: 'UMICH uniqname',
                    hintText: "Enter uniqname",
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
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
          TextButton(
            onPressed: () async {
              if (_memberEmailAddressController.text
                      .contains(RegExp(r"^[^0-9]+$")) &&
                  _memberEmailAddressController.text.length <= 8 &&
                  _memberEmailAddressController.text.isNotEmpty) {
                showPleaseWaitDialog(context);
                if (_formKey.currentState!.validate()) {
                  bool response = await hasGoodConnectivity();
                  if (response == false) {
                    Navigator.pop(context);
                    showErrorDialog(context,
                        'Please make sure you have a working internet connection or contact MSA Admin');
                  } else {
                    User? user = await getUserDetails(
                        _memberEmailAddressController.text);
                    if (user == null) {
                      Navigator.pop(context);
                      showErrorDialog(
                          context, 'Please make sure your uniqname is correct');
                    } else {
                      await addUsers(_memberEmailAddressController.text, false);
                      final SharedPreferences prefs = await _prefs;
                      prefs.setBool('isAuthenticated', true);
                      prefs.setString(
                          'userName', _memberEmailAddressController.text);
                      prefs.setString('displayName', user.displayName);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      MsaRouter.instance.pushReplacement(HomeScreen.route());
                      showWelcomeDialog(context, user);
                    }
                  }
                }
              } else {
                Navigator.pop(context);
                showErrorDialog(context,
                    'Please make sure you entered your valid uniqname in there');
              }
            },
            child: const Text(
              'Continue',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          )
        ],
      );
    },
  );
}
