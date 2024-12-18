import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:luna/screens/calendary/components/day_cell.dart';
import 'package:intl/intl.dart';
import 'package:luna/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';

class CalendarBody extends StatelessWidget {
  final ValueNotifier<DateTime?> selectedDay;
  final ValueNotifier<DateTime?> focusedDay;
  final Map<DateTime, String?> eventMoods;
  final Function(DateTime) onDaySelected;

  const CalendarBody({
    Key? key,
    required this.selectedDay,
    required this.focusedDay,
    required this.eventMoods,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;
    final cardColor = theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard;
    final bannerColor = theme.brightness == Brightness.dark ? iconColor.withOpacity(0.8) : iconColor.withOpacity(1);
    final horizontalColor = theme.brightness == Brightness.dark ? CalendarBodyColors.darkHorizontalLines : CalendarBodyColors.lightHorizontalLines;

    return ValueListenableBuilder<DateTime?>(
      valueListenable: focusedDay,
      builder: (context, focusedDayValue, _) {
        return ValueListenableBuilder<DateTime?>(
          valueListenable: selectedDay,
          builder: (context, selectedDayValue, _) {
            return Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: TableCalendar(
                  locale: "es_ES",
                  rowHeight: 65,
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: focusedDayValue!,
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDayValue, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    this.selectedDay.value = selectedDay;
                    this.focusedDay.value = focusedDay;
                    onDaySelected(selectedDay);
                  },
                  onPageChanged: (focusedDay) {
                    this.focusedDay.value = focusedDay;
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white),
                    titleTextFormatter: (date, locale) {
                      String formattedMonth = DateFormat.MMMM(locale).format(date);
                      String formattedYear = DateFormat.y(locale).format(date);
                      String formattedDate = '$formattedMonth $formattedYear';
                      return formattedDate.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
                    },
                    headerPadding: EdgeInsets.all(3),
                    leftChevronIcon: Icon(Icons.arrow_left, size: 25, color: Colors.white),
                    rightChevronIcon: Icon(Icons.arrow_right, size: 25, color: Colors.white),
                    decoration: BoxDecoration(
                      color: bannerColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    ),
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
                          color: horizontalColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final mood = eventMoods[DateTime(day.year, day.month, day.day)];
                      return DayCell(
                        day: day,
                        mood: mood,
                        isSelected: isSameDay(selectedDayValue, day),
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      final mood = eventMoods[DateTime(day.year, day.month, day.day)];
                      return DayCell(
                        day: day,
                        mood: mood,
                        isSelected: true,
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      final mood = eventMoods[DateTime(day.year, day.month, day.day)];
                      return DayCell(
                        day: day,
                        mood: mood,
                        isSelected: isSameDay(selectedDayValue, day),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
