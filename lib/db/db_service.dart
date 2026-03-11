import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lolify/models/meme_model.dart';

class DataBaseService {
  static Database? _database;

  // получение БД
  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // создание БД
  Future<Database> _initDatabase() async {
    String dbPath = join(await getDatabasesPath(), 'database.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE memes(
            id_meme INTEGER PRIMARY KEY AUTOINCREMENT,
            desc TEXT NOT NULL UNIQUE,
            url TEXT NOT NULL UNIQUE
          )
        ''');
      },
    );
  }

  // добавить мем в избранное
  Future<void> insertMeme(String desc, String imageUrl) async {
    try {
      final db = await _db;
      await db.insert('memes', {'desc': desc, 'url': imageUrl});
    } catch (e) {
      throw Exception('Ошибка при добавлений мема: $e');
    }
  }

  // получить избранные мемы
  Future<List<Meme>> getAllMemes() async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> memes = await db.query('memes');
      return List.generate(memes.length, (i) {
        return Meme(
          id: memes[i]['id_meme'],
          desc: memes[i]['desc'],
          imageUrl: memes[i]['url'],
        );
      });
    } catch (e) {
      throw Exception('Ошибка при загрузке мемов: $e');
    }
  }

  // удалить мем из избранного
  Future<void> deleteMeme(int id) async {
    try {
      final db = await _db;
      await db.delete('memes', where: 'id_meme = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Ошибка при удалений мема: $e');
    }
  }
}
