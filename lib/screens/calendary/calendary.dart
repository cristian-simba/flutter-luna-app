import 'package:flutter/material.dart';
import 'package:luna/screens/calendary/components/calendar_body.dart';
import 'package:luna/services/database.dart';
import 'package:luna/models/diary_entry.dart';
import 'package:luna/screens/diary/components/view/diary_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';
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
  late final ValueNotifier<List<DiaryEntry>> _selectedDayEntries;
  Future<List<DiaryEntry>>? _entriesFuture;

  @override
  void initState() {
    super.initState();
    _selectedDay = ValueNotifier<DateTime?>(DateTime.now());
    _focusedDay = ValueNotifier<DateTime?>(DateTime.now());
    _eventMoods = ValueNotifier<Map<DateTime, String?>>({});
    _selectedDayEntries = ValueNotifier<List<DiaryEntry>>([]);
    loadEntries();

    _loadEventMoods();
    _loadSelectedDayEntries(_selectedDay.value!);
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

  Future<void> _loadSelectedDayEntries(DateTime day) async {
    final entries = await DiaryDatabaseHelper.instance.getEntriesForDate(day);
    _selectedDayEntries.value = entries;
  }

  void loadEntries() {
    setState(() {
      _entriesFuture = DiaryDatabaseHelper.instance.getAllEntries();
    });
  }

  void refreshCalendar() {
    _loadEventMoods();
    _loadSelectedDayEntries(_selectedDay.value!);
  }

  @override
  void dispose() {
    _selectedDay.dispose();
    _focusedDay.dispose();
    _eventMoods.dispose();
    _selectedDayEntries.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;
    final backgroundColor = theme.brightness == Brightness.dark 
              ? ScreenBackground.darkBackground 
              : ScreenBackground.lightBackground;
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              _buildTopTitle(), 
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        _buildCalendar(),
                        const SizedBox(height: 5),
                        ValueListenableBuilder<List<DiaryEntry>>(
                          valueListenable: _selectedDayEntries,
                          builder: (context, entries, _) {
                            if (entries.isEmpty) {
                              return _buildEmptyDiary(iconColor);
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTitleFound(),
                                  _buildDiaryCard(entries),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTitleFound() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Diarios encontrados",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
    );
  }

  Padding _buildTopTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 17),
      child: Text(
        "Calendario",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  ValueListenableBuilder<Map<DateTime, String?>> _buildCalendar() {
    return ValueListenableBuilder<Map<DateTime, String?>>(
      valueListenable: _eventMoods,
      builder: (context, eventMoods, _) {
        return CalendarBody(
          selectedDay: _selectedDay,
          focusedDay: _focusedDay,
          eventMoods: eventMoods,
          onDaySelected: (day) {
            _loadSelectedDayEntries(day);
          },
        );
      },
    );
  }

  Card _buildEmptyDiary(Color iconColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      color: iconColor.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            SvgPicture.asset(
              'assets/svgs/not_found.svg', 
              height: 60, 
              width: 40,
            ),
            const SizedBox(height: 10), 
            const Center(
              child: Text(
                "No se escribió ningún diario en este día.",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView _buildDiaryCard(List<DiaryEntry> entries) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return DiaryCard(
          entry: entry,
          onDelete: () {
            loadEntries();
            refreshCalendar();
          },
          onUpdate: () {
            loadEntries();
            refreshCalendar();
          },
        );
      },
    );
  }

}
