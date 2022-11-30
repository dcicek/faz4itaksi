class SendDb{
  int? id;
  String? imei;
  int? status;
  String? travelId;
  String? proccesId;
  double? lat;
  double? long;
  String? price;
  String?  duration;
  String? zaman;

  SendDb({
    this.id,
    this.imei,
    this.status,
    this.travelId,
    this.proccesId,
    this.lat,
    this.long,
    this.price,
    this.duration,
    this.zaman,
  });

  SendDb.FromMap(Map<String,dynamic>map){
    id = map['id'];
    imei = map['imei'];
    status = map['status'];
    travelId = map['travelId'];
    proccesId = map['processId'];
    lat = map['lat'];
    long = map['long'];
    price = map['price'];
    duration = map['duration'];
    zaman = map['zaman'];
  }

  Map<String,dynamic>toMap(){
    return {
      'id':id,
      'imei':imei,
      'status':status,
      'travelId':travelId,
      'proccesId':proccesId,
      'lat':lat,
      'long':long,
      'price':price,
      'duration':duration,
      'zaman':zaman,
    };
  }



}