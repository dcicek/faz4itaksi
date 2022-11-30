import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

import 'package:crclib/catalog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:crclib/crclib.dart';

import '../constant/images_path.dart';
import '../model/tariff_model.dart';
import '../service/tariff_service_manager.dart';

void main() {
  runApp(const TariffPage());
}

class TariffPage extends StatelessWidget {
  const TariffPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Send Data To Taximeter',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override

  String agentCode= "{\"AgentWrite\":[\"aus1111\"]}\r\n";
  int kontor=0;

  String data = "*#*\r\n";
  String agentText = "{\"AgentPer\":[\"aus1111\"]}";
  String agentNum = "{\"Password\":[num,agentnum]}";
  String stTar = "{\"StTar\":[\"0\",\"aus1111\",\"5C6GT\",1,192,1,2,3,4,5,6,7,8]}";
  String trf = "{\"Trf\":[5,0,0,0,0,0,1,0,1,0,0,0.0,0,0],\"t1\":[]}"; //
  String rate = "{\"Rate\":[0,0,0,5,0.20,0.20,33,0.88],\"R1\":[]}"; //
  String trfCnt = "{\"TrfCnt\":[1]}";
  String extra1 = "{\"Extra\":[0,0,0,2,2,2,2,22]}";
  String extra2 = "{\"Extra\":[0,0,0,3,3,3,3,33]}";
  String extra3 = "{\"Extra\":[0,0,0,1,1,1,1,4]}";

  TextEditingController acilisUcreti= TextEditingController();
  TextEditingController indibindiUcreti= TextEditingController();
  TextEditingController yuzmetreUcreti= TextEditingController();
  TextEditingController birdkUcreti= TextEditingController();
  TextEditingController birsaatUcreti= TextEditingController();
  TextEditingController birkmUcreti= TextEditingController();

  String settings1=("{\"AgentPer\":[\"eng0111\"]}\r\n");
  String settings2=("{\"MD\":[]}\r\n");
  String settings3=("{\"DTS\":[2016,100,200,200,100,2730,2629,2528,3127,2925,2831,2730,2629,3127,3026,2925,2831,2629,2528,3127]}\r\n");
  String settings4=("{\"Set\":[0,\"\",0,0,0,0,0,0,0,0,621,2804,1212]}\r\n");
  String settings5=("{\"In\":[\"0\",\"1111111\",\"TETAS\",\"tetas \",\"\",\"\",\"\",\"\",\"\",\"\",0]}\r\n");
  String settings6=("{\"Kc\":[4500]}\r\n");
  String settings7=("{\"Serial\":[\"1231231\"]}\r\n");
  String settings8=("{\"Plate\":[\"32vbc51\"]}\r\n");



  List tariff = List.filled(10, null, growable: false);

  List settings = ["{\"AgentPer\":[\"eng0111\"]}\r\n","{\"MD\":[]}\r\n","{\"DTS\":[2016,100,200,200,100,2730,2629,2528,3127,2925,2831,2730,2629,3127,3026,2925,2831,2629,2528,3127]}\r\n",
    "{\"Set\":[0,\"\",0,0,0,0,0,0,0,0,621,2804,1212]}\r\n","{\"In\":[\"0\",\"1111111\",\"TETAS\",\"tetas \",\"\",\"\",\"\",\"\",\"\",\"\",0]}\r\n",
    "{\"Kc\":[3100]}\r\n","{\"Serial\":[\"1231231\"]}\r\n","{\"Plate\":[\"32vbc51\"]}\r\n"];


  var a;
  String hizEsikDegeri="";
  double x=0;
  double percent = 0;
  List<UsbDevice> devices = [];
  late UsbPort _port;
  String eskiTarife="";
  String donenDeger="";

  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  List<String> showResult = [];
  List<String> encodedList = [];
  bool cntrl = false;
  late Timer timer;
  int control=1;
  var baudRateOfPort = 9600;
  String event2="";
  int duration = 3;
  //230400
  var baudRateSuccess = false;
  var result;
  bool eskiTarifeKontrol=true;
  TariffServiceManager apiObj = new TariffServiceManager();
  Future<Tariff>? tariffObj;
  late Random rnd;
  int num=0;
  int sonuc=0;
  bool isButtonDisabled=false;
  Color buttonColor=Colors.blueAccent;
  bool firstTap=false;
  String acilisU="";
  int counter=0;


