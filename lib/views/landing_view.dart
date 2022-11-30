import 'dart:io';
import 'package:device/constant/images_path.dart';
import 'package:device/helper/socket_helper.dart';
import 'package:device/helper/toast_helper.dart';
import 'package:device/service/signup_service_manager.dart';
import 'package:device/views/home_view.dart';
import 'package:device/views/qr_login_view.dart';
import 'package:device/views/signup_view.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LandingView extends StatefulWidget {
  LandingView({Key? key}) : super(key: key);

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _signupCheck();
    sendImei();
  }

  final SignupServiceManager _signupServiceManager = SignupServiceManager();

  String? imei;
  var storage = FlutterSecureStorage();

  bool connectionError = false;

  _signupCheck() async {
    var connectionResult = await _signupServiceManager.connectionTest();
    if (!connectionResult.status) {
      setState(() {
        connectionError = true;
      });
      //ToastHelper.shared.showErrorToast("Bağlantı hatası!");
      Future.delayed(Duration(seconds: 10), _signupCheck);
      return;

      //exit(0);
    }
    ToastHelper.shared.showSuccessToast("Bağlantı sağlandı!");
    setState(() {
      connectionError = false;
    });
    await _permissionRequest();
    var result =
        await _signupServiceManager.deviceRegisterCheck(imei as String);
    //ToastHelper.shared.showSuccessToast(result.message);

    if (result.status && result.statusCode == 200) {
      // Navigator.popAndPushNamed(context, "QrLoginView");
      //var plateCheck = await storage.read(key: "plate");

      Get.offAll(QrLoginView());
    } else if (result.status && result.statusCode == 201) {
      // Navigator.popAndPushNamed(context, "SignupView");
      Get.offAll(const SignupView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImagesPath.backgroundColor),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Visibility(
                            visible: connectionError,
                            child: Text(
                              "Bağlantı hatası!",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.height * 0.5,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage(ImagesPath.logo),
                            )),
                          ),
                        ),
                        // Container(
                        //   child: Text(
                        //     ImagesPath.text,
                        //     style: TextStyle(
                        //         fontSize: 40, fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        // Container(
                        //   height: MediaQuery.of(context).size.height * 0.35,
                        //   width: MediaQuery.of(context).size.height * 0.6,
                        //   child: const Image(
                        //     image: AssetImage(ImagesPath.ibblogo),
                        //     alignment: Alignment.center,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _permissionRequest() async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      //ToastHelper.shared.showSuccessToast("Izin alindi!!!!!!");
    } else {
      ToastHelper.shared.showErrorToast(
          "Lutfen izin veriniz aksi halde uygulama kapanacaktir!");

      await Future.delayed(Duration(seconds: 2), () async {
        var status = await Permission.phone.request();

        if (status.isGranted) {
          //ToastHelper.shared.showSuccessToast("Izin alindi!!!!!!");
        } else {
          ToastHelper.shared.showErrorToast(
              "Telefon okuma izni alınamadı, uygulamadan çıkılıyor...");
          exit(0);
        }
      });
    }
    if (await Permission.phone.isRestricted) {
      ToastHelper.shared.showErrorToast(
          "Telefon durumu okuma izni alınamadı, uygulamadan çıkılıyor...");
      exit(0);
    }

    status = await Permission.location.request();
    if (status.isGranted) {
      //ToastHelper.shared.showSuccessToast("Izin alindi!!!!!!");
    } else {
      ToastHelper.shared.showErrorToast(
          "Lutfen izin veriniz aksi halde uygulama kapanacaktir!");

      await Future.delayed(Duration(seconds: 2), () async {
        var status = await Permission.location.request();

        if (status.isGranted) {
          //ToastHelper.shared.showSuccessToast("Izin alindi!!!!!!");
        } else {
          ToastHelper.shared.showErrorToast(
              "Telefon okuma izni alınamadı, uygulamadan çıkılıyor...");
          exit(0);
        }
      });
    }
    if (await Permission.phone.isRestricted) {
      ToastHelper.shared.showErrorToast(
          "Telefon durumu okuma izni alınamadı, uygulamadan çıkılıyor...");
      exit(0);
    }

    imei = await DeviceInformation.deviceIMEINumber;
    if (imei == "") {
      ToastHelper.shared.showErrorToast("Imei bilginiz okunamadi!");
      exit(0);
    }
    return true;
  }

  sendImei() async {
    imei = await DeviceInformation.deviceIMEINumber;
    await storage.write(key: "imei", value: imei);
    setState(() {
      imei = imei;
    });
    if (imei == "") {
      ToastHelper.shared.showErrorToast("Imei bilginiz okunamadi!");
      exit(0);
    }
    await Future.delayed(
        Duration(seconds: 2), () => SocketHelper.shared.connectSocket2());
    SocketHelper.shared.sendImei(imei as String);
  }
}
