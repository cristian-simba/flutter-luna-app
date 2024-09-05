class EventMood {
  final DateTime date;
  final String mood;

  EventMood({required this.date, required this.mood});

  factory EventMood.fromMap(Map<String, dynamic> map) {
    return EventMood(
      date: DateTime.parse(map['date']),
      mood: map['mood'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'mood': mood,
    };
  }
}