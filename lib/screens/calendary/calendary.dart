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
    final backgroundColor = theme.brightness == Brightness.dark 
              ? ScreenBackground.darkBackground 
              : ScreenBackground.lightBackground;
              
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          child: SizedBox.expand(
            child: ValueListenableBuilder<Map<DateTime, String?>>(
              valueListenable: _eventMoods,
              builder: (context, eventMoods, _) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 17),
                        child: Text("Seguimiento de ánimo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: CalendarBody(
                          selectedDay: _selectedDay,
                          focusedDay: _focusedDay,
                          eventMoods: eventMoods,
                        ),
                      )
                    ],
                  )
                );
              },
            ),
          ),
        ),
      ),
    );
  }

}

