import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/models/event.dart';
import 'package:umich_msa/msa_router.dart';

class EventModifyScreen extends StatefulWidget {
  const EventModifyScreen({Key? key}) : super(key: key);
  static String routeName = 'eventModifyScreen';

  static bool _isEdit = false;
  static MsaEvent _msaEvent = MsaEvent.noparams();

  static Route<EventModifyScreen> routeForAdd() {
    _isEdit = false;

    return MaterialPageRoute<EventModifyScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const EventModifyScreen(),
    );
  }

  static Route<EventModifyScreen> routeForEdit(MsaEvent msaEvent) {
    _isEdit = true;
    _msaEvent = msaEvent;

    return MaterialPageRoute<EventModifyScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const EventModifyScreen(),
    );
  }

  @override
  _EventModifyScreenState createState() => _EventModifyScreenState();
}

class _EventModifyScreenState extends State<EventModifyScreen> {
  late bool _isEdit;
  late MsaEvent _msaEvent;
  @override
  void initState() {
    super.initState();
    _isEdit = EventModifyScreen._isEdit;
    if (_isEdit) {
      _msaEvent = EventModifyScreen._msaEvent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        middle: Text(_isEdit ? 'Modify the MSA event' : 'Add a new Event'),
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
                  minimumYear: DateTime.now().year,
                  maximumYear: DateTime.now().year + 1,
                  dateOrder: DatePickerDateOrder.ymd,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (dateTime) {},
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
                    labelText: 'Social Media Link (optional)',
                    hintText: "https://www.instagram.com/p/",
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
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
                    labelText: 'Room (optional)',
                    hintText: "Room 123, 1st floor, Michigan Union",
                  ),
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
                    labelText: 'Address (optional)',
                    hintText: "530 State St., Ann Arbor, 48108",
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
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
                    labelText: 'Virtual Meeting Link (optional)',
                    hintText: "https://umich.zoom.us/j/",
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
                  if (_isEdit)
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      heroTag: 'delete',
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
