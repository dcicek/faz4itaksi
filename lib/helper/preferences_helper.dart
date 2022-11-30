import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  late SharedPreferences _pref;
  static var shared = SharedPreferencesHelper();

  // User Control
  void userControl({required void Function(bool) completionHandler}) async {
    _pref = await SharedPreferences.getInstance();
    var token = _pref.getString('token');
    if (token != null) {
      completionHandler(true);
    } else {
      completionHandler(false);
    }
  }

  // Return Token
  Future<String> getToken() async {
    _pref = await SharedPreferences.getInstance();
    var token = _pref.getString('jwt') ?? "";
    return token;
  }

  // Return MyID
  Future<bool> setToken(String jwt) async {
    _pref = await SharedPreferences.getInstance();
    var res = _pref.setString('jwt', jwt);
    return res;
  }

  //Remove Token and ID
  Future<void> removeToken() async {
    _pref = await SharedPreferences.getInstance();
    _pref.remove('jwt');
  }
}
