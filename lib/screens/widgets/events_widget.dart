import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:umich_msa/models/event.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/event_modify_screen.dart';

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
          onPressed: () {
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
                  print({'object', events, e});
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
                    style: TextStyle(color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
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
                              leading: Icon(Icons.album),
                              title: Text(event.title),
                              subtitle: Text(event.description),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('Details'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
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
            TimePickerDialog(
              initialTime: TimeOfDay.now(),
              initialEntryMode: TimePickerEntryMode.input,
            ),
            DatePickerDialog(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now(),
              initialEntryMode: DatePickerEntryMode.inputOnly,
              initialCalendarMode: DatePickerMode.day,
            )
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
                  events[_calendarController.selectedDay]
                      ?.add(Event(_eventController.text, 'Event Description'));
                } else {
                  events[_calendarController.selectedDay] = [
                    Event(_eventController.text, 'Event Description')
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
