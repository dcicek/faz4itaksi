// // ignore_for_file: avoid_print, file_names

// import 'package:device/constant/api_config.dart';
// import 'package:device/core/get_it.dart';
// import 'package:device/helper/preferences_helper.dart';
// import 'package:device/viewmodel/home_view_model/home_view_model.dart';
// import 'package:device/viewmodel/qr_view_model/qr_view_model.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:socket_io_client/socket_io_client.dart';

// class SocketHelperQr {
//   static final shared = SocketHelperQr();
//   static late IO.Socket socket;

//   void connectSocket(String imei) async {
//     socket = io(
//         ApiConfig.httpBaseURL,
//         OptionBuilder()
//             .setTransports(['websocket']) // for Flutter or Dart VM
//             //.disableAutoConnect() // disable auto-connection
//             .setExtraHeaders(ApiConfig.shared.jsonHeader)
//             .build());

//     socket.connect();
//     socket.on('connect', (data) async {
//       print('Bağlandı');

//       socket.emit('device', {'imei': imei});

//       socket.on('listendevicestatu', (data) {
//         if (data['status']) {
//           ApiConfig.shared.setToken(data['data']['token']);
//           SharedPreferencesHelper.shared.setToken(data['data']['token']);
//           getIt<QrLoginState>().setDeviceStatu(data['data']['statu']);
//         }
//       });

//       socket
//           .onDisconnect((data) => print("Disconnected socket qr!!!!!!!!!!!!"));
//     });
//   }

//   socketDisconnect() {
//     socket.disconnect();
//     socket.dispose();
//   }
// }
