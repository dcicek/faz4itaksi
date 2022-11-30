import 'dart:convert';

import 'package:device/constant/api_config.dart';
import 'package:device/model/vast_response.model.dart';
import 'package:http/http.dart' as http;

class VastServiceManager {
  static var client = http.Client();

  static Future<VastResponseModel> getVast() async {
    var url = Uri.http(ApiConfig.vastBaseUrl, ApiConfig.vast);

    var response = await client.get(url);
    return vastResponseModel(response.body);
  }
}
