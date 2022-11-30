import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DistanceCalculate extends StatefulWidget {
  const DistanceCalculate({Key? key}) : super(key: key);

  @override
  State<DistanceCalculate> createState() => _DistanceCalculateState();
}

class _DistanceCalculateState extends State<DistanceCalculate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back)),
            )),
            Expanded(flex: 1, child: Text("Toplam Kat Edilen Mesafe")),
            Expanded(
              flex: 1,
              child: ListTile(
                leading: Icon(Icons.car_repair),
                title: Text("Toplam Kat Edilen Mesafe"),
                subtitle: Text("1500 km"),
              ),
            ),
            Expanded(child: Text("Ücretli Kat Edilen Mesafe")),
            Expanded(
              flex: 1,
              child: ListTile(
                leading: Icon(Icons.car_repair),
                title: Text("Ücretli Kat Edilen Mesafe"),
                subtitle: Text("700 km"),
              ),
            ),
            Expanded(child: Text("Ücretsiz Kat Edilen Mesafe")),
            Expanded(
              flex: 1,
              child: ListTile(
                leading: Icon(Icons.car_repair),
                title: Text("Ücretsiz Kat Edilen Mesafe"),
                subtitle: Text("800 km"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
