//import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:device/constant/api_config.dart';
import 'package:device/core/controller_all.dart';
import 'package:device/helper/local_db_helper.dart';
import 'package:device/model/base_response_model.dart';
import 'package:device/model/send_db_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignupServiceManager {
  var storage = FlutterSecureStorage();

  var client = http.Client();

  Future<BaseResponseModel> deviceRegister(
      String imei, String plate, String serial_number) async {
    var url = Uri.http(ApiConfig.baseURL, ApiConfig.deviceRegister);

    var response = await client.post(
      url,
      headers: ApiConfig.jsonHeader,
      body: jsonEncode(
          {"imei": imei, "plate": plate, "serialNumber": serial_number}),
    );
    return baseResponseJSON(response.body);
  }

  Future<BaseResponseModel> deviceRegisterCheck(String imei) async {
    var url = Uri.http(ApiConfig.baseURL, ApiConfig.deviceRegisterCheck);

    var response = await client.post(
      url,
      headers: ApiConfig.jsonHeader,
      body: jsonEncode({
        "imei": imei,
      }),
    );
    return baseResponseJSON(response.body);
  }

  Future<BaseResponseModel> connectionTest() async {
    var url = Uri.http(ApiConfig.baseURL, "/");
    http.Response response;
    try {
      response = await client.get(url);
    } catch (e) {
      return BaseResponseModel(
          message: e.toString(),
          status: false,
          data: {"": ""},
          statusCode: 404);
    }
    return baseResponseJSON(response.body);
  }

  sendlo(lat, long, processId, zaman,travelId) async {
    try {
      var url = Uri.http(ApiConfig.baseURL, ApiConfig.location);

      var response = await client.post(
        url,
        headers: ApiConfig.jsonHeader,
        body: jsonEncode({
          "imei": await storage.read(key: "imei"),
          "lat": lat,
          "long": long,
          "processId": processId,
          "zaman": zaman,
           "travelId": travelId
        }),
      );
      return baseResponseJSON(response.body);
    } catch (e) {
      print(e);
    }
  }

  DatabaseHelper dbHelper = DatabaseHelper.instance;
  
  Future sendTaximeter() async {

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      print("TAKSİMETRE BİLGİLERİ GÖNDERİLECEK");
      GetAllController.instance.sendDb.clear();
      final allRows = await dbHelper.queryAllRows();

      var url = Uri.http(ApiConfig.baseURL, ApiConfig.taximeter);
      for (var item in allRows) {
        GetAllController.instance.sendDb.add(SendDb.FromMap(item));
      }
      // var url =
      //     Uri.parse("https://webhook.site/0eb7d661-6137-4617-a9ca-35d4d67e7c22");
      try {
        if (GetAllController.instance.sendDb.isNotEmpty) {
          for (var i = 0; i < GetAllController.instance.sendDb.length; i++) {
            var response = await client.post(
              url,
              headers: {
                'Content-type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({
                "imei": await storage.read(key: "imei"),
                "status": GetAllController.instance.sendDb[i].status,
                "travelId": GetAllController.instance.sendDb[i].travelId,
                "processId": GetAllController.instance.sendDb[i].proccesId,
                "lat": GetAllController.instance.sendDb[i].lat,
                "long": GetAllController.instance.sendDb[i].long,
                "zaman": GetAllController.instance.sendDb[i].zaman,
                "price": GetAllController.instance.sendDb[i].price,
                "duration": GetAllController.instance.sendDb[i].duration,
              }),
            );
            var body = response.body;
            var ref = await jsonDecode(body);
            if (ref["status"]) {
              dbHelper.delete(GetAllController.instance.sendDb[i].id!);
              GetAllController.instance.sendDb.removeWhere(
                  (p0) => p0.id == GetAllController.instance.sendDb[i].id);
            }
            print("RESPONSE*** ${response.body}");
            debugPrint(response.body);
          }
        }
      } catch (e) {
        print(e);
      }
    });

    //return baseResponseJSON(response.body);
  }

  Future updateStatu() async {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      var statu = await storage.read(key: "statu");

      var url = Uri.http(ApiConfig.baseURL, ApiConfig.updateStatu);
      var response = await client.post(
        url,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "imei": await storage.read(key: "imei"),
          "statu": statu == "true" ? true : false,
        }),
      );
      var body = await jsonDecode(response.body);
      // print(body);
      // print(await jsonDecode( response.body));
    });
  }

}
