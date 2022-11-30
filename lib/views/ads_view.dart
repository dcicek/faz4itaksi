import 'dart:async';
import 'dart:io' as io;

import 'package:device/constant/images_path.dart';
import 'package:device/core/controller_all.dart';
import 'package:device/helper/toast_helper.dart';
import 'package:device/model/vast_response.model.dart';
import 'package:device/service/vast_service_manager.dart';
import 'package:device/views/video_player_view.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:native_video_view/native_video_view.dart';

class AdsView extends StatefulWidget {
  const AdsView({Key? key}) : super(key: key);

  @override
  _AdsViewState createState() => _AdsViewState();
}

class _AdsViewState extends State<AdsView> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    //maps();
    // getVast();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FittedBox(
        fit: BoxFit.fill,
        child: Container(
          width: MediaQuery.of(context).size.width*0.5,
          height: MediaQuery.of(context).size.height*0.78,
          child: NativeVideoView(
            showMediaController: true,
            onCreated: (controller) {
              controller.setVideoSource(
                'images/topluulasimvideo.mp4',
                sourceType: VideoSourceType.asset,
              );
            },
            onPrepared: (controller, info) {
              controller.play();
            },
            onError: (controller, what, extra, message) {
              print('Player Error ($what | $extra | $message)');
            },
            onCompletion: (controller) {
              print('Video completed');
              controller.setVideoSource(
                'images/topluulasimvideo.mp4',
                sourceType: VideoSourceType.asset,
              );
            },
            onProgress: (progress, duration) {
              print('$progress | $duration');
            },
          ),
        ),
      ),
    );
  }

  Widget taxiPic()
  {
    return Container(

      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image:AssetImage(
            ImagesPath.denizTaksi
          ),
        )
      ),
    );
  }

  var _downloaded = false;
  var lastVast = VastResponseModel(
      status: false, statusCode: "404", ads: false, download: false);

  GetAllController _getAllController = Get.put(GetAllController());
  //late VideoPlayerView videoPlayerView;
  bool refresh = true;
  Widget adSide() {
    if (lastVast != _getAllController.vastModel) {
      _downloaded = false;
      lastVast = _getAllController.vastModel;
    }
    if (_getAllController.vastModel.ads) {
      if (_getAllController.vastModel.adsType == "video") {
        if (_getAllController.vastModel.download && _downloaded == false) {
          getFile(_getAllController.vastModel.content);
          return const Center(
              child: Text(
            "Video indiriliyor...",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ));
        }
        if (refresh) {
          Future.delayed(Duration(milliseconds: 100), () {
            if (_downloaded) {
              setState(() {
                refresh = false;
              });
            }
          });
          return const Center(
              child: Text(
            "Video başlatılıyor...",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ));
        } else {
          return VideoPlayerView(filePath);
        }
      } else if ((_getAllController.vastModel.adsType == "image" ||
          _getAllController.vastModel.adsType == "gif")) {
        if (_getAllController.vastModel.download && !_downloaded) {
          getFile(_getAllController.vastModel.content);
          return const Center(
              child: Text(
            "Resim indiriliyor...",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ));
        }

        if (refresh) {
          Future.delayed(Duration(milliseconds: 100), () {
            if (_downloaded) {
              setState(() {
                refresh = false;
              });
            }
          });
          return const Center(
              child: Text(
            "Resim başlatılıyor...",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ));
        } else {
          return Image.file(
            io.File(filePath),
            fit: BoxFit.cover,
          );
        }
      } else if (_getAllController.vastModel.adsType == "url") {
        if (refresh) {
          Future.delayed(
              const Duration(milliseconds: 100),
              () => {
                    setState(() {
                      refresh = false;
                    })
                  });
          return const Center(
              child: Text(
            "Url yükleniyor...",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ));
        } else {
          return WebView(
            initialUrl: _getAllController.vastModel.content,
            allowsInlineMediaPlayback: true,
            javascriptMode: JavascriptMode.unrestricted,
            zoomEnabled: false,
          );
        }
      } else {
        return showMap();
      }
    } else {
      return showMap();
    }
  }

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;
  Position? currentPosition;
  Position? previousPosition;
  var geoLocator = Geolocator();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  List<Polyline> myPolyline = [];

  final _cameraPosition = CameraPosition(
    target: LatLng(41.0082, 28.9784),
    zoom: 13,
  );

  Widget showMap() {
     return GoogleMap(
       zoomGesturesEnabled: true,
       myLocationEnabled: true,
       myLocationButtonEnabled: true,
       zoomControlsEnabled: true,
       initialCameraPosition: _cameraPosition,
       onMapCreated: (GoogleMapController controller) {
         // _controllerGoogleMap.complete(controller);
         newGoogleMapController = controller;
         locatePosition();
         //timerSendLocation();
         //setPolylines();
       },
     );
  }

  Widget maps() {
    return GoogleMap(
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      initialCameraPosition: _cameraPosition,
      onMapCreated: (GoogleMapController controller) {
        // _controllerGoogleMap.complete(controller);
        newGoogleMapController = controller;
        locatePosition();
        //timerSendLocation();
        //setPolylines();
      },
    );
  }

  Future<void> locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    previousPosition = currentPosition;
    currentPosition = position;
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLatPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    /* String address =
        await AssistantMethods.searchCoordianteAddresses(position, context);*/
  }

  String filePath = "";
  bool dataLoaded = false;
  Future getFile(url) async {
    _getAllController.vastModelDownload = false;
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/files";
    var filePathAndName = documentDirectory.path + "/" + url.split("/").last;
    //dataLoaded = false;
    if (await io.File(filePathAndName).exists() == false) {
      ToastHelper.shared.showSuccessToast("Yeni reklam bulundu. (İndiriliyor)");
      var response = await get(Uri.parse(url)); // <--2
      await io.Directory(firstPath).create(recursive: true); // <-- 1

      io.File file2 = io.File(filePathAndName);
      file2.writeAsBytesSync(response.bodyBytes); // <-- 3
      ToastHelper.shared
          .showSuccessToast("Yeni reklam bulundu. (İndirildi ve Oynatılıyor)");
    } else {
      ToastHelper.shared.showSuccessToast("Yeni reklam bulundu. (Oynatılıyor)");
    }
    filePath = filePathAndName;
    setState(() {
      _downloaded = true;
      // refresh = true;
    });

    //post downloaded info
  }
}
