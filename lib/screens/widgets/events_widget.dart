import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/models/event.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/components/confirmation_dialog_component.dart';
import 'package:umich_msa/screens/event_modify_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventsWidget extends StatefulWidget {
  const EventsWidget({Key? key}) : super(key: key);

  @override
  _EventsWidgetState createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late bool isAdmin = false;
  late CalendarController _calendarController;
  late Map<DateTime, List<MsaEvent>> events;
  late List<dynamic> selectedEvents;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    events = {};
    selectedEvents = [];
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        isAdmin = prefs.getBool('isAdmin') ?? false;
      });
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (isAdmin)
              FloatingActionButton(
                  backgroundColor: Colors.green[700],
                  heroTag: 'add',
                  tooltip: 'Add Event',
                  child: const Icon(Icons.add),
                  onPressed: () {
                    showAddEventScreen();
                  }),
            FloatingActionButton(
              backgroundColor: Colors.orange[800],
              heroTag: 'refresh',
              tooltip: 'Refresh',
              child: const Icon(Icons.refresh_outlined),
              onPressed: () async {
                await refreshBasedOnCurrentCalendar().then(
                  (value) => {
                    Future.delayed(
                      const Duration(
                        milliseconds: 500,
                      ),
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Calendar refreshed!"),
                          ),
                        );
                      },
                    )
                  },
                );
              },
            ),
            FloatingActionButton(
                backgroundColor: Colors.blue[800],
                heroTag: 'today',
                tooltip: 'Today',
                child: const Icon(Icons.today_outlined),
                onPressed: () {
                  switchToToday();
                  Future.delayed(
                    const Duration(
                      milliseconds: 100,
                    ),
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Jumped to today!"),
                        ),
                      );
                    },
                  );
                }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              events: events,
              startDay: DateTime.now().subtract(const Duration(days: 90)),
              endDay: DateTime.now().add(const Duration(days: 90)),
              initialSelectedDay: DateTime.now(),
              initialCalendarFormat: CalendarFormat.twoWeeks,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Weekly',
                CalendarFormat.twoWeeks: 'Monthly',
                CalendarFormat.week: 'Biweekly',
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarController: _calendarController, //required
              locale: 'en_US',
              onDaySelected: (date, events, e) {
                setState(() {
                  //print({'Available events on day selected: ', events});
                  selectedEvents = events.isNotEmpty ? events : [];
                  selectedEvents
                      .sort((a, b) => a.dateTime.compareTo(b.dateTime));
                });
              },
              onCalendarCreated: (first, last, format) {
                refreshBasedOnCurrentCalendar();
              },
              onVisibleDaysChanged: (first, last, format) {
                //print("onVisibleDaysChanged called + API" + first.toString() + " - " + last.toString());
                refreshCalendarEvents(first, last);
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green[700],
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
                    shape: BoxShape.rectangle,
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(50.0),
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
                    const Center(
                      child: Icon(Icons.cancel_outlined),
                      widthFactor: 2.0,
                      heightFactor: 2.0,
                    ),
                    const Text('No Events on the selected day'),
                  }
                : selectedEvents.map(
                    (event) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 16.0),
                                  child: Text(
                                    event.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                if (isAdmin)
                                  (Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color: Colors.orange,
                                        ),
                                        tooltip: 'Edit MSA Event',
                                        onPressed: () {
                                          showEditEventScreen(event);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_forever_outlined,
                                          color: Colors.red,
                                        ),
                                        tooltip: 'Delete MSA Event',
                                        onPressed: () {
                                          showDeleteEventDialog(event);
                                        },
                                      ),
                                    ],
                                  )),
                              ],
                            ),
                            ListTile(
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
                                        TextSpan(
                                          text: " (" +
                                              timeago.format(event.dateTime,
                                                  allowFromNow: true) +
                                              ")",
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
            const Padding(
              padding: EdgeInsets.only(bottom: 100.0),
            )
          ],
        ),
      ),
    );
  }

  addEventsToCalendar(List<MsaEvent> msaEvents) {
    for (var event in msaEvents) {
      if (events[DateTime(
              event.dateTime.year, event.dateTime.month, event.dateTime.day)] ==
          null) {
        setState(() {
          events[DateTime(event.dateTime.year, event.dateTime.month,
              event.dateTime.day)] = [event];
        });
      } else {
        setState(() {
          events[DateTime(event.dateTime.year, event.dateTime.month,
                  event.dateTime.day)]
              ?.add(event);
        });
      }
    }
  }

  refreshCalendarEvents(DateTime start, DateTime end) async {
    List<MsaEvent> eventsToShowOnCalendar = <MsaEvent>[];
    if (start.month == end.month) {
      eventsToShowOnCalendar =
          await getEventsForTheMonth(_calendarController.focusedDay);
    } else if (start.month < end.month) {
      for (int _month = start.month; _month <= end.month; ++_month) {
        eventsToShowOnCalendar
            .addAll(await getEventsForTheMonth(DateTime(start.year, _month)));
      }
    } else if (start.month > end.month) {
      for (int _month = start.month; _month <= 12; ++_month) {
        eventsToShowOnCalendar
            .addAll(await getEventsForTheMonth(DateTime(start.year, _month)));
      }
      for (int _month = 1; _month <= end.month; ++_month) {
        eventsToShowOnCalendar
            .addAll(await getEventsForTheMonth(DateTime(end.year, _month)));
      }
    }

    if (eventsToShowOnCalendar.isNotEmpty) {
      events.clear();
      addEventsToCalendar(eventsToShowOnCalendar);
    }
  }

  switchToToday() {
    DateTime dateTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    //_calendarController.setFocusedDay(dateTime);
    _calendarController.setSelectedDay(dateTime,
        animate: true, runCallback: true);
    refreshBasedOnCurrentCalendar();
  }

  showAddEventScreen() async {
    MsaRouter.instance
        .push(
          EventModifyScreen.routeForAdd(),
        )
        .then((value) => refreshBasedOnCurrentCalendar());
  }

  showEditEventScreen(MsaEvent msaEvent) {
    MsaRouter.instance
        .push(
          EventModifyScreen.routeForEdit(msaEvent),
        )
        .then((value) => refreshBasedOnCurrentCalendar());
  }

  showDeleteEventDialog(MsaEvent msaEvent) {
    showConfirmationDialog(
      context,
      'Confirm delete?',
      'Are you sure want to delete this event?',
      'Delete',
      Colors.red,
      () => removeMsaEvent(msaEvent),
    ).then((value) => refreshBasedOnCurrentCalendar());
  }

  Future refreshBasedOnCurrentCalendar() async {
    List focusedDates = _calendarController.visibleDays;
    int focusedDatesLength = focusedDates.length;
    DateTime start = focusedDates[0];
    //print('start Date ' + start.toString());
    DateTime end = focusedDates[focusedDatesLength - 1];
    //print('end Date ' + end.toString());
    await refreshCalendarEvents(start, end);
    if (events.isNotEmpty) {
      DateTime selectedDate = _calendarController.selectedDay;
      List<MsaEvent> _selectedEvents = <MsaEvent>[];
      var result = events.entries.where(
        (element) =>
            element.key ==
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
      );
      if (result.isNotEmpty) {
        _selectedEvents = result.single.value;
      }
      setState(() {
        //print({'Available events on refresh called: ', _selectedEvents});
        selectedEvents = _selectedEvents.isNotEmpty ? _selectedEvents : [];
        selectedEvents.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      });
    }
  }
}
