import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  String formatted = DateFormat('MMMM d', 'es_ES').format(date);
  return formatted[0].toUpperCase() + formatted.substring(1);
}