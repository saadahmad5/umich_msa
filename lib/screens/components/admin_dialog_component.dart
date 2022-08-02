import 'package:flutter/material.dart';
import 'package:umich_msa/apis/firebase_auth.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/components/error_dialog_component.dart';

Future<void> showAdminDialog(BuildContext context, String title, String message,
    String ok, Color okColor) async {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _pwdEditingController = TextEditingController();
  TextEditingController _confirmPwdEditingController = TextEditingController();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(message),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              TextFormField(
                controller: _textEditingController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: MSAConstants.textBoxPadding,
                  filled: true,
                  fillColor: MSAConstants.grayTextBoxBackgroundColor,
                  border: InputBorder.none,
                  labelText: 'UMICH Email Address',
                  hintText: "uniqname@umich.edu",
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              TextFormField(
                obscureText: true,
                controller: _pwdEditingController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  contentPadding: MSAConstants.textBoxPadding,
                  filled: true,
                  fillColor: MSAConstants.grayTextBoxBackgroundColor,
                  border: InputBorder.none,
                  labelText: 'Password',
                  hintText: "supersecret!",
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              TextFormField(
                obscureText: true,
                controller: _confirmPwdEditingController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  contentPadding: MSAConstants.textBoxPadding,
                  filled: true,
                  fillColor: MSAConstants.grayTextBoxBackgroundColor,
                  border: InputBorder.none,
                  labelText: 'Confirm Password',
                  hintText: "supersecret!",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              ok,
              style: TextStyle(
                color: okColor,
              ),
            ),
            onPressed: () {
              String inputEmailAddress = _textEditingController.text.toString();
              String inputPassword = _pwdEditingController.text.toString();
              String confirmPassword =
                  _confirmPwdEditingController.text.toString();
              var inputSplit = inputEmailAddress.split('@');
              if (inputSplit[0].isNotEmpty &&
                  inputSplit[0].length <= 8 &&
                  inputSplit.indexOf('umich.edu') == 1 &&
                  inputPassword.toString() == confirmPassword.toString() &&
                  inputPassword.length >= 8) {
                signUp(inputEmailAddress, inputPassword);
                MsaRouter.instance.pop();
              } else {
                print('** invalid credentials during sign up');
                showErrorDialog(context,
                    """Please make sure:\n1. The Email Address you entered is a valid UMICH email address.\n2. Please make sure the passwords you entered are atleast 8 characters and they match.""");
              }
            },
          ),
          TextButton(
            child: const Text(
              'Back',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
