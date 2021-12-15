import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsWidget extends StatefulWidget {
  const EventsWidget({Key? key}) : super(key: key);

  @override
  _EventsWidgetState createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  late CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      startDay: DateTime(
          DateTime.now().year, DateTime.now().month - 3, DateTime.now().day),
      endDay: DateTime(
          DateTime.now().year, DateTime.now().month + 3, DateTime.now().day),
      initialSelectedDay: DateTime.now(),
      initialCalendarFormat: CalendarFormat.week,
      calendarController: _calendarController, //required
      locale: 'en_US',
    );
  }
}
