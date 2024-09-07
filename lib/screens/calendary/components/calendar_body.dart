import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:luna/screens/calendary/components/day_cell.dart';
import 'package:intl/intl.dart';
import 'package:luna/constants/colors.dart';

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
    final theme = Theme.of(context);

    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: TableCalendar(
              locale: "es_ES",
              rowHeight: 65,
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
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                titleTextFormatter: (date, locale) {
                  String formattedMonth = DateFormat.MMMM(locale).format(date);
                  String formattedYear = DateFormat.y(locale).format(date);
                  String formattedDate = '$formattedMonth $formattedYear';
                  return formattedDate.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
                },
                leftChevronIcon: Icon(Icons.arrow_left, size: 25),
                rightChevronIcon: Icon(Icons.arrow_right, size: 25),
              ),
              daysOfWeekHeight: 50,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                weekendStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                dowTextFormatter: (date, locale) =>
                    DateFormat.E(locale).format(date)[0].toUpperCase(),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.brightness == Brightness.dark
                          ? CalendarBodyColors.darkHorizontalLines
                          : CalendarBodyColors.lightHorizontalLines,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final mood = eventMoods[DateTime(day.year, day.month, day.day)];
                  return DayCell(day: day, mood: mood);
                },
                selectedBuilder: (context, day, focusedDay) {
                  final mood = eventMoods[DateTime(day.year, day.month, day.day)];
                  return DayCell(day: day, mood: mood);
                },
                todayBuilder: (context, day, focusedDay) {
                  final mood = eventMoods[DateTime(day.year, day.month, day.day)];
                  return DayCell(day: day, mood: mood);
                },
              ),
            ),
          )
        ),
      ],
    );
  }
}
