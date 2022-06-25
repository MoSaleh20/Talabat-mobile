import 'package:sqflite/sqflite.dart';
import 'menuItem.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();
  static final int version = 1;
  static Database _database;
  static final String tableName = 'favs';

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    path += 'favs.db';
    return await openDatabase(
      path,
      version: version,
      onCreate: (db, version) async {
        await db.execute('''
          create table $tableName (
            id integer primary key autoincrement,
            name text unique not null,
            descr text,
            price integer not null,
            rating integer,
            rest_id integer not null,
            image text
          )
          ''');
      },
    );
  }


  Future<List<MenuItem>> get favs async {
    final db = await database;
    List<Map> result = await db.query(tableName);
    List<MenuItem> favs = [];
    for (var value in result) {
      favs.add(MenuItem.fromMap(value));
    }
    return favs;
  }

  Future insert(MenuItem fav) async {
    final db = await database;
    return await db.insert(tableName, fav.toMap());
  }

  Future removeAll() async {
    final db = await database;
    return await db.delete(tableName);
  }

  Future<int> removeFav(int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id=?', whereArgs: [id]);
  }

}
