import 'package:device/helper/socket_helper.dart';
import 'package:device/model/driver_model.dart';
import 'package:mobx/mobx.dart';

part 'qr_view_model.g.dart';

class QrLoginState = QrLoginVM with _$QrLoginState;

abstract class QrLoginVM with Store {
  @observable
  bool deviceIsActive = false;

  @action
  setDeviceStatu(bool statu) async {
    deviceIsActive = statu;
  }
}
