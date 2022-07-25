import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/models/event.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/components/confirmation_dialog_component.dart';

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
  final _formKey = GlobalKey<FormState>();
  late bool _isEdit;
  late MsaEvent _msaEvent;
  late TextEditingController _msaEventTitleController;
  late TextEditingController _msaEventDescriptionController;
  late TextEditingController _msaEventSocialMediaLinkController;
  late TextEditingController _msaEventRoomController;
  late TextEditingController _msaEventAddressController;
  late TextEditingController _msaEventMeetingController;
  late DateTime _msaEventDateTime;

  @override
  void initState() {
    super.initState();
    _isEdit = EventModifyScreen._isEdit;
    if (_isEdit) {
      _msaEvent = EventModifyScreen._msaEvent;
      _msaEventTitleController = TextEditingController(text: _msaEvent.title);
      _msaEventDescriptionController =
          TextEditingController(text: _msaEvent.description);
      _msaEventSocialMediaLinkController =
          TextEditingController(text: _msaEvent.socialMediaLink);
      _msaEventRoomController = TextEditingController(text: _msaEvent.roomInfo);
      _msaEventAddressController =
          TextEditingController(text: _msaEvent.address);
      _msaEventMeetingController =
          TextEditingController(text: _msaEvent.meetingLink);
      _msaEventDateTime = _msaEvent.dateTime;
    } else {
      _msaEventTitleController = TextEditingController();
      _msaEventDescriptionController = TextEditingController();
      _msaEventSocialMediaLinkController = TextEditingController();
      _msaEventRoomController = TextEditingController();
      _msaEventAddressController = TextEditingController();
      _msaEventMeetingController = TextEditingController();
      _msaEventDateTime = DateTime.now();
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            //padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                ),
                Container(
                  padding: MSAConstants.textBoxPadding,
                  child: TextFormField(
                    controller: _msaEventTitleController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      } else if (value.length < 5) {
                        return 'Title must be atleast 5 characters';
                      } else if (value.length > 20) {
                        return 'Title must not exceed 20 characters';
                      } else {
                        return null;
                      }
                    },
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
                    controller: _msaEventDescriptionController,
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
                    minimumDate:
                        DateTime.now().subtract(const Duration(days: 3)),
                    maximumDate: DateTime.now().add(const Duration(days: 90)),
                    minimumYear: DateTime.now().year,
                    maximumYear: DateTime.now().year + 1,
                    dateOrder: DatePickerDateOrder.ymd,
                    initialDateTime: _msaEventDateTime,
                    onDateTimeChanged: (dateTime) {
                      setState(() {
                        _msaEventDateTime = dateTime;
                      });
                    },
                  ),
                ),
                Container(
                  padding: MSAConstants.textBoxPadding,
                  child: TextFormField(
                    controller: _msaEventSocialMediaLinkController,
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
                    controller: _msaEventRoomController,
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
                    controller: _msaEventAddressController,
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
                    controller: _msaEventMeetingController,
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
                      onPressed: () {
                        bool formValid =
                            false || _formKey.currentState!.validate();

                        if (formValid) {
                          String eventId =
                              DateTime.now().microsecondsSinceEpoch.toString() +
                                  Random.secure().nextInt(2048).toString();

                          showConfirmationDialog(
                            context,
                            'Confirm changes?',
                            'Are you sure want to save these changes?',
                            'Save',
                            Colors.green,
                            2,
                            () => {
                              modifyMsaEvent(
                                MsaEvent.params(
                                  eventId,
                                  _msaEventTitleController.text,
                                  _msaEventDescriptionController.text,
                                  _msaEventDateTime,
                                  _msaEventRoomController.text,
                                  _msaEventAddressController.text,
                                  _msaEventSocialMediaLinkController.text,
                                  _msaEventMeetingController.text,
                                ),
                              ),
                              if (_isEdit) removeMsaEvent(_msaEvent)
                            },
                          );
                        }
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.blue,
                      heroTag: 'back',
                      child: const Icon(Icons.undo_outlined),
                      onPressed: () {
                        MsaRouter.instance.pop();
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 60.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
