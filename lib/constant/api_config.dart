import 'package:device/helper/preferences_helper.dart';

class ApiConfig {
  static const baseURL = "89.43.78.197:3000";
  static const httpBaseURL = "http://89.43.78.197:3000";
  static const deviceRegister = "/device/signup";
  static const deviceRegisterCheck = "/device/signupcheck";
  static const driverDetail = "/driver/account";
  static const location = "/device/location";
  static const taximeter = "/device/taximeter";

  static const updateStatu = "/device/updateStatu";

  static const String vastBaseUrl = "tuhim.mobilulasim.com";
  static const String vast = "/vast.php";

  static setToken(String token) async {
    jsonHeader = {
      'Content-Type': 'application/json',
      'token': await SharedPreferencesHelper.shared.getToken(),
      'type': '3'
    };
  }

  static Map<String, String> jsonHeader = {
    'Content-Type': 'application/json',
    'type': '3',
  };
}
