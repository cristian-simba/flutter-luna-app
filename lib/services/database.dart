import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:luna/models/diary_entry.dart';

class DiaryDatabaseHelper {
  static final DiaryDatabaseHelper instance = DiaryDatabaseHelper._init();
  static Database? _database;

  DiaryDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE diary_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT,
        date TEXT,
        songName TEXT,
        songUrl TEXT,
        imagePaths TEXT,
        mood TEXT 
      )
    ''');
  }

  // Future<int> insertEntry(DiaryEntry entry) async {
  //   final db = await database;
  //   return await db.insert('diary_entries', entry.toMap());
  // }

  Future<int> insertEntry(DiaryEntry entry) async {
    final db = await database;
    final entryMap = entry.toMap();

    // Inserta la entrada y obtiene el ID generado
    final id = await db.insert('diary_entries', entryMap);

    // Imprime el ID generado para depuración
    print('El ID generado es: $id');
    
    return id;
  }

  Future<List<DiaryEntry>> getAllEntries() async {
    final db = await database;
    final maps = await db.query('diary_entries', orderBy: 'date DESC');
      print('Lo que se debe ver: $maps'); 
    return List.generate(maps.length, (i) => DiaryEntry.fromMap(maps[i])); 
  }

  Future<DiaryEntry?> getEntry(int id) async {
    final db = await database;
    final maps = await db.query('diary_entries', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return DiaryEntry.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateEntry(DiaryEntry entry) async {
    final db = await database;
    return await db.update(
      'diary_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteEntry(int id) async {
    final db = await database;
    return await db.delete(
      'diary_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getDiaryCount() async {
    final db = await database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM diary_entries')) ?? 0;
  }

  Future<Map<String, int>> getWeeklyMoodCounts() async {
    final db = await database;
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: 7));
    final weekEnd = now; // Hasta ahora

    final result = await db.rawQuery('''
      SELECT mood, COUNT(*) as count
      FROM diary_entries
      WHERE date BETWEEN ? AND ?
      GROUP BY mood
      ORDER BY count DESC
      LIMIT 5
    ''', [weekStart.toIso8601String(), weekEnd.toIso8601String()]);

    return Map.fromEntries(result.map((e) => MapEntry(e['mood'] as String, e['count'] as int)));
  }

  Future<Map<String, int>> getMonthlyMoodCounts() async {
    final db = await database;
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final nextMonthStart = DateTime(now.year, now.month + 1, 1);

    final result = await db.rawQuery('''
      SELECT mood, COUNT(*) as count
      FROM diary_entries
      WHERE date BETWEEN ? AND ?
      GROUP BY mood
    ''', [monthStart.toIso8601String(), nextMonthStart.toIso8601String()]);

    return Map.fromEntries(result.map((e) => MapEntry(e['mood'] as String, e['count'] as int)));
  }

  Future<Map<String, int>> getAnnualMoodCounts() async {
    final db = await database;
    final now = DateTime.now();
    final yearStart = DateTime(now.year, 1, 1);
    final yearEnd = DateTime(now.year + 1, 1, 1);

    final result = await db.rawQuery('''
      SELECT mood, COUNT(*) as count
      FROM diary_entries
      WHERE date BETWEEN ? AND ?
      GROUP BY mood
    ''', [yearStart.toIso8601String(), yearEnd.toIso8601String()]);

    final moods = ['Feliz', 'Triste', 'Enojado', 'Sorprendido', 'Cansado', 'Normal', 'Confundido'];
    final moodCounts = {for (var mood in moods) mood: 0};

    for (var row in result) {
      final mood = row['mood'] as String;
      final count = row['count'] as int;
      moodCounts[mood] = count;
    }

    // Ordenar los resultados de mayor a menor
    final sortedMoodCounts = Map.fromEntries(
      moodCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value))
    );

    return sortedMoodCounts;
  }

}