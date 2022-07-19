import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:umich_msa/msa_router.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  static String routeName = 'adminScreen';
  static Route<AdminScreen> route() {
    return MaterialPageRoute<AdminScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const AdminScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            onPressed: () {
              MsaRouter.instance.pop();
            },
            child: const Text(
              'Back',
              textScaleFactor: 0.7,
              style: TextStyle(color: CupertinoColors.link),
            ),
          ),
          middle: const Text('Admin Screen'),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CupertinoActivityIndicator(),
              SizedBox(width: 8),
              Text('Page under construction')
            ],
          ),
        ),
      ),
    );
  }
}
