import 'package:device/helper/local_db_helper.dart';
import 'package:device/model/local_db_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DbCrudHelper{
  var storage = FlutterSecureStorage();
  static final shared = DbCrudHelper();


  void insert(int status, String travelId, String proccessId, double lat,
      double long, String price, String duration, String zaman) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnImei: await storage.read(key: "imei"),
      DatabaseHelper.columnStatus: status,
      DatabaseHelper.columnTravelId: travelId,
      DatabaseHelper.columnProccessId: proccessId,
      DatabaseHelper.columnLat: lat,
      DatabaseHelper.columnLong: long,
      DatabaseHelper.columnPrice: price,
      DatabaseHelper.columnDuration: duration,
      DatabaseHelper.columnZaman: zaman,
    };
    LocaldbModel dba = LocaldbModel.FromMap(row);
    final id = await dbHelper.insert(dba);
  }

  DatabaseHelper dbHelper = DatabaseHelper.instance;
  List deneme = [];
  void queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    print('Q-rows:');
    allRows.forEach((row) {
      // print(row);
      deneme.add(LocaldbModel.FromMap(row));
      print(deneme);
    });
  }
}