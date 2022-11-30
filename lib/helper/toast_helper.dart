import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static final shared = ToastHelper();

  void showErrorToast(message) {
    _showToast(Colors.red, message);
  }

  void showSuccessToast(message) {
    _showToast(Colors.green, message);
  }

  _showToast(color, message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
