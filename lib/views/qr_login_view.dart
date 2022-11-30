import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:device/constant/images_path.dart';
import 'package:device/core/controller_all.dart';
import 'package:device/core/get_it.dart';
import 'package:device/helper/db_crud_helper.dart';
import 'package:device/helper/socket_helper.dart';
import 'package:device/helper/toast_helper.dart';
import 'package:device/service/signup_service_manager.dart';
import 'package:device/viewmodel/qr_view_model/qr_view_model.dart';
import 'package:device/views/home_view.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:uuid/uuid.dart';

class QrLoginView extends StatefulWidget {
  @override
  _QrLoginViewState createState() => _QrLoginViewState();
}

class _QrLoginViewState extends State<QrLoginView> {
  final SignupServiceManager _signupServiceManager = SignupServiceManager();

  var storage = FlutterSecureStorage();
  var travelId;
  var proccedId;
  bool finishOneTime = false;
  var uuid = Uuid();
  GetAllController _controller = Get.put(GetAllController());

  var vm = getIt<QrLoginState>();
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    sendImei();
    goLocation();
    _getDataFromTaxiMeter();
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  String? imei = "";

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

  bool started = false;
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: MediaQuery.of(context).size.height * 0.45,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(ImagesPath.logo),
                              )),
                            ),
                            // Container(
                            //   child: Text(
                            //      ImagesPath.text,
                            //     style: TextStyle(
                            //         fontSize: 40, fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                            // Container(
                            //   height: MediaQuery.of(context).size.height * 0.375,
                            //   width: MediaQuery.of(context).size.height * 0.6,
                            //   child: const Image(
                            //     image: AssetImage(ImagesPath.ibblogo),
                            //     alignment: Alignment.center,
                            //   ),
                            // )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: Get.width * 0.15,
                    ),
                    Visibility(
                      visible: false,
                      child: taximeterInfo(),
                    ),
                    Visibility(
                      visible: false,
                      child: Text(getTaximeterTimeString()),
                    ),
                    Container(
                      //color: Colors.amber,
                      child: Center(
                        child: QrImage(
                          //backgroundColor: Colors.white,
                          data: imei as String,
                          size: 350,
                        ),
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
              controlStatus(),
            ],
          ),
        ),
      ),
    );
  }

  controlStatus() {
    return Observer(builder: (_) {
      if (vm.deviceIsActive && !started) {
        started = true;
        SocketHelper.shared.socketDisconnect();
        Future.delayed(Duration(seconds: 1), () => goHome());
      }
      return const Text("");
    });
  }

  goHome() {
    Get.offAll(const HomeView());
  }

  bool ref = true;

  late UsbPort port;
  List<String> showResult = [];
  List<String> encodedList = [];
  var baudRateOfPort = 9600;
  var baudRateSuccess = false;
  Future<void> _getDataFromTaxiMeter() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      //await Future.delayed(Duration(seconds: 10), _getDataFromTaxiMeter);
      return;
    }
    port = (await devices[0].create())!;

    bool openResult = await port.open();
    if (!openResult) {
      setState(() {
        ToastHelper.shared.showErrorToast(
            "Port Açılamadı! Bağlanmak için yeniden giriş yapınız.");
      });
      return;
    }

    await port.setDTR(true);
    await port.setRTS(true);

    port.setPortParameters(baudRateOfPort, UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    Future.delayed(const Duration(seconds: 2), getBaudRate);

    port.inputStream!.listen((Uint8List event) {
      baudRateSuccess = true;
      List<String> encodedList1 = HEX.encode(event).split("");
      for (var i = 0; i < encodedList1.length; i += 2) {
        encodedList.add(encodedList1[i] + encodedList1[i + 1]);
      }

      if ((encodedList.contains('02') &&
          encodedList.contains('03') &&
          (encodedList.indexOf('02') + 3 < encodedList.indexOf('03')))) {
        setState(() {
          showResult = encodedList
              .getRange(
                  encodedList.indexOf('02'), encodedList.indexOf('03') + 1)
              .toList();
        });
        encodedList.removeRange(
            encodedList.indexOf('02'), encodedList.indexOf('03') + 1);
      }
    });
    //0x02 0x6B 0x00 0x69 0x03
    //get device type
    port.write(Uint8List.fromList([0x02, 0x6B, 0x00, 0x69, 0x03]));
  }

  void getBaudRate() {
    if (!baudRateSuccess) {
      baudRateOfPort = baudRateOfPort == 4800 ? 9600 : 4800;
      _getDataFromTaxiMeter();
    }
  }

  String getTaximeterTimeString() {
    String result = "Zaman: ";
    try {
      result = taximeterTime > 0
          ? "Zaman: " +
              (((taximeterTime / 60).floor() < 10 ? "0" : "") +
                  (taximeterTime / 60).floor().toString() +
                  ":" +
                  ((taximeterTime % 60) < 10 ? "0" : "") +
                  (taximeterTime % 60).toString())
          : "Zaman: 00:00";
    } catch (e) {}
    return result;
  }

  String getTaximeterDistanceString() {
    String result = "Mesafe: ";
    try {
      result = taximeterTime > 0
          ? "Mesafe: " +
              (taximeterTime * 0.023).toString().split(".")[0] +
              "." +
              (taximeterTime * 0.023)
                  .toString()
                  .split(".")[1]
                  .split('')
                  .getRange(0, 2)
                  .join() +
              "km"
          : "Mesafe: 0.00km";
    } catch (e) {}
    return result;
  }

  String hexToAscii(String hexString) => List.generate(
        hexString.length ~/ 2,
        (i) => String.fromCharCode(
            int.parse(hexString.substring(i * 2, (i * 2) + 2), radix: 16)),
      ).join();

  String ucret = "Ücret";
  int taximeterTime = 0;
  String text = "";
  Text taximeterInfo() {
    if (showResult.isEmpty) {
      try {
        taximeterTimeCounterTimer.cancel();
      } catch (e) {}
      taximeterTime = 0;
      timerTaximeterTimerCounterEnabled = false;
      ucret = "Ücret";
      //SocketHelper.shared.sendStatu(true);
      return const Text("SERBEST", style: TextStyle(fontSize: 35));
    }
    var result = hexToAscii(showResult.join());
    // if (result.contains("Y")) {
    //   return Text(
    //     "Kardeş cevap geldi",
    //     style: const TextStyle(fontSize: 35),
    //   );
    // } else if (result.contains("01R015CZu")) {
    //   return Text(
    //     "Kardeş bu Tetaş",
    //     style: const TextStyle(fontSize: 35),
    //   );
    // } else if (result.contains("V1-020L9B0BO")) {
    //   return Text(
    //     "Kardeş bu Alberen",
    //     style: const TextStyle(fontSize: 35),
    //   );
    // } else if (result.contains("v1788264501")) {
    //   return Text(
    //     "Kardeş bu Atak",
    //     style: const TextStyle(fontSize: 35),
    //   );
    // } else
    if (result.contains("0F")) {
      setState(() {
        ref = true;
      });
      try {
        taximeterTimeCounterTimer.cancel();
      } catch (e) {}
      taximeterTime = 0;
      timerTaximeterTimerCounterEnabled = false;

      //SocketHelper.shared.sendStatu(true);
      ucret = "Ücret";
      return const Text(
        "SERBEST",
        style: TextStyle(fontSize: 35),
      );
    } else if (result.contains("t") && result.length < 16) {
      if (!timerTaximeterTimerCounterEnabled && ucret == "Ücret") {
        timerTaximeterTimerCounter();
        timerTaximeterTimerCounterEnabled = true;
      }

      var leftSide = result.split("").getRange(3, 7).toList();
      setState(() {
        text = (int.parse(leftSide.join())).toString() +
            "," +
            result.split("").getRange(7, 9).join();
        //SocketHelper.shared.updateprice(text);
      });

      if (ref) {
        try {
          if (currentPosition != null) {
            setState(() {
              travelId = uuid.v4();
              proccedId = uuid.v1();
            });

            _controller.gonder = true;
            DbCrudHelper.shared.insert(
                1,
                travelId,
                proccedId,
                currentPosition!.latitude,
                currentPosition!.longitude,
                text,
                taximeterTime.toString(),
                "${DateTime.now().millisecondsSinceEpoch + 10740000}");
            writeStatu("false");

            finishOneTime = true;

            // SocketHelper.shared.yolculukBasladi(
            //     currentPosition!.latitude,
            //     currentPosition!.longitude,
            //     DateTime.now(),
            //     text) /* .timeout(Duration(milliseconds: 1))*/;
          } else {
            _controller.gonder = true;
            DbCrudHelper.shared.insert(
                1,
                travelId,
                proccedId,
                0.0,
                0.0,
                text,
                taximeterTime.toString(),
                "${DateTime.now().millisecondsSinceEpoch + 10740000}");
            writeStatu("false");
            finishOneTime = true;

            /* .timeout(Duration(milliseconds: 1))*/;
          }
        } catch (e) {
          print(e);
        }
      }
      setState(() {
        ref = false;
      });

      // SocketHelper.shared.sendStatu(false);

      return Text(
        ucret + ": " + text,
        style: const TextStyle(fontSize: 35),
      );
    } else if (result.contains("2D")) {
      ucret = "Ödeme";

      setState(() {
        proccedId = uuid.v1();
      });
      Future.delayed(Duration(seconds: 2), () {
        if (finishOneTime) {
          if (currentPosition != null) {
            DbCrudHelper.shared.insert(
                0,
                travelId,
                proccedId,
                currentPosition!.latitude,
                currentPosition!.longitude,
                text,
                taximeterTime.toString(),
                "${DateTime.now().millisecondsSinceEpoch + 10740000}");
            writeStatu("true");
            _controller.gonder = false;
            finishOneTime = false;
            /*.timeout(Duration(milliseconds: 1))*/;
          } else {
            DbCrudHelper.shared.insert(
                0,
                travelId,
                "proccedId",
                0.0,
                0.0,
                text,
                taximeterTime.toString(),
                "${DateTime.now().millisecondsSinceEpoch + 10740000}");
            writeStatu("true");
            _controller.gonder = false;
            finishOneTime = false;

            /*.timeout(Duration(milliseconds: 1))*/
          }
        }
        encodedList.clear();
        showResult.clear();
      });
      //TODO: Ücret ve Zaman  text + taximetretime

      // encodedList.clear();
      // showResult.clear();

      try {
        taximeterTimeCounterTimer.cancel();
      } catch (e) {}
      //timerTaximeterTimerCounterEnabled = false;
      //SocketHelper.shared.sendStatu(false);
      return Text(
        ucret + ": ",
        style: const TextStyle(fontSize: 35),
      );
    } else {
      // return Text("Debug data: " + result,
      //     style: const TextStyle(fontSize: 20));
      return const Text(
        "SERBEST",
        style: TextStyle(fontSize: 35),
      );
    }

    //return Text("", style: TextStyle(fontSize: 35));
  }

  Position? currentPosition;
  late Timer t;
  goLocation() async {
    t = Timer.periodic(Duration(seconds: 5), (timer) async {
      var uuid = Uuid();

      try {
        Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high)
            .timeout(Duration(seconds: 3));
        currentPosition = position;
        if (position != null) {
          await _signupServiceManager.sendlo(
              position.latitude,
              position.longitude,
              uuid.v4(),
              "${DateTime.now().millisecondsSinceEpoch}",
              _controller.gonder ? travelId : "-");
          // ApiHelper.shared.sendLocation(position.latitude, position.longitude,
          //     uuid.v1(), "${DateTime.now().millisecondsSinceEpoch}");
          print("******");
        } else {
          await _signupServiceManager.sendlo(
              0.0,
              0.0,
              uuid.v4(),
              "${DateTime.now().millisecondsSinceEpoch}",
              _controller.gonder ? travelId : "-");

          // ApiHelper.shared.sendLocation(
          //     0.0, 0.0, uuid.v1(), "${DateTime.now().millisecondsSinceEpoch}");
        }
      } catch (e) {
        // ApiHelper.shared.sendLocation(
        //     0.0, 0.0, uuid.v1(), "${DateTime.now().millisecondsSinceEpoch}");
      }
    });
  }

  bool timerTaximeterTimerCounterEnabled = false;
  late Timer taximeterTimeCounterTimer;
  void timerTaximeterTimerCounter() {
    const sec = Duration(seconds: 1);
    taximeterTimeCounterTimer = Timer.periodic(
      sec,
      (Timer timer) async {
        setState(() {
          taximeterTime++;
        });
      },
    );
  }

  writeStatu(value) async {
    await storage.write(key: "statu", value: value);
  }
}
