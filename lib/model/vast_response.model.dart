import 'dart:convert';

VastResponseModel vastResponseModel(String str) =>
    VastResponseModel.fromJson(json.decode(str));

class VastResponseModel {
  VastResponseModel(
      {required this.status,
      required this.statusCode,
      required this.ads,
      this.adsType,
      this.content,
      required this.download});

  late final String statusCode;
  late final bool status;
  late final bool ads;
  late bool download;
  late final String? adsType;
  late final String? content;

  VastResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'] as String;
    ads = json['ads'];
    download = json['download'];
    adsType = json['adstype'];
    content = json['content'];
  }
}
