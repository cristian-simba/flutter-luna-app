class DiaryEntry{
  int? id;
  String date;
  String content;

  DiaryEntry({this.id, required this.date, required this.content});

  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'date': date,
      'content': content
    };
  }

  static DiaryEntry fromMap(Map<String, dynamic> map){
    return DiaryEntry(
      id: map['id'],
      date: map['date'],
      content: map['content']
    );
  }

}