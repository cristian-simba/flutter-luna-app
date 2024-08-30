import 'dart:convert';

class DiaryEntry {
  final int? id;
  final String content;
  final DateTime date;
  final String? songName;
  final String? songUrl;
  final List<String> imagePaths;

  DiaryEntry({
    this.id,
    required this.content,
    required this.date,
    this.songName,
    this.songUrl,
    required this.imagePaths,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
      'songName': songName,
      'songUrl': songUrl,
      'imagePaths': jsonEncode(imagePaths),
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      songName: map['songName'],
      songUrl: map['songUrl'],
      imagePaths: List<String>.from(jsonDecode(map['imagePaths'])),
    );
  }
}