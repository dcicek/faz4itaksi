import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:device/constant/api_config.dart';
import 'package:device/core/controller_all.dart';
import 'package:device/core/get_it.dart';
import 'package:device/helper/preferences_helper.dart';
import 'package:device/model/call_model.dart';
import 'package:device/model/taximeter_data_history.dart';
import 'package:device/model/vast_response.model.dart';
import 'package:device/viewmodel/home_view_model/home_view_model.dart';
import 'package:device/viewmodel/qr_view_model/qr_view_model.dart';
import 'package:device/views/landing_view.dart';
import 'package:device/views/signup_view.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

GetAllController _controller = Get.put(GetAllController());

class SocketHelper {
  static final shared = SocketHelper();
  var uuid = Uuid();
  late IO.Socket socket;
  late String jwt = "";
  var _travelDataHistories = TravelDataHistories();
  int? _statusCode;
  bool? _status;
  String? _message;
  String? _data;
  final player = AudioCache();

  SocketHelper() {
    socket = IO.io(
        ApiConfig.httpBaseURL,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            //.disableAutoConnect() // disable auto-connection
            .setExtraHeaders(ApiConfig.jsonHeader)
            .build());
    getImei();
  }

  getImei() async {
    _imei = await DeviceInformation.deviceIMEINumber;
  }

  String? _imei;
  Future<void> connectSocket() async {
    jwt = await SharedPreferencesHelper.shared.getToken();
    // socket = IO.io(
    //     ApiConfig.httpBaseURL,
    //     IO.OptionBuilder()
    //         .setTransports(['websocket']) // for Flutter or Dart VM
    //         .disableAutoConnect() // disable auto-connection
    //         .setExtraHeaders(ApiConfig.jsonHeader)
    //         .build());

    socket.connect();

    socket.on('connect', (data) async {
      try {
        timer.cancel();
      } catch (e) {}
      socket.emit('device', {"imei": _imei});

      socket.emit('authenticate', {
        'token': jwt,
      });

      socket.emit("secilireklam");
      try {
        timer.cancel();
      } catch (e) {}

      sendOldData();
      print('Connected');

      socket.on('listenstatu', (data) {
        getIt<HomeState>().driverIsFree = (data['data']['statu']);
      });
      socket.on("response", (data) async {
        _statusCode = data["statusCode"];
        _status = data["status"] as bool;
        _message = data["message"];
        if (_status as bool) {
          await _travelDataHistories.removeData(data["data"]["processId"]);

          // switch (_statusCode) {
          //   case 200:
          //     print("Connected");
          //     break;
          //   case 201:
          //     print("Authenticate");
          //     break;
          //   case 202:
          //     print("Disconnect");

          //     break;
          //   case 203:
          //     print("Location");

          //     break;
          //   case 204:
          //     print("PriceUpdate");
          //     break;
          //   case 205:
          //     print("TaximeterData");

          //     break;
          //   case 401:
          //     print("Authenticate False");
          //     break;
          //   case 403:
          //     print("Location False");
          //     break;
          //   case 404:
          //     print("PriceUpdate False");
          //     break;
          //   default:
          // }
        }
      });

      socket.on("adsense", (data) {
        var vastModel = VastResponseModel(
            status: data["status"],
            statusCode: data["statusCode"].toString(),
            ads: data["data"]["ads"],
            adsType: data["data"]["adsType"],
            content: data["data"]["content"],
            download: data["data"]["download"]);
        print(vastModel.content);
        _controller.vastModel = vastModel;
      });

      //Çağrı Dinleme Kısmı

      socket.on("call", (response) {
        print(response);
        if (response["status"]) {
          player.play("sound.wav");
          _controller.callSocketModel.clear();
          _controller.acceptButtonTrue();
          _controller.callSocketModel.add(CallsocketModel.fromJson(response));
        }
      });
      socket.on("travelling", (response) {
        if (response["status"]) {
          if (response["data"]["travelType"] == 4) {
            _controller.startTravellingFalse();
            _controller.completeTravellingFalse();
            _controller.acceptTrue();
            _controller.acceptButtonFalse();
          } else if (response["data"]["travelType"] == 1) {
            _controller.acceptFalse();
            _controller.startTravellingTrue();
          } else if (response["data"]["travelType"] == 2) {
            _controller.startTravellingFalse();
            _controller.completeTravellingTrue();
          } else if (response["data"]["travelType"] == 3) {
            _controller.completeTravellingFalse();
            _controller.acceptTrue();
            _controller.acceptButtonFalse();
          }
        }
      });
      socket.on("cancelcall", (response) {
        if (response["status"]) {
          if (response["message"] == "Çağrı İptal Edilmiştir.") {
            _controller.acceptButtonFalse();
          }
        }
      });

      socket.on('disconnect', (reason) {
        onDisconnectTimer();
        socket.connect();
        print("Disconnected");
      });
    });
  }

  void connectSocket2() async {
    //id = await SharedPreferencesHelper.shared.getMyID();

    socket.connect();
    socket.on('connect', (data) async {
      print('Bağlandı');
      socket.emit('device', {"imei": _imei});

      socket.on('listendevicestatu', (data) {
        if (data['status']) {
          //socket.off('listendevicestatu');
          ApiConfig.setToken(data['data']['token']);
          SharedPreferencesHelper.shared.setToken(data['data']['token']);
          getIt<QrLoginState>().setDeviceStatu(data['data']['statu']);
          jwt = data['data']['token'];
        }
      });
    });
  }

