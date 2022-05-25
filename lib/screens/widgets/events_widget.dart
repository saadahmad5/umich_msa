import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:umich_msa/models/event.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/event_modify_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsWidget extends StatefulWidget {
  const EventsWidget({Key? key}) : super(key: key);

  @override
  _EventsWidgetState createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  late CalendarController _calendarController;
  late TextEditingController _eventController;
  late Map<DateTime, List<Event>> events;
  late List<dynamic> selectedEvents;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _eventController = TextEditingController();
    events = {};
    selectedEvents = [];

    Event tempEvent = Event(
        'Mini Q Seliman Ali',
        'Placeholder for any description',
        DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 1, 17, 30),
        'Room 100',
        '530 S State St, Ann Arbor, MI 48109',
        'https://www.instagram.com/p/CXaCTR_L11M/?utm_source=ig_web_copy_link',
        'https://umich.zoom.us/j/1234567890');

    events[DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day + 1, 17, 30)] = [tempEvent];
    //events[DateTime(2022, 1, 7, 17, 30)]?.add(tempEvent);
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          child: const Icon(Icons.add),
          onPressed: () async {
            //await _showAddDialog();
            MsaRouter.instance.push(EventModifyScreen.route());
          }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              events: events,
              startDay: DateTime(DateTime.now().year, DateTime.now().month - 3,
                  DateTime.now().day),
              endDay: DateTime(DateTime.now().year, DateTime.now().month + 3,
                  DateTime.now().day),
              initialSelectedDay: DateTime.now(),
              initialCalendarFormat: CalendarFormat.twoWeeks,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarController: _calendarController, //required
              locale: 'en_US',
              onDaySelected: (date, events, e) {
                setState(() {
                  //print({'Available events: ', events});
                  selectedEvents = events;
                });
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Text(
                    date.day.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                todayDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Text(
                    date.day.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            ...selectedEvents.isEmpty
                ? {
                    const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                    const Text('No Events on the selected day'),
                  }
                : selectedEvents.map(
                    (event) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              isThreeLine: true,
                              title: Text(
                                event.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.description,
                                    maxLines: 3,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Cronos-Pro'),
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text: 'Time: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: DateFormat.jm()
                                              .format(event.dateTime),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (event?.roomInfo?.isNotEmpty)
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cronos-Pro'),
                                        children: <TextSpan>[
                                          const TextSpan(
                                            text: 'At: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(text: event?.roomInfo),
                                        ],
                                      ),
                                    ),
                                  if (event?.address?.isNotEmpty)
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cronos-Pro'),
                                        children: <TextSpan>[
                                          const TextSpan(
                                            text: 'Address: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(text: event.address),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                if (event?.socialMediaLink?.isNotEmpty)
                                  TextButton(
                                    child: Row(
                                      children: const [
                                        Icon(Icons.link_outlined),
                                        Text(
                                          'Social Media',
                                        )
                                      ],
                                    ),
                                    onPressed: () async {
                                      await launch(event.socialMediaLink);
                                    },
                                  ),
                                if (event?.meetingLink?.isNotEmpty)
                                  TextButton(
                                    child: Row(
                                      children: const [
                                        Icon(Icons.video_call_outlined),
                                        Text('Meeting')
                                      ],
                                    ),
                                    onPressed: () async {
                                      await launch(event.meetingLink);
                                    },
                                  ),
                                if (event?.address?.isNotEmpty)
                                  TextButton(
                                    child: Row(
                                      children: const [
                                        Icon(Icons.directions_outlined),
                                        Text('Navigate'),
                                      ],
                                    ),
                                    onPressed: () async {
                                      await MapsLauncher.launchQuery(
                                          event.address);
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _showAddDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Event"),
        content: Column(
          children: [
            TextField(
              controller: _eventController,
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              "Save",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              setState(() {
                if (events[_calendarController.selectedDay] != null) {
                  events[_calendarController.selectedDay]?.add(
                    Event(
                      _eventController.text,
                      'Event Description',
                      DateTime.now(),
                      '123',
                      'Michigan Union',
                      '',
                      '',
                    ),
                  );
                } else {
                  events[_calendarController.selectedDay] = [
                    Event(_eventController.text, 'Event Description',
                        DateTime.now(), '123', 'Michigan Union', '', '')
                  ];
                }
                _eventController.clear();
                Navigator.pop(context);
              });
            },
          )
        ],
      ),
    );
  }
}
