import 'package:device/model/call_model.dart';
import 'package:device/model/send_db_model.dart';
import 'package:device/model/vast_response.model.dart';
import 'package:get/get.dart';

class GetAllController extends GetxController {
  static final instance = GetAllController();

  var _acceptButton = false.obs;

  get acceptButton => _acceptButton.value;
  set acceptButton(newValue) => _acceptButton.value = newValue;

  void acceptButtonTrue() {
    acceptButton = true;
  }

  void acceptButtonFalse() {
    acceptButton = false;
  }

  // model read
  var callSocketModel = <CallsocketModel>[].obs;

// accept procces
  var _accept = true.obs;
  var _startTravelling = false.obs;
  var _completeTravelling = false.obs;

  get accept => _accept.value;
  set accept(newValue) => _accept.value = newValue;

  get startTravelling => _startTravelling.value;
  set startTravelling(newValue) => _startTravelling.value = newValue;

  get completeTravelling => _completeTravelling.value;
  set completeTravelling(newValue) => _completeTravelling.value = newValue;

  void acceptTrue() {
    accept = true;
  }

  void acceptFalse() {
    accept = false;
  }

  void startTravellingTrue() {
    startTravelling = true;
  }

  void startTravellingFalse() {
    startTravelling = false;
  }

  void completeTravellingTrue() {
    completeTravelling = true;
  }

  void completeTravellingFalse() {
    completeTravelling = false;
  }

  var _vastModel = VastResponseModel(
          status: false,
          statusCode: "404",
          ads: false,
          download: false,
          content: "",
          adsType: "")
      .obs;

  VastResponseModel get vastModel => _vastModel.value;
  set vastModel(newValue) => _vastModel.value = newValue;
  set vastModelDownload(newValue) => _vastModel.value.download = newValue;

  var _plate = "".obs;
  get plate => _plate.value;
  set plate(newValue) => _plate.value = newValue;

  var _statu = false.obs;
  get statu => _statu.value;
  set statu(newValue) => _statu.value = newValue;

  var sendDb = <SendDb>[].obs;

  var _gonder = false.obs;
  get gonder => _gonder.value;
  set gonder(newValue) => _gonder.value = newValue;
}