  void acceptCall() {
    //sendStatu(false);
    socket.emit("driveraccept", {
      "token": jwt,
      "response": 1,
      "processId": uuid.v1(),
      "socketId": _controller.callSocketModel.last.data.socketId,
      "requestId": _controller.callSocketModel.last.data.requestId,
      "location": {
        "latitude": 44.6467,
        "longitude": -79.4167,
      }
    });
  }

  void refuseCall() {
    socket.emit("driveraccept", {
      "token": jwt,
      "processId": uuid.v1(),
      "response": 0,
      "socketId": _controller.callSocketModel.last.data.socketId,
      "requestId": _controller.callSocketModel.last.data.requestId,
      "location": {
        "latitude": 44.6467,
        "longitude": -79.4167,
      }
    });
  }

  void travelProcces(int travelType) {
    socket.emit("travelroom", {
      "token": jwt,
      "processId": uuid.v1(),
      "travelType": travelType,
      "requestId": _controller.callSocketModel.last.data.requestId,
      "description": 1,
      "distance": "10KM",
      "location": {"lat": 44.6467, "long": -79.4167}
    });
  }

  // sendStatu(bool statu) {
  //   socket.emit('driverstatu', {"statu": statu, 'token': jwt});
  // }

  sendImei(String imei) {
    socket.emit('device', {'imei': imei});
  }

  socketDisconnect() {
    try {
      socket.off("listendevicestatu");
      socket.disconnect();
      socket.dispose();
      socket.close();
    } catch (e) {}
  }

  listenDeviceStatu() {
    socket.on('listendevicestatu', (data) {
      if (data['status']) {
        ApiConfig.setToken("");
        getIt<QrLoginState>().setDeviceStatu(data['data']['statu']);
        Get.offAll(LandingView());
      }
    });
  }

  logout(String imei) async {
    await getIt<QrLoginState>().setDeviceStatu(false);
    socket.emit('devicestatu', {
      "imei": imei,
      "statu": false,
    });
  }

  late Timer timer;
  onDisconnectTimer() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (socket.disconnected) {
        connectSocket();
        connectSocket2();
      }
    });
  }

  String lastTravelId = "";

  // sendLocation(double lat, double long, DateTime zaman) async {
  //   // await _travelDataHistories.addData(TravelHistoryModel(
  //   //   token: jwt,
  //   //   processId: uuid.v1(),
  //   //   travelId: lastTravelId,
  //   //   status: 2,
  //   //   zaman: "${zaman}",
  //   //   lat: lat,
  //   //   long: long,
  //   // ));
  //   socket.emit("driverlocation", {
  //     "token": jwt,
  //     "lat": lat,
  //     "long": long,
  //     "zaman": "${zaman}",
  //     "processId": uuid.v1(),
  //     "imei": _imei ?? await DeviceInformation.deviceIMEINumber,
  //     //"travelId": "111111",
  //   });
  // }

  void updateprice(price) {
    socket.emit("updateprice", {
      "token": jwt,
      "price": price,
      "travelId": lastTravelId,
    });
  }

  Future<void> yolculukBasladi(
    lat,
    long,
    DateTime zaman,
    String price,
  ) async {
    //socket.connect();
    lastTravelId = uuid.v1();

    await _travelDataHistories.addData(TravelHistoryModel(
        token: jwt,
        status: 1,
        processId: uuid.v1(),
        travelId: lastTravelId,
        price: price,
        lat: lat,
        long: long,
        zaman: "${zaman}"));

    socket.emit("taximeter", {
      "token": jwt,
      "status": 1,
      "lat": lat, //lat,
      "zaman": "${zaman}", //zaman.toIso8601String(),
      "long": long, //long,
      "price": price,
      "processId": uuid.v1(),
      "travelId": lastTravelId,
    });
  }

  sendStatu(bool statu) {
    socket.emit('driverstatu', {"statu": statu, 'token': jwt});
  }
  Future<void> yolculukBitti(double lat, double long, DateTime zaman,
      String price, int duration) async {
    await _travelDataHistories.addData(TravelHistoryModel(
        token: jwt,
        status: 0,
        processId: uuid.v1(),
        travelId: lastTravelId,
        price: price,
        duration: duration,
        lat: lat,
        long: long,
        zaman: "${zaman}"));

    socket.emit("taximeter", {
      "token": jwt,
      "status": 0,
      "lat": lat,
      "long": long,
      "zaman": "${zaman}",
      "price": price,
      "duration": duration,
      "processId": uuid.v1(),
      "travelId": lastTravelId,
    });
  }

  Future<void> sendOldData() async {
    if (_travelDataHistories.travelDataHistories.isNotEmpty) {
      for (var item in _travelDataHistories.travelDataHistories) {
        if (item.status == 1) {
          socket.emit("taximeter", {
            "status": 1,
            "lat": item.lat,
            "long": item.long,
            "price": item.price,
            "zaman": "${item.zaman}",
            "processId": item.processId,
            "travelId": lastTravelId,
            "token": jwt
          });
        } else if (item.status == 0) {
          socket.emit("taximeter", {
            "status": 0,
            "lat": item.lat,
            "long": item.long,
            "price": item.price,
            "duration": item.duration,
            "zaman": "${item.zaman}",
            "processId": item.processId,
            "travelId": lastTravelId,
            "token": jwt
          });
        } else {
          socket.emit("driverlocation", {
            "lat": item.lat,
            "long": item.long,
            "zaman": "${item.zaman}",
            "processId": item.processId,
            "travelId": lastTravelId,
            "token": jwt,
            "imei": _imei ?? await DeviceInformation.deviceIMEINumber,
          });
        }
      }
    }
  }
}
