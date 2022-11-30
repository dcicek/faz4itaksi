// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:convert';

import 'package:device/constant/images_path.dart';
import 'package:device/core/controller_all.dart';
import 'package:device/core/get_it.dart';
import 'package:device/helper/preferences_helper.dart';
import 'package:device/helper/socket_helper.dart';
import 'package:device/helper/toast_helper.dart';
import 'package:device/viewmodel/home_view_model/home_view_model.dart';
import 'package:device/viewmodel/qr_view_model/qr_view_model.dart';
import 'package:device/views/ads_view.dart';
import 'package:device/views/call_view.dart';
import 'package:device/views/drawer_view.dart';
import 'package:device/views/landing_view.dart';
import 'package:device/views/taximeter_view.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Color _greenContainer = const Color.fromRGBO(147, 213, 0, 0.85);
Color _redContainer = const Color.fromRGBO(255, 54, 0, 0.85);
String _driverFreeText = "MÜSAİT";
String _driverBusyText = "MEŞGUL";
String passengerName = 'Hello World!';

class _HomeState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  static const platform = MethodChannel("com.example.device/systemapi");
  var storage = FlutterSecureStorage();
  var vm = getIt<HomeState>();
  final SocketHelper _socketHelper = SocketHelper();
  GetAllController _controller = Get.put(GetAllController());
  dynamic plate = "";
  plateString() async {
    var a = await storage.read(key: "plate");
    _controller.plate = a.toString();
  }

  @override
  void initState() {
    super.initState();
    socketConnect();

    getDriverInfo();
    Future.delayed(const Duration(seconds: 10), () {
      SocketHelper.shared.listenDeviceStatu();
    });
  }

  void systemapitest() async {
    String value;
    try {
      value = await platform.invokeMethod("systemapitest");
      ToastHelper.shared.showSuccessToast(value);
    } catch (e) {
      print(e);
    }
  }

  getDriverInfo() {
    vm.getDriverDetail();
  }

  socketConnect() async {
    await _socketHelper.connectSocket();
    //_socketHelper.auth(await SharedPreferencesHelper.shared.getToken());
  }

  @override
  void dispose() {
    super.dispose();
    _socketHelper.socketDisconnect();
  }

  Future<bool> _onWillPop() async {
    //return await true;
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Emin misiniz?'),
            content:
                const Text('Giriş ekranına dönmek istediğinize emin misiniz?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hayır'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  logout();
                },
                child: const Text('Evet'),
              ),
            ],
          ),
        )) ??
        false;
  }

  var isTablet = true;
  @override
  Widget build(BuildContext context) {
    isTablet = MediaQuery.of(context).size.width > 900 ? true : false;
    //itaksi 800
    //tablet 1008
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          key: _key,
          drawer: DrawerWidget(),
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Observer(builder: (_) {
                if (!getIt<QrLoginState>().deviceIsActive) {
                  //logout();
                }
                return const Text("");
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Expanded(
                  //   child: Row(
                  //     children: const [
                  //       Taximeter(),
                  //     ],
                  //   ),
                  // ),

                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.78,
                        child: AdsView(),
                      ),
                      Taximeter(),
                    ],
                  ),
                  infoSide(context),
                ],
              ),
              //CallView(),
              GestureDetector(
                child: Image(
                  image: AssetImage(
                    "images/03.png",
                  ),
                ),
                onTap: () => _key.currentState!.openDrawer(),
              ),

              //qrCode(),
            ],
          ),
        ),
      ),
    );
  }

  bool qrSelected = false;
  AnimatedPositioned qrCode() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      width: qrSelected ? 1050 : 72,
      height: qrSelected ? 650 : 72,
      right: 0,
      top: 0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            qrSelected = !qrSelected;
          });
        },
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(0),
            color: qrSelected ? const Color.fromRGBO(150, 150, 150, 100) : null,
            padding: EdgeInsets.fromLTRB(
                qrSelected ? 300 : 1,
                qrSelected ? 100 : 1,
                qrSelected ? 300 : 1,
                qrSelected ? 100 : 1),
            child: QrImage(
              backgroundColor: Colors.white,
              data: "Hello World!",
              size: qrSelected ? 520 : 0,
              padding: const EdgeInsets.all(5),
            ),
          ),
        ),
      ),
    );
  }

  Widget infoSide(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImagesPath.backgroundColor),
              fit: BoxFit.cover)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     GestureDetector(
          //       onTap: (() => logout()),
          //       child: const Padding(
          //         padding: EdgeInsets.all(10),
          //         child: Icon(Icons.exit_to_app),
          //       ),
          //     )
          //   ],
          // ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.7,
              child: driverInfo()),
          const SizedBox(
            height: 30,
          ),
          Observer(builder: (_) {
            return Expanded(
              child: Obx(
                () => GestureDetector(
                  onTap: () async {
                    //vm.changeStatu();
                    // _socketHelper.sendStatu(!vm.driverIsFree);
                    // _controller.statu = !_controller.statu;
                  },
                  //onDoubleTap: () => systemapitest(),
                  child: Visibility(
                    visible: (vm.callingStatus == CallingStatus.canceled ||
                        vm.callingStatus == CallingStatus.finished),
                    child: Container(
                      //width: 300,
                      height: 60,
                      color:
                          _controller.statu ? _greenContainer : _redContainer,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container(
                          //   child: Image(
                          //     image: AssetImage(
                          //       ImagesPath.itaksiMiniLogo,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            _controller.statu
                                ? _driverFreeText
                                : _driverBusyText,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w900),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  SizedBox getPassengerInfo() {
    return SizedBox(
      width: 200,
      child: Visibility(
        visible: false,
        child: Column(
          children: const [
            SizedBox(
              height: 20,
            ),
            Text(
              'Yolcu Bilgisi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              "", //userInfo.userName as String,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget driverInfo() {
    //return Observer(
      //builder: (_) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (() => logout()),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.exit_to_app),
                    ),
                  ),
                      ],
                    ),
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sürücü Bilgisi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),*/
                    /*SizedBox(
                      height: 30,
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Column(
                                  children: const [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Ad: ",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Plaka: ",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Ruhsat Geçerlilik: ",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Şoför Puanı: ",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      //vm.driverModel.name ?? "SÜRÜCÜ ADI",
                                      "SÜRÜCÜ ADI",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w400),
                                      maxLines: 2,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    /*Obx(
                                          () => */Text(
                                        //_controller.plate ?? "34ITAKSI34",
                                            "34ITAKSI34",
                                        style: TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.w400),
                                      ),
                                    //),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "27/08/2024",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      vm.driverModel.rating.toString().substring(0, 3),
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),


                        getDriverImage(),


                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        );
      //},
    //);
  }

  Position? currentPosition;
  Position? previousPosition;

  late Timer locationTimer;
  void timerSendLocation() {
    const sec = Duration(seconds: 5);
    locationTimer = Timer.periodic(
      sec,
      (Timer timer) async {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        previousPosition = currentPosition;
        currentPosition = position;
        if (previousPosition != currentPosition) {
          // var res = await APIService.deviceLocation(
          //     driver.token,
          //     currentPosition!.latitude.toString(),
          //     currentPosition!.longitude.toString());
        }
      },
    );
  }

  logout() async {
    // var res = await APIService.deviceLogout(token);
    // if (res.status) {
    //   ToastHelper.shared.showSuccessToast(res.message);
    //   goHome();
    // }
    await SocketHelper.shared.logout(await DeviceInformation.deviceIMEINumber);
    SocketHelper.shared.socketDisconnect();
    ToastHelper.shared.showErrorToast("Çıkış yapılıyor");
    try {
      locationTimer.cancel();
    } catch (e) {}
    Get.offAll(LandingView());
  }

  getDriverImage() {
    if (vm.driverModel.imageString != null) {
      // return Image.memory(
      //     Base64Decoder().convert(vm.driverModel.imageString as String),
      //     width: isTablet ? 220 : 180,
      //     height: isTablet ? 220 : 180,
      //     fit: BoxFit.cover);
      return ClipOval(
        child: Image.memory(
            Base64Decoder().convert(vm.driverModel.imageString as String),
            width: isTablet ? 100 : 100,
            height: isTablet ? 100 : 100,
            fit: BoxFit.cover),
      );
    } else {
      return ClipOval(
        child: Image.network("https://tuhimportal.mobilulasim.com/tudes/getsoforimage/18200730450",
            width: isTablet ? 220 : 220,
            height: isTablet ? 220 : 220,
            fit: BoxFit.cover),
      );
    }
  }
}
