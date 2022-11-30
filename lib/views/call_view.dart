// ignore_for_file: override_on_non_overriding_member, file_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, use_full_hex_values_for_flutter_colors, deprecated_member_use, argument_type_not_assignable_to_error_handler, avoid_print, empty_catches, unused_catch_clause, no_duplicate_case_values

import 'package:device/core/controller_all.dart';
import 'package:device/core/get_it.dart';
import 'package:device/helper/socket_helper.dart';
import 'package:device/viewmodel/home_view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';

class CallView extends StatefulWidget {
  CallView({Key? key}) : super(key: key);

  @override
  _CallViewState createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  GetAllController _controller = Get.put(GetAllController());

  var vm = getIt<HomeState>();
  bool accept = true;

  bool startTravelling = false;
  bool completeTravelling = false;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Obx(
        () => Visibility(
          visible: _controller.acceptButton,
          child: Positioned(
            bottom: 75,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.brown, borderRadius: BorderRadius.circular(50)),
              width: Get.width * 0.66,
              height: 80,
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                'https://t4.ftcdn.net/jpg/02/45/56/35/360_F_245563558_XH9Pe5LJI2kr7VQuzQKAjAbz9PAyejG1.jpg',
                                width: 75,
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (_controller.accept) ...[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Araç Talebi",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              )
                            ] else ...[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _controller.callSocketModel.last.data
                                      .traveller.last.name,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              )
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (_controller.accept) ...[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                              onPressed: () {
                                SocketHelper.shared.acceptCall();
                                //_controller.acceptButtonFalse();
                                //_controller.acceptFalse();
                                //_controller.startTravellingTrue();
                                //_controller.completeTravellingFalse();
                              },
                              child: Text(
                                "KABUL ET",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color(0xff8FCE00)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                              onPressed: () {
                                SocketHelper.shared.refuseCall();
                              },
                              child: Text(
                                "İPTAL ET",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color(0xffD30000)),
                              ),
                            ),
                          )
                        ],
                      )
                    ] else if (_controller.startTravelling) ...[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: OutlinedButton(
                              onPressed: () {
                                SocketHelper.shared.travelProcces(2);
                                // _controller.acceptFalse();
                                // _controller.completeTravellingTrue();
                                // _controller.startTravellingFalse();
                                // setState(() {
                                //   startTravelling = false;
                                //   accept = false;
                                //   completeTravelling = true;
                                // });
                              },
                              child: Text(
                                "YOLCULUĞU BAŞLAT",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color(0xff8FCE00)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: OutlinedButton(
                              onPressed: () {
                                SocketHelper.shared.travelProcces(4);
                                // _controller.startTravellingFalse();
                                // _controller.acceptTrue();
                                // _controller.completeTravellingFalse();
                                // _controller.acceptButtonFalse();
                              },
                              child: Text(
                                "İPTAL",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color(0xffD30000)),
                              ),

                            ),
                          ),
                        ],
                      ),
                    ] else if (_controller.completeTravelling) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            SocketHelper.shared.travelProcces(3);
                            // _controller.acceptTrue();
                            // _controller.completeTravellingFalse();
                            // _controller.startTravellingFalse();
                            // _controller.acceptButtonFalse();
                            // setState(() {
                            //   accept = true;
                            //   completeTravelling = false;
                            //   startTravelling = false;
                            // });
                          },
                          child: Text(
                            "YOLUCUĞU TAMAMLA",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.black),
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.fromLTRB(10, 50, 150, 10),
            //   padding: EdgeInsets.all(15),
            //   decoration: BoxDecoration(
            //       color: (vm.callingStatus == CallingStatus.started ||
            //               vm.callingStatus == CallingStatus.pending)
            //           ? Colors.green
            //           : Colors.amber[600],
            //       borderRadius: BorderRadius.circular(75),
            //       boxShadow: [
            //         BoxShadow(
            //             color: Colors.black.withOpacity(0.2),
            //             blurRadius: 10,
            //             offset: Offset.zero)
            //       ]),
            //   child: Column(
            //     children: [
            //       Container(
            //         color: (vm.callingStatus == CallingStatus.pending ||
            //                 vm.callingStatus == CallingStatus.started)
            //             ? Colors.green
            //             : Colors.amber[600],
            //         child: Row(
            //           children: [
            //             Stack(
            //               clipBehavior: Clip.none,
            //               children: [
            //                 ClipOval(
            //                   child: Image.network(
            //                     'https://t4.ftcdn.net/jpg/02/45/56/35/360_F_245563558_XH9Pe5LJI2kr7VQuzQKAjAbz9PAyejG1.jpg',
            //                     width: 75,
            //                     height: 75,
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               width: 20,
            //             ),
            //             Container(
            //               width: 200,
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     'Yolcu Bilgisi',
            //                     style: TextStyle(
            //                         color: Colors.grey[800],
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 20),
            //                   ),
            //                   SizedBox(
            //                     height: 5,
            //                   ),
            //                   Text(
            //                     "", //userInfo.userName as String,
            //                     style: TextStyle(
            //                         color: Colors.grey[700],
            //                         fontWeight: FontWeight.w400,
            //                         fontSize: 22),
            //                   )
            //                 ],
            //               ),
            //             ),
            //             Row(
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   if (vm.callingStatus == CallingStatus.ringing) ...[
            //                     FlatButton(
            //                       onPressed: () async {
            //                         vm.changeCallingStatus(CallingStatus.pending);
            //                       },
            //                       minWidth: 150,
            //                       height: 70,
            //                       color: Colors.green,
            //                       child: Text(
            //                         "KABUL ET",
            //                         textAlign: TextAlign.right,
            //                         style: TextStyle(
            //                             color: Colors.white,
            //                             fontSize: 18,
            //                             fontWeight: FontWeight.w900),
            //                       ),
            //                     ),
            //                   ] else if (vm.callingStatus ==
            //                       CallingStatus.pending) ...[
            //                     FlatButton(
            //                       onPressed: () async {
            //                         vm.changeCallingStatus(CallingStatus.started);
            //                       },
            //                       minWidth: 150,
            //                       height: 70,
            //                       color: Colors.amber,
            //                       child: Text(
            //                         "YOLCUYU ALDIM",
            //                         textAlign: TextAlign.right,
            //                         style: TextStyle(
            //                             color: Colors.white,
            //                             fontSize: 12,
            //                             fontWeight: FontWeight.w900),
            //                       ),
            //                     ),
            //                   ] else ...[
            //                     FlatButton(
            //                       onPressed: () async {
            //                         vm.changeCallingStatus(
            //                             CallingStatus.finished);
            //                       },
            //                       minWidth: 150,
            //                       height: 70,
            //                       color: Colors.amber,
            //                       child: Text(
            //                         "YOLCULUĞU TAMAMLA",
            //                         textAlign: TextAlign.right,
            //                         style: TextStyle(
            //                             color: Colors.white,
            //                             fontSize: 12,
            //                             fontWeight: FontWeight.w900),
            //                       ),
            //                     ),
            //                   ],
            //                   SizedBox(
            //                     width: 25,
            //                   ),
            //                   FlatButton(
            //                     color: Colors.red,
            //                     minWidth: 150,
            //                     height: 70,
            //                     onPressed: () async {
            //                       vm.changeCallingStatus(CallingStatus.canceled);
            //                     },
            //                     child: Text(
            //                       "İPTAL ET",
            //                       textAlign: TextAlign.right,
            //                       style: TextStyle(
            //                           color: Colors.white,
            //                           fontSize: 18,
            //                           fontWeight: FontWeight.w900),
            //                     ),
            //                   ),
            //                 ]),
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ),
        ),
      );
    });
  }
}
