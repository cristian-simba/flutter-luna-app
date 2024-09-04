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
  
}