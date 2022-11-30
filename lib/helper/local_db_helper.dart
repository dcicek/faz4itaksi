import 'dart:async';

import 'package:device/model/local_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "taximeterData.db";
  static final _databaseVersion = 1;
  static final table = 'taximeterData_table';
  static final columnId = 'id';
  static final columnImei = 'imei';
  static final columnStatus = 'status';
  static final columnTravelId = 'travelId';
  static final columnProccessId = 'processId';
  static final columnLat = 'lat';
  static final columnLong = 'long';
  
  static final columnPrice = 'price';
  static final columnDuration = 'duration';
  static final columnZaman = 'zaman';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnImei TEXT NOT NULL,
        $columnStatus INTEGER NOT NULL,
        $columnTravelId TEXT NOT NULL,
        $columnProccessId TEXT,
        $columnLat REAL NOT NULL,
        $columnLong REAL NOT NULL,
        $columnPrice TEXT NOT NULL,
        $columnDuration TEXT NOT NULL,
        $columnZaman TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(LocaldbModel model) async {
    Database? db = await instance.database;
    return await db!.insert(table, {
      columnImei: model.imei,
      columnStatus: model.status,
      columnTravelId: model.travelId,
      columnProccessId: model.proccesId,
      columnLat: model.lat,
      columnLong: model.long,
      columnPrice: model.price,
      columnDuration: model.duration,
      columnZaman: model.zaman,
    });
  }

  Future<int> update(LocaldbModel localdbModel) async {
    Database? db = await instance.database;
    int id = localdbModel.toMap()['id'];
    return await db!.update(table, localdbModel.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  
  }
  Future<List<Map<String,dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }
}
