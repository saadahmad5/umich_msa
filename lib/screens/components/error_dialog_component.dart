import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String error,
    {String? title}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title == null ? const Text('Error') : Text(title),
        content: Text(error),
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
