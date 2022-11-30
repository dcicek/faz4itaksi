//import 'dart:html';
import 'dart:convert';
import 'package:device/constant/api_config.dart';
import 'package:device/model/base_response_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/tariff_model.dart';

class TariffServiceManager {

  Future<Tariff> getTariff()
  async {
    //final url = Uri.parse(adres);
    //final response = await http.get(url);
    var response = await rootBundle.loadString('assets/tariff_model.json');

    return Tariff.fromJson(json.decode(response));
    //Map<String, dynamic> map = await json.decode(response);
    //return map;

  }

}
