import 'dart:io';

import 'package:device/core/get_it.dart';
import 'package:device/views/home_view.dart';
import 'package:device/views/landing_view.dart';
import 'package:device/views/qr_login_view.dart';
import 'package:device/views/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future main() async {
  XuGetIt.setup();
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: "LandingView",
      // routes: {
      //   "LandingView": (context) => LandingView(),
      //   "HomeView": (context) => HomeView(),
      //   "SignupView": (context) => const SignupView(),
      //   "QrLoginView": (context) => QrLoginView(),
      // },
      home: LandingView(),
    );
  }
}