  var agentTextCRC;
  var agentNumCRC;
  var sttarCRC;
  var trfCRC;
  var rateCRC;
  var trfCntCRC;
  var extra1CRC;
  var extra2CRC;
  var extra3CRC;

  sendAgentCode()
  async {
    await _port.write(Uint8List.fromList(data.toString().codeUnits)).then((value) => {
      print("$data gitti"),
    });

    await _port.write(Uint8List.fromList(agentCode.toString().codeUnits)).then((value) => {
      print("$agentCode gitti"),

    });
  }

  dataGonder()
  async {
    await _port.write(Uint8List.fromList(data.toString().codeUnits)).then((value) => {
      print("$data gitti"),
    });
  }

  agentTextSend() {
    //var crcValue = CalcCRC8(agentText);
    //agentText += crcValue.toString();

    _port.write(Uint8List.fromList(agentText.toString().codeUnits)).then((value) => {
      print("Agent Text Send")
    });

  }
  String hexToAscii(String hexString) => List.generate(
    hexString.length ~/ 2,
        (i) => String.fromCharCode(
        int.parse(hexString.substring(i * 2, (i * 2) + 2), radix: 16)),
  ).join();

  sendSettings()
  async {
    await _port.write(Uint8List.fromList(data.toString().codeUnits)).then((value) => {
      print("$data gitti"),
    });
    await _port.write(Uint8List.fromList(settings1.toString().codeUnits)).then((value) => {
    });
    await _port.write(Uint8List.fromList(settings[1].toString().codeUnits)).then((value) => {});


    int i=1;
    double x = 1/(settings.length-2);
    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) async {
        print("EVENT $event2");
        if(event2.contains("?") || event2.contains("%"))
        {
          setState(() {
            percent+=x;
          });

          await _port.write(Uint8List.fromList(settings[i].toString().codeUnits)).then((value) => {});
          i++;
          if(i==7)
          {
            setState(() {
              percent=0;
            });
            timer.cancel();
          }
        }

      },
    );


    /* for(int i=1;i<settings.length;i++)
      {


        if(event2.contains("?") || event2.contains("%"))
          {
            await _port.write(Uint8List.fromList(settings[i].toString().codeUnits)).then((value) => {});
          }
        else{
          await _port.write(Uint8List.fromList(settings[i].toString().codeUnits)).then((value) => {});
          i--;
        }
      }*/
  }



  send()
  async {


    await _port.write(Uint8List.fromList(data.toString().codeUnits)).then((value) => {
      print("$data gitti"),
    });

    await _port.write(Uint8List.fromList(agentCode.toString().codeUnits)).then((value) => {
      print("$agentCode gitti"),
    });
  }

  CalcCRC8(){
    //print(Crc8().convert(utf8.encode(agentText)));
    //print(Crc8().convert(utf8.encode(agentText)));

    //var sendText=List.of(Uint8List.fromList(agentText.codeUnits));

    //sendText.add(int.parse(crcValue.toString()));
    //print(sendText);

    agentTextCRC = Crc8().convert(utf8.encode(agentText));
    agentNumCRC=Crc8().convert(utf8.encode(agentNum));
    sttarCRC = Crc8().convert(utf8.encode(stTar));
    trfCRC = Crc8().convert(utf8.encode(trf));
    rateCRC = Crc8().convert(utf8.encode(rate));
    trfCntCRC = Crc8().convert(utf8.encode(trfCnt));
    extra1CRC = Crc8().convert(utf8.encode(extra1));
    extra2CRC = Crc8().convert(utf8.encode(extra2));
    extra3CRC = Crc8().convert(utf8.encode(extra3));


  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.red[900],
          title: new Text("Uyarı"),
          content: new Text("İşlem tamamlanamadı. Tekrar deneyiniz."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new OutlinedButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _showDialogSuccess() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.lightGreen,
          title: new Text("Bilgi"),
          content: new Text("İşlem tamamlandı."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new OutlinedButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  duzenle(acilisUcreti, indibindiUcreti, yuzmetreUcreti, birdakikaUcreti, birsaatUcreti, birkmUcreti)
  async {
    //TARİFE

    await randomNum();

    //acilisUcreti.text=acilisUcreti;
    acilisU = acilisUcreti;
    String indibindiU = indibindiUcreti;


    tariff[4]="{\"Trf\":[$acilisU,0,0,0,0,0,0,$indibindiU,0,0,0,0.0,0,0],\"t1\":[]}\r\n";
    trf="{\"Trf\":[$acilisU,0,0,0,0,0,0,$indibindiU,0,0,0,0.0,0,0],\"t1\":[]}";



    //RATE

    hizEsikDegeri = (double.parse(birsaatUcreti) / double.parse(birkmUcreti)).toStringAsFixed(1);
    String yuzmetreU=yuzmetreUcreti;
    String birdakikaU=birdakikaUcreti;
    String birsaatU=birsaatUcreti;
    String birkmU=birkmUcreti;

    tariff[5]= "{\"Rate\":[0,0,0,$hizEsikDegeri,$yuzmetreU,$birdakikaU,$birsaatU,$birkmU],\"R1\":[]}\r\n";
    rate="{\"Rate\":[0,0,0,$hizEsikDegeri,$yuzmetreU,$birdakikaU,$birsaatU,$birkmU],\"R1\":[]}";

    CalcCRC8();

    agentText+="${agentTextCRC.toString()}\r\n";
    agentNum+="${agentNumCRC.toString()}\r\n";
    stTar+="${sttarCRC.toString()}\r\n";
    trf+="${trfCRC.toString()}\r\n";
    rate+="${rateCRC.toString()}\r\n";
    trfCnt+="${trfCntCRC.toString()}\r\n";
    extra1+="${extra1CRC.toString()}\r\n";
    extra2+="${extra2CRC.toString()}\r\n";
    extra3+="${sttarCRC.toString()}\r\n";


    tariff[0]=data;
    tariff[1]=agentText;
    tariff[2]=agentNum;
    tariff[3]=stTar;
    tariff[4]=trf;
    tariff[5]=rate;
    tariff[6]=trfCnt;
    tariff[7]=extra1;
    tariff[8]= extra2;
    tariff[9]= extra3;

    sendTariff();

  }

  getJson()
  async {
    tariffObj = apiObj.getTariff();

  }

  randomNum()
  {
    rnd = Random();
    num= rnd.nextInt(19)+1;
    matematikselFonk(num);

  }


  matematikselFonk(int randomNum)
  {

    sonuc= int.parse(((pow(randomNum, 3) + (5 * randomNum)) - 1).toString());
    agentNum="{\"Password\":[$num,$sonuc]}";

    //sendAgentNum();

  }

  sendAgentNum() async {

    int c=0;


    await _port.write(Uint8List.fromList(data.toString().codeUnits)).then((value) => {
      print("$data gitti"),
    });

    await _port.write(Uint8List.fromList("$num\r\n".toString().codeUnits)).then((value) => {
      print("$num gitti"),
    });


    timer = Timer.periodic(
      const Duration(seconds: 3),
          (timer) async {
        print("DÖNEN DEĞER $event2");
        await _port.write(Uint8List.fromList("$agentNum\r\n".toString().codeUnits)).then((value) => {
          print("$agentNum gitti"),
        });
        timer.cancel();
      },
    );



    /*  timer = Timer.periodic(
      const Duration(seconds: 3),
          (timer) async {
        print(event2);



        if(event2.contains("%?%"))// BURASI DEĞİŞECEK
          {

            if(c<1)
              {
                await _port.write(Uint8List.fromList("$agentNum\r\n".toString().codeUnits)).then((value) => {
                  print("$agentNum gitti"),
                });
                c++;
                event2="";
              }
            else{
              timer.cancel();
            }
            print("IF");


        }
        else
        {
          print("ELSE");
        }


      },
    ); */

  }

  yenidenGonder(String data)
  async {

    print("$data yeniden gönderiliyor");
    await _port.write(Uint8List.fromList(data.toString().codeUnits)).then((value) => {
      print("$data yeniden gitti"),
    });

    counter++;
    if(counter==4)
    {
      setState(() {
        isButtonDisabled=false;
        buttonColor=Colors.blueAccent;
        firstTap=true;

        counter=0;
      });
      _showDialog();
      timer.cancel();
    }
  }

  sendTariff({acilisUscreti, indibindiUcreti, yuzmetreUcreti, birdakikaUcreti, birsaatUcreti, birkmUcreti})
  async{


    donenDeger="";
    setState(()
    {
      isButtonDisabled=true;
      buttonColor=Colors.grey;
    });

    print("LİSTE UZUNLUĞU ${tariff.length}");

    //Düzenleme fonksiyonu dışarıdan tarife bilgisi alırken işimize yarıyor.


    //Gönderilen datanın CRC değeri hesaplanıyor.





    await _port.write(Uint8List.fromList(data.toString().codeUnits)).then((value) => {
      print("$data gitti"),
    });
    await _port.write(Uint8List.fromList(agentText.toString().codeUnits)).then((value) => {
      print("$agentText gitti"),
    });
    await _port.write(Uint8List.fromList(agentNum.toString().codeUnits)).then((value) => {
      print("$agentNum gitti"),
    });

    // await _port.write(Uint8List.fromList(stTar.toString().codeUnits)).then((value) => {
    //  print("$stTar gitti"),
    //  });

    int i=3;

    double x = 1/(tariff.length-2);
    timer = Timer.periodic(
      const Duration(seconds: 2),
          (timer) async {
        print("EVENT $event2");

        //Paketin dönüşünde ? ya da % gelmesi başarılı olduğu anlamına geliyor. Loadbar'ı arttır.
        if(event2.contains("?") || event2.contains("%"))
        {
          //Paketler tamamen gönderilince kontör 1 azalacak, loadbar sıfırlanacak, timer duracak.
          if(i>9)
          {

            setState(() {
              kontor--;
              percent=0;
              isButtonDisabled=false;
              buttonColor=Colors.blueAccent;
              firstTap=true;

            });

            _showDialogSuccess();

            timer.cancel();

          }
          else
          {
            await _port.write(Uint8List.fromList(tariff[i].toString().codeUnits)).then((value) => {
              print(tariff[i])
            });
            setState(() {
              //donenDeger+=event2;
              percent+=x;
            });
            //print(percent);

            //Bir sonraki indekse geçip, bir sonraki paket yollanır.

            i++;
          }


        }


        //Eğer sttar paketinden sonra + gelirse sorun var demektir. Timer'ı durdur, tarife gönderme işlemini baştan başlat.
        else if(event2.contains("+"))
        {
          yenidenGonder(agentNum);

        }
        else if(event2.contains("S") || event2.contains("T"))
        {
          yenidenGonder(agentText);
        }
        else
        {
          yenidenGonder(data);
        }


      },
    );



  }

  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  CalcPassword()
  {
    Random().nextInt(100);
  }





  karsilastir()
  {
    //Paketler gittikten sonra gönderilen açılış ücretiyle, taksimetreden okunan açılış ücreti karşılaştırılır.
    //Eğer eşitse paketler sorunsuzca gönderilmiş demektir. Farklıysa kullanıcıya alertdialog çıkartılır.



    print("taksimetredeki açılış ücreti $a sunucudaki açılış ücreti $acilisU.00");
    if(a != ("$acilisU.00"))
    {
      setState(() {
        kontor++;
      });

      _showDialog();
    }

  }

  Future<void> _getDataFromTaxiMeter() async {
    print("GİRDİ");
    if (devices.isEmpty) {
      //await Future.delayed(Duration(seconds: 10), _getDataFromTaxiMeter);
      return;
    }
    _port = (await devices[0].create())!;

    bool openResult = await _port.open();
    if (!openResult) {
      return;
    }

    await _port.setDTR(true);
    await _port.setRTS(true);

    _port.setPortParameters(baudRateOfPort, UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);


    _port.inputStream!.listen((Uint8List event) {
      var result2 = hexToAscii(showResult.join());
      baudRateSuccess = true;
      event2 = String.fromCharCodes(event);
      setState(() {
        donenDeger+=event2;
      });

      List<String> encodedList1 = HEX.encode(event).split("");
      for (var i = 0; i < encodedList1.length; i += 2) {
        encodedList.add(encodedList1[i] + encodedList1[i + 1]);
      }

      if ((encodedList.contains('02') && encodedList.contains('03') && (encodedList.indexOf('02') + 3 < encodedList.indexOf('03')))) {
        setState(() {
          showResult = encodedList.getRange(encodedList.indexOf('02'), encodedList.indexOf('03') + 1).toList();});
        encodedList.removeRange(encodedList.indexOf('02'), encodedList.indexOf('03') + 1);
      }
      // print("GELEN DEĞER: $event2");
      // print(event2.contains("t"));
      // print(result2.length);
      // print(result2);
      // if(event2.contains("t") && event2.length==11 && eskiTarifeKontrol==true)
      if(event2.contains("t") && event2.length==11)
      {

        print("++++++++++++++");
        //eskiTarifeKontrol=false;
        //eskiTarife = event2.substring(3,7);
        try{
          var s = event2.split("").getRange(3,7).toList();
          //print(result2);
          a =  (int.parse(s.join())).toString() +
              "." +
              event2.split("").getRange(7, 9).join();
          //print(a);
        }catch(e){
          //print(e);

        }


        karsilastir();

      }
    });

    _transaction = Transaction.stringTerminated(
        _port.inputStream as Stream<Uint8List>, Uint8List.fromList([13, 10]));

    _subscription = _transaction?.stream.listen((String line) {
      print("LINE $line");
    });
    //0x02 0x6B 0x00 0x69 0x03
    //get device type
    //_port.write(Uint8List.fromList([0x02, 0x6B, 0x00, 0x69, 0x03]));

    /* if(cntrl==false)
      {
        Timer.periodic(
          const Duration(seconds: 2),
              (timer) {
                result = hexToAscii(showResult.join());

                print("GELEN DEĞER :$result");
          },
        );

        cntrl=true;
      }*/

  }

  _getPorts() async {
    devices = await UsbSerial.listDevices();
    print(devices);
    await _getDataFromTaxiMeter();
  }

  @override
  void initState() {

    super.initState();
    /* var key = utf8.encode('p@ssw0rd');
    var bytes = utf8.encode("foobar");

    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    print("HMAC digest as bytes: ${digest.bytes}");
    print("HMAC digest as hex string: $digest"); */


    //print(getRandomString(5));
    getJson();
    kontor=10;

    _getPorts();

    UsbSerial.usbEventStream!.listen((UsbEvent event) {
      print(event.device?.deviceId);

      print("Geliyor");
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(

        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImagesPath.backgroundColor),
                    fit: BoxFit.cover
                )
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: 0.1,
                      image: AssetImage(ImagesPath.taxi2Logo),

                  )

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  FutureBuilder<Tariff>(
                      future: tariffObj,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            child: Column(

                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                      child: SizedBox(
                                        height: 30,
                                        width: 400,
                                        child: Text(donenDeger),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      height: 50,
                                      child: AbsorbPointer(
                                        absorbing: isButtonDisabled,
                                        child: OutlinedButton(
                                          onPressed: () async {

                                            data = "*#*\r\n";
                                            agentText = "{\"AgentPer\":[\"aus1111\"]}";
                                            agentNum = "{\"Password\":[num,agentnum]}";
                                            stTar = "{\"StTar\":[\"0\",\"aus1111\",\"5C6GT\",1,192,1,2,3,4,5,6,7,8]}";
                                            trf = "{\"Trf\":[5,0,0,0,0,0,1,0,1,0,0,0.0,0,0],\"t1\":[]}"; //
                                            rate = "{\"Rate\":[0,0,0,5,0.20,0.20,33,0.88],\"R1\":[]}"; //
                                            trfCnt = "{\"TrfCnt\":[1]}";
                                            extra1 = "{\"Extra\":[0,0,0,2,2,2,2,22]}";
                                            extra2 = "{\"Extra\":[0,0,0,3,3,3,3,33]}";
                                            extra3 = "{\"Extra\":[0,0,0,1,1,1,1,4]}";


                                              duzenle(snapshot.data?.acilisUcreti, snapshot.data?.indibindiUcreti, snapshot.data?.yuzmetremesafeUcreti, snapshot.data?.birdakikabeklemeUcreti, snapshot.data?.birsaatlikbeklemeUcreti, snapshot.data?.birkmmesafeUcreti);




                                          },
                                          child: Text(
                                            "Tarife Yükle",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(buttonColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 100,),

                                  ],
                                ),

                              ],
                            ),
                          );
                        }
                        else if(snapshot.hasError)
                        {
                          return Text("${snapshot.error}");
                        }
                        return Container(child: Center(child: Text("Bilgi geliyor...", style: TextStyle(fontSize: 24),),),);
                      }


                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        width: MediaQuery.of(context).size.width*0.95,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(55)),
                          child: LinearProgressIndicator(

                            backgroundColor: Colors.grey,
                            color: Colors.green,
                            minHeight: 5,
                            value: percent,

                          ),
                        ),
                      )

                    ],
                  ),


                ],
              ),
            ),
          ),
        ));
  }


}
