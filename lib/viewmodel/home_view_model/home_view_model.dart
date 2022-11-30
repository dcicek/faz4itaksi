import 'package:device/helper/socket_helper.dart';
import 'package:device/model/call_model.dart';
import 'package:device/model/driver_model.dart';
import 'package:device/service/home_service_manager.dart';
import 'package:mobx/mobx.dart';

part 'home_view_model.g.dart';

class HomeState = HomeVM with _$HomeState;

abstract class HomeVM with Store {
  final HomeServiceManager _homeServiceManager = HomeServiceManager();
  //var socketHelper = SocketHelper();

  @observable
  //late CallModel callModel;

  @observable
  DriverModel driverModel = DriverModel(
      name: "",
      phone: "",
      surname: "",
      rating: 5.0,
      imageString: null,
      plate: "34ITAKSI34");
  @observable
  CallingStatus callingStatus = CallingStatus.finished;
  @observable
  bool driverIsFree = false;
  //CallingStatus.canceled
  @action
  changeStatu() async {
    driverIsFree = !driverIsFree;
    //SocketHelper.shared.sendStatu(driverIsFree);
  }

  @action
  getDriverDetail() async {
    var result = await _homeServiceManager.getDriverDetail();
    if (result.status) {
      driverModel = DriverModel.fromJson(result.data);
    }
  }

  @action
  changeCallingStatus(CallingStatus toChangeCallingStatus) async {
    callingStatus = toChangeCallingStatus;
    switch (callingStatus) {
      case CallingStatus.pending:
        //Send
        break;
      case CallingStatus.started:
        //Send
        break;
      case CallingStatus.finished:
        //Send
        break;
      case CallingStatus.canceled:
        //Send
        break;
      default:
    }
    //Send to socket
  }

  @action
  callingStatusRinging() {
    callingStatus = CallingStatus.ringing;
  }
}

enum CallingStatus { pending, started, finished, canceled, ringing }
