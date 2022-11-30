import 'dart:convert';

import 'package:flutter/material.dart';

DriverModel driverModelJSON(String str) =>
    DriverModel.fromJson(json.decode(str));

class DriverModel {
  DriverModel(
      {required this.name,
      required this.rating,
      required this.phone,
      required this.surname,
      required this.imageString,
      required this.plate});

  late String name;
  late String surname;
  late String phone;
  late double? rating;
  late String? imageString;
  late String? plate;

  DriverModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    rating = json['rating'] == null ? 0.0 : json['rating'] / 1.0;
    surname = json['surname'];
    phone = json['phone'];
    imageString = json['images'];
    plate = json["plate"];
  }
}
