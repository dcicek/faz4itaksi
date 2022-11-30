import 'package:device/viewmodel/home_view_model/home_view_model.dart';
import 'package:device/viewmodel/qr_view_model/qr_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class XuGetIt {
  static void setup() {
    getIt.registerSingleton<HomeState>(HomeState(), signalsReady: true);
    getIt.registerSingleton<QrLoginState>(QrLoginState(), signalsReady: true);
  }
}
