import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TravelDataHistories {
  late SharedPreferences _pref;

  static const taximeterKey = "taximeterDataHistory";
  List<TravelHistoryModel> travelDataHistories = [];

  TravelDataHistories() {
    readStorage();
  }

  TravelDataHistories.fromJson(Map<String, dynamic> json) {
    travelDataHistories = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['data'] = jsonEncode(travelDataHistories);

    return data;
  }

  Future<void> readStorage() async {
    //_storage.delete(key: taximeterKey);
    _pref = await SharedPreferences.getInstance();
    var res = await _pref.getString(taximeterKey);
    travelDataHistories = res == null
        ? []
        : List<TravelHistoryModel>.from(
            (jsonDecode(res)["data"] as List<dynamic>)
                .map((model) => TravelHistoryModel.fromJson(model)));
  }

  Future<bool> addData(TravelHistoryModel travelHistoryModel) async {
    travelDataHistories.add(travelHistoryModel);
    _pref = await SharedPreferences.getInstance();

    await _pref.setString(
        taximeterKey, '{"data" :${jsonEncode(travelDataHistories)}}');
    return true;
  }

  Future<bool> removeData(String processId) async {
    travelDataHistories
        .removeWhere((element) => element.processId == processId);
    await _pref.setString(
        taximeterKey, '{"data" :${jsonEncode(travelDataHistories)}}');
    return true;
  }
}

class TravelHistoryModel {
  String? token;
  String? travelId;
  String? processId;
  int? status;
  double? lat;
  double? long;
  String? price;
  int? duration;
  String? zaman;

  TravelHistoryModel(
      {required this.token,
      required this.status,
      required this.travelId,
      required this.processId,
      this.lat,
      this.long,
      this.price,
      this.duration,
      this.zaman});

  TravelHistoryModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    status = json['status'];
    lat = json['lat'];
    long = json['long'];
    price = json['price'];
    travelId = json['travelId'];
    processId = json['processId'];
    duration = json['duration'];
    zaman = json['zaman'];
  }
  //TravelHistoryModel.fromlist(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['token'] = token;
    data['status'] = status;
    data['lat'] = lat;
    data['long'] = long;
    data['travelId'] = travelId;
    data['price'] = price;
    data['processId'] = processId;
    data['duration'] = duration;
    data['zaman'] = zaman;

    return data;
  }
}
