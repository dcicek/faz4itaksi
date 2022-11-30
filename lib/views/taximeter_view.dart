import 'dart:async';
import 'dart:typed_data';

import 'package:device/constant/images_path.dart';
import 'package:device/core/get_it.dart';
import 'package:device/helper/db_crud_helper.dart';
import 'package:device/helper/socket_helper.dart';
import 'package:device/helper/toast_helper.dart';
import 'package:device/service/signup_service_manager.dart';
import 'package:device/viewmodel/home_view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:uuid/uuid.dart';

import '../core/controller_all.dart';

class Taximeter extends StatefulWidget {
  const Taximeter({Key? key}) : super(key: key);

  @override
  _TaximeterState createState() => _TaximeterState();
}

class _TaximeterState extends State<Taximeter> {
  GetAllController _controller = Get.put(GetAllController());

  var storage = FlutterSecureStorage();
  final SignupServiceManager _signupServiceManager = SignupServiceManager();

  var travelId;
  var proccedId;
  bool finishOneTime = false;
  var uuid = Uuid();
  var vm = getIt<HomeState>();
  @override
  void initState() {
    super.initState();
    _getDataFromTaxiMeter();
    goLocation();
    _signupServiceManager.sendTaximeter();
    _signupServiceManager.updateStatu();
  }

  @override
  void dispose() {
    try {
      port.close();
    } catch (e) {}
    super.dispose();
  }

  // late Position currentPosition = Position(
  //     longitude: 41.29292,
  //     latitude: 41.29992,
  //     timestamp: DateTime(0),
  //     accuracy: 0,
  //     altitude: 0,
  //     heading: 0,
  //     speed: 0,
  //     speedAccuracy: 0);

  var isTablet = true;
  @override
  Widget build(BuildContext context) {
    isTablet = MediaQuery.of(context).size.width > 900 ? true : false;
    return taximeterSide();
  }

  bool ref = true;
  taximeterSide() {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImagesPath.backgroundColor), fit: BoxFit.fill)),
      height: MediaQuery.of(context).size.height * 0.22,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /*Container(
            height: 60,
            color: Colors.blue,
            child: TextButton(
                onPressed: () {
                  print("vasss");
                  port.write(
                      Uint8List.fromList([0x02, 0x65, 0x00, 0x67, 0x03]));
                },
                child: Text(
                  "basssss",
                )),
          ),*/
          SizedBox(
            width: isTablet ? 75 : 40,
          ),
          SizedBox(
            width: isTablet ? 300 : 250,
            child: taximeterInfo(),
          ),
          SizedBox(
            width: isTablet ? 75 : 40,
          ),
          Text(
            getTaximeterTimeString(),
            style: const TextStyle(fontSize: 30),
          ),

          // Text(
          //   getTaximeterDistanceString(),
          //   style: const TextStyle(fontSize: 25),
          // ),
          // const Text(
          //   "Ekstra: 0.00TL",
          //   style: TextStyle(fontSize: 25),
          // )
        ],
      ),
    );
  }

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
      // SocketHelper.shared.sendStatu(true);
      return const Text("SERBEST", style: TextStyle(fontSize: 35));
    }
    var result = hexToAscii(showResult.join());
    print(result);

    if (result[1].toString() == "v") {
      print("ücret" + result.substring(3, 11).toString());
      print("mesafe" + result.substring(28, 35).toString());
    }
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
    //   print("tetaşş");
    //   return Text(
    //     "Kardeş bu Atak",
    //     style: const TextStyle(fontSize: 35),
    //   );
    // }
    if (result.contains("0F")) {
      setState(() {
        ref = true;
      });
      try {
        taximeterTimeCounterTimer.cancel();
      } catch (e) {}
      taximeterTime = 0;
      timerTaximeterTimerCounterEnabled = false;

      // SocketHelper.shared.sendStatu(true);
      ucret = "Ücret";
      return const Text(
        "SERBEST",
        style: TextStyle(fontSize: 35),
      );
    } else if (result.contains("t") &&
        (int.tryParse(result.substring(3, 9)) == null ? false : true))  {
      print(result);
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
        _controller.statu = false;
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
            setState(() {
              travelId = uuid.v4();
              proccedId = uuid.v1();
            });
            _controller.gonder = true;
            DbCrudHelper.shared.insert(
                1,
                travelId,
                uuid.v4(),
                0.0,
                0.0,
                text,
                taximeterTime.toString(),
                "${DateTime.now().millisecondsSinceEpoch}");
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

       SocketHelper.shared.sendStatu(false);

      return Text(
        ucret + ": " + text,
        style: const TextStyle(fontSize: 35),
      );

    }
    else if (result.contains("2D")) {
      print("2DYE GİRDİİİİİ");
      setState(() {
        proccedId = uuid.v1();
      });

      ucret = "Ödeme";
      _controller.statu = true;
      Future.delayed(Duration(seconds: 2), () {
        print("delay");
        print("ücret: $text");
        if (finishOneTime) {
          if (currentPosition != null) {
            vm.driverIsFree=true;
            print("IF");
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
            vm.driverIsFree=true;
            print("ELSE");
            DbCrudHelper.shared.insert(
                0,
                travelId,
                uuid.v4(),
                0.0,
                0.0,
                text,
                taximeterTime.toString(),
                "${DateTime.now().millisecondsSinceEpoch+10740000}");
            writeStatu("true");

            Future.delayed(const Duration(seconds: 5), () {});
            _controller.gonder = false;
            finishOneTime = false;

            /*.timeout(Duration(milliseconds: 1))*/
          }
        }
      });
      try {
        taximeterTimeCounterTimer.cancel();
      } catch (e) {}
      //timerTaximeterTimerCounterEnabled = false;
      // SocketHelper.shared.sendStatu(false);
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

  goLocation() async {
    Timer.periodic(Duration(seconds: 5), (timer) async {
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
