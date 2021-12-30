import 'package:flutter/material.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/components/networkerror_dialog_component.dart';
import 'package:umich_msa/screens/home_screen.dart';

Future<void> showMemberSignInDialog(BuildContext context) async {
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
            autovalidate: true,
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.contains(RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                      var splittedEmailAddrs = value.split("@");
                      if (splittedEmailAddrs[0].length <= 8 &&
                          splittedEmailAddrs[1].endsWith('umich.edu')) {
                        return null;
                      }
                      return 'Invalid UMICH email address';
                    }
                    return 'Invalid email address';
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: _memberEmailAddressController,
                  decoration: const InputDecoration(
                    labelText: 'UMICH Email Address',
                    hintText: "Your uniqname email address",
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
              if (_formKey.currentState!.validate()) {
                bool response =
                    await addMembers(_memberEmailAddressController.text);
                response
                    ? MsaRouter.instance.pushReplacement(HomeScreen.route())
                    : showNetworkErrorDialog(context);
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
