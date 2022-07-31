import 'package:flutter/material.dart';
import 'package:umich_msa/msa_router.dart';

Future<void> showConfirmationDialog(BuildContext context, String title,
    String message, String ok, Color okColor, dynamic function) async {
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
              MsaRouter.instance.popUntil('homeScreen');
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
