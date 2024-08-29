import 'package:flutter/material.dart';
import 'package:luna/widgets/date_picker.dart';
import 'package:luna/utils/date_formatter.dart';

class DateButton extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const DateButton({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
  }) : super(key: key);

  void _showDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomCalendar(
        onDateSelected: onDateChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDatePicker(context),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 2.0),
        child: Row(
          children: [
            const Icon(Icons.event, size: 26, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              formatDate(selectedDate),
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}