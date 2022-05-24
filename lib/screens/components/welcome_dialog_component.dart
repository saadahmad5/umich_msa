import 'package:flutter/material.dart';
import 'package:umich_msa/models/user.dart';

Future<void> showWelcomeDialog(BuildContext context, User? user) async {
  String name = user?.displayName ?? '';
  String affiliation = user?.affiliation ?? 'None';

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Salams $name!'),
        content: RichText(
            text: TextSpan(
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'Cronos-Pro'),
                text:
                    'Welcome from MSA!\n\nYou\'re Affiliated with UMICH as: $affiliation')),
        actions: [
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
        ],
      );
    },
  );
}
