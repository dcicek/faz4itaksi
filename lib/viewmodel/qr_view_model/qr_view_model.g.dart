// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QrLoginState on QrLoginVM, Store {
  final _$deviceIsActiveAtom = Atom(name: 'QrLoginVM.deviceIsActive');

  @override
  bool get deviceIsActive {
    _$deviceIsActiveAtom.reportRead();
    return super.deviceIsActive;
  }

  @override
  set deviceIsActive(bool value) {
    _$deviceIsActiveAtom.reportWrite(value, super.deviceIsActive, () {
      super.deviceIsActive = value;
    });
  }

  final _$setDeviceStatuAsyncAction = AsyncAction('QrLoginVM.setDeviceStatu');

  @override
  Future setDeviceStatu(bool statu) {
    return _$setDeviceStatuAsyncAction.run(() => super.setDeviceStatu(statu));
  }

  @override
  String toString() {
    return '''
deviceIsActive: ${deviceIsActive}
    ''';
  }
}
