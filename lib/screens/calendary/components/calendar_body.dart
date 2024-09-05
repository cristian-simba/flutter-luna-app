import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:luna/screens/calendary/components/day_cell.dart';
import 'package:intl/intl.dart';

class CalendarBody extends StatelessWidget {
  final ValueNotifier<DateTime?> selectedDay;
  final ValueNotifier<DateTime?> focusedDay;
  final Map<DateTime, String?> eventMoods;

  const CalendarBody({
    Key? key,
    required this.selectedDay,
    required this.focusedDay,
    required this.eventMoods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TableCalendar(
        locale: "es_ES",
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay.value!,
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay.value, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          this.selectedDay.value = selectedDay;
          this.focusedDay.value = focusedDay;
        },
        onPageChanged: (focusedDay) {
          this.focusedDay.value = focusedDay;
        },
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronIcon: Icon(Icons.chevron_left),
          rightChevronIcon: Icon(Icons.chevron_right),
        ),
        daysOfWeekHeight: 31, 
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) =>
              DateFormat.E(locale).format(date)[0].toUpperCase(),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
            ),
          ),
        ),
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            final text = DateFormat.E().format(day)[0].toUpperCase();
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0), 
                child: Text(text),
              ),
            );
          },
          defaultBuilder: (context, day, focusedDay) {
            return DayCell(day: day, mood: eventMoods[DateTime(day.year, day.month, day.day)]);
          },
          selectedBuilder: (context, day, focusedDay) {
            return DayCell(day: day, mood: eventMoods[DateTime(day.year, day.month, day.day)]);
          },
          todayBuilder: (context, day, focusedDay) {
            return DayCell(day: day, mood: eventMoods[DateTime(day.year, day.month, day.day)]);
          },
        ),
      ),
    );
  }
}