import 'dart:convert';

BaseResponseModel baseResponseJSON(String str) =>
    BaseResponseModel.fromJson(json.decode(str));

class BaseResponseModel {
  BaseResponseModel(
      {required this.message,
      required this.status,
      required this.data,
      required this.statusCode});

  late final String message;
  late final bool status;
  late final int statusCode;
  late final Map<String, dynamic> data;

  BaseResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statuscode'];
    data = json['data'] ?? {"data": "empty"};
  }
}
