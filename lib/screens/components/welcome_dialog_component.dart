import 'package:flutter/material.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/models/user.dart';

Future<void> showWelcomeDialog(BuildContext context, User? user) async {
  String name = user?.displayName ?? '';

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Salams $name!',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24.0,
          ),
        ),
        content: RichText(
            text: TextSpan(
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'Cronos-Pro'),
                text: MSAConstants.welcomeMessage)),
        actions: [
          TextButton(
            child: const Text(
              'Alright, got it!',
              style: TextStyle(
                color: Colors.green,
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
