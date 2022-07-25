import 'package:flutter/material.dart';

Future<void> showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
    String ok,
    Color okColor,
    int numOfPops,
    dynamic function) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: Text(
              ok,
              style: TextStyle(
                color: okColor,
              ),
            ),
            onPressed: () {
              function();
              for (int i = 0; i < numOfPops; ++i) {
                Navigator.of(context).pop();
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
