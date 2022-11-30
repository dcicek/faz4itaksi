//import 'dart:html';
import 'dart:convert';
import 'package:device/constant/api_config.dart';
import 'package:device/model/base_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeServiceManager {
  var client = http.Client();

  Future<BaseResponseModel> getDriverDetail() async {
    var url = Uri.http(ApiConfig.baseURL, ApiConfig.driverDetail);

    var response = await client.post(url, headers: ApiConfig.jsonHeader);
    return baseResponseJSON(response.body);
  }
}
