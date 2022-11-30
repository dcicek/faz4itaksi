import 'dart:core';
import 'dart:io';
import 'package:device/constant/images_path.dart';
import 'package:device/helper/toast_helper.dart';
import 'package:device/service/signup_service_manager.dart';
import 'package:device/views/home_view.dart';
import 'package:device/views/qr_login_view.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

TextEditingController _controller = TextEditingController();

class _SignupViewState extends State<SignupView> {
  static const platform = const MethodChannel("com.flutter.epic/epic");
  String plateString = "";
  bool errorText = false;
  var storage = FlutterSecureStorage();

  String? imei;
  final SignupServiceManager _signupServiceManager = SignupServiceManager();

  @override
  void initState() {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
    printy();
    _getImei();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImagesPath.backgroundColor),
                    fit: BoxFit.cover),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        height: 200,
                        width: 200,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(ImagesPath.logo),
                        )),
                      ),
                    ],
                  ),
                  // Container(
                  //   child: Text(
                  //     ImagesPath.text,
                  //     style:
                  //         TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    height: 70,
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-Z0-9]+$')),
                      ],
                      maxLength: 9,
                      maxLines: 1,
                      controller: _controller,
                      decoration: InputDecoration(
                          errorText: _controllerErrorText(),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          labelText: 'Plakanızı Giriniz'),
                      onChanged: (String value) {
                        plateString = value;
                        setState(() {
                          errorText = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(50)),
                        child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              errorText = true;
                            });
                            if (_controllerErrorText() == null &&
                                imei != null) {
                              var plate = _controller.text.toUpperCase().trim();
                              var response =
                                  await _signupServiceManager.deviceRegister(
                                      imei as String, plate, value.toString());
                              if (response.status) {
                                //Navigator.popAndPushNamed(context, "QrLoginView");
                                await storage.write(key: "plate", value: plate);
                                Get.offAll(QrLoginView());
                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => QrLoginView()),
                                //   (route) => false,
                                // );
                              } else {
                                ToastHelper.shared
                                    .showErrorToast(response.message);
                              }
                            }
                          },
                          child: const Text(
                            "KAYIT OL",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _controllerErrorText() {
    if (plateString != "" && errorText) {
      var plate = _controller.text.trim();
      if (plate.length < 6) {
        return "Plakanızı doğru giriniz.";
      }
    }
    if (plateString == "" && errorText) {
      return "Plaka boş bırakılamaz.";
    }
    return null;
  }

  _getImei() async {
    imei = await DeviceInformation.deviceIMEINumber;
    if (imei == "") {
      ToastHelper.shared.showErrorToast("Imei bilginiz okunamadi!");
      exit(0);
    }
  }

  String? value;
  void printy() async {
    try {
      setState(() async {
        value = await platform.invokeMethod("Printy");
      });
    } catch (e) {}

    print(value);
  }
}
