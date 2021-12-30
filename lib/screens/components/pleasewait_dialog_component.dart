import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:umich_msa/constants.dart';

Future<void> showPleaseWaitDialog(BuildContext context) async {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          height: 50,
          child: Row(
            children: [
              SpinKitChasingDots(
                color: MSAConstants.yellowColor,
              ),
              const Padding(padding: EdgeInsets.only(right: 20)),
              const Text('Please wait'),
            ],
          ),
        ),
      );
    },
  );
}
