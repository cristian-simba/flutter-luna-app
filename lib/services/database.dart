import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:luna/models/diary_entry.dart';

class DatabaseService{
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  static Database? _database; 

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'luna.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
            CREATE TABLE diary_entries (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              date TEXT NOT NULL,
              content TEXT NOT NULL 
            )
          '''
        );
      }
    );
  }
  
  Future <int> insertDiaryEntry(DiaryEntry entry) async {
    final db = await database;
    return await db.insert('diary_entries', entry.toMap());
  }

  Future <List<DiaryEntry>> getDiaryEntries() async {
    final db = await database;
    final maps = await db.query('diary_entries');
    return List.generate(maps.length, (i) => DiaryEntry.fromMap(maps[i]));
  }

}