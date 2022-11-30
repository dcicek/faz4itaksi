//ignore_for_file: override_on_non_overriding_member, file_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, use_full_hex_values_for_flutter_colors, deprecated_member_use, argument_type_not_assignable_to_error_handler, avoid_print, empty_catches, unused_catch_clause, no_duplicate_case_values

import 'package:device/views/drawer/distance_calculate.dart';
import 'package:device/views/drawer/total_earning.dart';
import 'package:device/views/tariff_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/route_manager.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var userName = "welcome".tr;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Color.fromRGBO(255, 241, 0, 1),
              Color.fromRGBO(255, 166, 0, 1),
            ])),
        child: ListView(
          children: [
            Container(
              child: Row(
                children: [
                  Image(
                    height: 75,
                    width: 75,
                    image: AssetImage("images/50.png"),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "hello".tr,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        userName,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 18),
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(
              endIndent: 25,
              indent: 25,
              thickness: 1.5,
              color: Colors.black,
            ),

            GestureDetector(
              onTap: () {
                // Get.to(PaymentMethods());
                Get.to(TotalEarning());
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    // Image(
                    //   image: AssetImage("images/55.png"),
                    //   width: 40,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Toplam Kazanç".tr,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Get.to(DistanceCalculate());
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    // Image(
                    //   image: AssetImage("images/59.png"),
                    //   width: 40,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Toplam Alınan Yol",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            GestureDetector(
              onTap: () {
                Get.to(TariffPage());
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    // Image(
                    //   image: AssetImage("images/59.png"),
                    //   width: 40,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Tarife Yükle",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            GestureDetector(
              onTap: () {
                print("Basıldı");
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    // Image(
                    //   image: AssetImage("images/11.png"),
                    //   width: 40,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "reservation".tr,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.030,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: FlatButton(
            //     onPressed: () {
            //       Get.updateLocale(Get.locale == Locale('tr', 'TR')
            //           ? Locale('en', 'US')
            //           : Locale('tr', 'TR'));
            //     },
            //     child: Text(
            //       "Language",
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     color: Colors.black,
            //   ),
            // ),
            Divider(
              endIndent: 25,
              indent: 25,
              thickness: 1.5,
              color: Colors.black,
            ),
            // GestureDetector(
            //   onTap: () {
            //     // launcher.launch("tel://153");
            //   },
            //   child: Row(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(left: 20, top: 8),
            //         child: Icon(
            //           Icons.phone,
            //           size: 50,
            //         ),
            //       ),
            //       // Column(
            //       //   children: [
            //       //     Padding(
            //       //       padding: const EdgeInsets.only(left: 8, top: 10),
            //       //       child: Text("customer_service".tr),
            //       //     ),
            //       //     Padding(
            //       //       padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            //       //       child: Text(
            //       //         "call".tr,
            //       //         style: TextStyle(
            //       //             fontWeight: FontWeight.w900, fontSize: 22),
            //       //       ),
            //       //     ),
            //       //   ],
            //       // )
            //     ],
            //   ),
            // ),
            // Divider(
            //   endIndent: 25,
            //   indent: 25,
            //   thickness: 1.5,
            //   color: Colors.black,
            // ),
            // Image(
            //   image: AssetImage("images/ibblog.png"),
            //   width: 85,
            //   height: 85,
            // ),
          ],
        ),
      ),
    );
  }
}
