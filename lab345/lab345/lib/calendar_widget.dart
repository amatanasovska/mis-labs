import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<String>> _events = {};
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); 

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }


  Future<void> _fetchEvents({bool scheduleNotif = true}) async {
    _events = {};
    final User? user = FirebaseAuth.instance.currentUser;

    final QuerySnapshot<Map<String, dynamic>> exams = await FirebaseFirestore.instance
        .collection('exams')
        .where('user', isEqualTo: user!.uid)
        .get();

    for (final exam in exams.docs) {
      final DateTime date = DateTime.parse(
        exam['date'].replaceAllMapped(
          RegExp(r'(\d+)-(\d+)-(\d+)'),
          (match) =>
              '${match[1].padLeft(2, '0')}-${match[2].padLeft(2, '0')}-${match[3].padLeft(2, '0')}',
        ),
      );
      final String eventName = exam['name'];

      if (_events[date] == null) {
        _events[date] = [eventName];
      } else {
        _events[date]!.add(eventName);
      }
    }

    setState(() {});
  }

  List<String> _getEventsForDay(DateTime day) {
    final formattedDay = DateTime(day.year, day.month, day.day);
    final eventsForDay = _events[formattedDay] ?? [];

    return eventsForDay;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2022, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onDaySelected: (selectedDay, focusedDay) async {
            await _fetchEvents(scheduleNotif: false);
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          eventLoader: (day) => _getEventsForDay(day),
        ),
        const SizedBox(height: 20),
        if (_selectedDay != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events for ${_selectedDay!.day} - ${_selectedDay!.month} - ${_selectedDay!.year}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
                const SizedBox(),
              ..._getEventsForDay(_selectedDay!).map(
                (event) => ListTile(
                  title: Text(event),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
