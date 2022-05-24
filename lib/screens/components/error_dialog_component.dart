import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String error) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
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
