class Tariff {
  String? acilisUcreti;
  String? indibindiUcreti;
  String? yuzmetremesafeUcreti;
  String? birdakikabeklemeUcreti;
  String? birsaatlikbeklemeUcreti;
  String? birkmmesafeUcreti;

  Tariff(
      {this.acilisUcreti, this.indibindiUcreti, this.yuzmetremesafeUcreti, this.birdakikabeklemeUcreti, this.birsaatlikbeklemeUcreti, this.birkmmesafeUcreti});

  factory Tariff.fromJson(Map<String, dynamic> json) {
    return Tariff(
        acilisUcreti: json["tarife"]['acilisU'],
        indibindiUcreti: json["tarife"]['indiBindiU'],
        yuzmetremesafeUcreti: json["tarife"]['yuzMetrelikMesafeU'],
        birdakikabeklemeUcreti: json["tarife"]['birDakikaBeklemeU'],
        birsaatlikbeklemeUcreti: json["tarife"]['birSaatBeklemeU'],
        birkmmesafeUcreti: json["tarife"]['birKmMesafeU']
    );
  }
}
