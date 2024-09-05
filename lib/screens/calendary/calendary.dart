import 'package:flutter/material.dart';
import 'package:luna/screens/calendary/components/calendar_body.dart';
import 'package:luna/services/database.dart';
import 'package:luna/constants/colors.dart';

class Calendary extends StatefulWidget {
  const Calendary({Key? key}) : super(key: key);

  @override
  CalendaryState createState() => CalendaryState();
}

class CalendaryState extends State<Calendary> {
  late final ValueNotifier<DateTime?> _selectedDay;
  late final ValueNotifier<DateTime?> _focusedDay;
  late final ValueNotifier<Map<DateTime, String?>> _eventMoods;

  @override
  void initState() {
    super.initState();
    _selectedDay = ValueNotifier<DateTime?>(DateTime.now());
    _focusedDay = ValueNotifier<DateTime?>(DateTime.now());
    _eventMoods = ValueNotifier<Map<DateTime, String?>>({});
    _loadEventMoods();
  }

  Future<void> _loadEventMoods() async {
    final entries = await DiaryDatabaseHelper.instance.getAllEntries();
    final newEventMoods = <DateTime, String?>{};
    for (var entry in entries) {
      final date = entry.date;
      newEventMoods[DateTime(date.year, date.month, date.day)] = entry.mood;
    }
    setState(() {
      _eventMoods.value = newEventMoods;
    });
  }

  void refreshCalendar() {
    _loadEventMoods();
  }

  @override
  void dispose() {
    _selectedDay.dispose();
    _focusedDay.dispose();
    _eventMoods.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario'),
      ),
      body: Container(
        color: theme.brightness == Brightness.dark ? 
              ScreenBackground.darkBackground : ScreenBackground.lightBackground,
        child: ValueListenableBuilder<Map<DateTime, String?>>(
          valueListenable: _eventMoods,
          builder: (context, eventMoods, _) {
            return CalendarBody(
              selectedDay: _selectedDay,
              focusedDay: _focusedDay,
              eventMoods: eventMoods,
            );
          },
        ),
      ),
    );
  }
}