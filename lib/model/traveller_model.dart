class TravellerModel {
  TravellerModel({
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

  TravellerModel.fromJson(Map<String, dynamic> json) {
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
