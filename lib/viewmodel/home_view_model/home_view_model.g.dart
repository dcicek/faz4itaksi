// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeState on HomeVM, Store {
  final _$driverModelAtom = Atom(name: 'HomeVM.driverModel');

  @override
  DriverModel get driverModel {
    _$driverModelAtom.reportRead();
    return super.driverModel;
  }

  @override
  set driverModel(DriverModel value) {
    _$driverModelAtom.reportWrite(value, super.driverModel, () {
      super.driverModel = value;
    });
  }

  final _$callingStatusAtom = Atom(name: 'HomeVM.callingStatus');

  @override
  CallingStatus get callingStatus {
    _$callingStatusAtom.reportRead();
    return super.callingStatus;
  }

  @override
  set callingStatus(CallingStatus value) {
    _$callingStatusAtom.reportWrite(value, super.callingStatus, () {
      super.callingStatus = value;
    });
  }

  final _$driverIsFreeAtom = Atom(name: 'HomeVM.driverIsFree');

  @override
  bool get driverIsFree {
    _$driverIsFreeAtom.reportRead();
    return super.driverIsFree;
  }

  @override
  set driverIsFree(bool value) {
    _$driverIsFreeAtom.reportWrite(value, super.driverIsFree, () {
      super.driverIsFree = value;
    });
  }

  final _$changeStatuAsyncAction = AsyncAction('HomeVM.changeStatu');

  @override
  Future changeStatu() {
    return _$changeStatuAsyncAction.run(() => super.changeStatu());
  }

  final _$getDriverDetailAsyncAction = AsyncAction('HomeVM.getDriverDetail');

  @override
  Future getDriverDetail() {
    return _$getDriverDetailAsyncAction.run(() => super.getDriverDetail());
  }

  final _$changeCallingStatusAsyncAction =
      AsyncAction('HomeVM.changeCallingStatus');

  @override
  Future changeCallingStatus(CallingStatus toChangeCallingStatus) {
    return _$changeCallingStatusAsyncAction
        .run(() => super.changeCallingStatus(toChangeCallingStatus));
  }

  final _$HomeVMActionController = ActionController(name: 'HomeVM');

  @override
  dynamic callingStatusRinging() {
    final _$actionInfo = _$HomeVMActionController.startAction(
        name: 'HomeVM.callingStatusRinging');
    try {
      return super.callingStatusRinging();
    } finally {
      _$HomeVMActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
driverModel: ${driverModel},
callingStatus: ${callingStatus},
driverIsFree: ${driverIsFree}
    ''';
  }
}
