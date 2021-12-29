import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:umich_msa/msa_router.dart';

class EventModifyScreen extends StatefulWidget {
  const EventModifyScreen({Key? key}) : super(key: key);
  static String routeName = 'eventModifyScreen';
  static Route<EventModifyScreen> route() {
    return MaterialPageRoute<EventModifyScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const EventModifyScreen(),
    );
  }

  @override
  _EventModifyScreenState createState() => _EventModifyScreenState();
}

class _EventModifyScreenState extends State<EventModifyScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        // Try removing opacity to observe the lack of a blur effect and of sliding content.
        backgroundColor: CupertinoColors.systemGrey.withOpacity(0.3),
        middle: const Text('Add a new event'),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height - 600,
              width: MediaQuery.of(context).size.width,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (dateTime) {},
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  heroTag: 'save',
                  child: const Icon(Icons.done),
                  onPressed: () {},
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  heroTag: 'cancel',
                  child: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    MsaRouter.instance.pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     leading: IconButton(
    //       icon: Container(child: Text('Saad')),
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //     ),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         Text('data'),
    //         FlatButton(
    //             onPressed: () {
    //               MsaRouter.instance.pop();
    //             },
    //             child: Text('back'))
    //       ],
    //     ),
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //   floatingActionButton: Container(
    //     padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
    //     child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           FloatingActionButton(
    //             backgroundColor: Colors.green,
    //             heroTag: 'save',
    //             child: const Icon(Icons.done),
    //             onPressed: () {},
    //           ),
    //           const Padding(
    //             padding: EdgeInsets.only(right: 10.0),
    //           ),
    //           FloatingActionButton(
    //             backgroundColor: Colors.red,
    //             heroTag: 'cancel',
    //             child: const Icon(Icons.cancel_outlined),
    //             onPressed: () {},
    //           ),
    //         ]),
    //   ),
    // );
  }
}
