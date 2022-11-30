class CallsocketModel {
  CallsocketModel({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final int statuscode;
  late final String message;
  late final Data data;

  CallsocketModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statuscode = json['statuscode'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['statuscode'] = statuscode;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.socketId,
    required this.requestId,
    required this.traveller,
    required this.payment,
    required this.location,
  });

  late final String socketId;
  late final String requestId;
  late final List<Traveller> traveller;
  late final int payment;
  late final Location location;

  Data.fromJson(Map<String, dynamic> json) {
    socketId = json['socketId'];
    requestId = json['requestId'];
    traveller =
        List.from(json['traveller']).map((e) => Traveller.fromJson(e)).toList();
    payment = json['payment'];
    location = Location.fromJson(json['location']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};

    _data['socketId'] = socketId;
    _data['requestId'] = requestId;
    _data['traveller'] = traveller.map((e) => e.toJson()).toList();
    _data['payment'] = payment;
    _data['location'] = location.toJson();
    return _data;
  }
}

class Traveller {
  Traveller({
    required this.id,
    required this.name,
    required this.surname,
    required this.phone,
    required this.mail,
    required this.idNo,
    required this.birthday,
    required this.pet,
    required this.created,
    required this.v,
  });
  late final String id;
  late final String name;
  late final String surname;
  late final String phone;
  late final String mail;
  late final String idNo;
  late final String birthday;
  late final bool pet;
  late final String created;
  late final int v;

  Traveller.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    surname = json['surname'];
    phone = json['phone'];
    mail = json['mail'];
    idNo = json['idNo'];
    birthday = json['birthday'];
    pet = json['pet'];
    created = json['created'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['name'] = name;
    _data['surname'] = surname;
    _data['phone'] = phone;
    _data['mail'] = mail;
    _data['idNo'] = idNo;
    _data['birthday'] = birthday;
    _data['pet'] = pet;
    _data['created'] = created;
    _data['__v'] = v;
    return _data;
  }
}

class Location {
  Location({
    required this.latitude,
    required this.longitude,
  });
  late final double latitude;
  late final double longitude;

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }
}
