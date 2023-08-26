import 'package:ica_reader/model/ica_history.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._createInstance();
  static Database? _database;

  DbHelper._createInstance();

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'ica.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database database, int version) async {
    await database.execute('''
      CREATE TABLE ica_history(
        ica_history_id INTEGER PRIMARY KEY AUTOINCREMENT,
        read_datetime TEXT NOT NULL,
        date TEXT NOT NULL,
        ride_time TEXT NOT NULL,
        drop_time TEXT NOT NULL,
        diff_money INTEGER NOT NULL,
        rest_money INTEGER NOT NULL
      )
    ''');
  }

  Future create(IcaHistory icaHistory) async {
    final database = await instance.database;
    await database.insert('ica_history', icaHistory.toJson());
  }

  Future<List<IcaHistory>> selectAll() async {
    final database = await instance.database;
    final icaHistoryMapList = await database.query(
      'ica_history',
      orderBy: 'ica_history_id DESC',
    );

    return icaHistoryMapList.map((map) => IcaHistory.fromJson(map)).toList();
  }

  Future<int> delete(int icaHistoryId) async {
    final database = await instance.database;

    return await database.delete(
      'ica_history',
      where: 'ica_history_id = ?',
      whereArgs: [icaHistoryId],
    );
  }

  Future closeDatabase() async {
    final database = await instance.database;

    database.close();
  }
}
