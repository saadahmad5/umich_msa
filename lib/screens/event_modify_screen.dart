import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:umich_msa/constants.dart';
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
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        middle: Text('Add a new MSA event'),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: MSAConstants.textBoxPadding,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: MSAConstants.textBoxPadding,
                    filled: true,
                    fillColor: MSAConstants.grayTextBoxBackgroundColor,
                    border: InputBorder.none,
                    labelText: 'Title',
                    hintText: "MSA Mass Meeting",
                  ),
                ),
              ),
              Container(
                padding: MSAConstants.textBoxPadding,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    contentPadding: MSAConstants.textBoxPadding,
                    filled: true,
                    fillColor: MSAConstants.grayTextBoxBackgroundColor,
                    border: InputBorder.none,
                    labelText: 'Description (optional)',
                    hintText: "Event Details",
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 600,
                width: MediaQuery.of(context).size.width,
                child: CupertinoDatePicker(
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (dateTime) {},
                ),
              ),
              Container(
                padding: MSAConstants.textBoxPadding,
                child: TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    contentPadding: MSAConstants.textBoxPadding,
                    filled: true,
                    fillColor: MSAConstants.grayTextBoxBackgroundColor,
                    border: InputBorder.none,
                    labelText: 'Address',
                    hintText: "Michigan Union, Ann Arbor, 48108",
                  ),
                ),
              ),
              Container(
                padding: MSAConstants.textBoxPadding,
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: MSAConstants.textBoxPadding,
                    filled: true,
                    fillColor: MSAConstants.grayTextBoxBackgroundColor,
                    border: InputBorder.none,
                    labelText: 'Room',
                    hintText: "Room 123, 1st floor",
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
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
                    child: const Icon(Icons.close),
                    onPressed: () {
                      MsaRouter.instance.pop();
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                  ),
                ],
              ),
            ],
          ),
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
