import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TotalEarning extends StatefulWidget {
  const TotalEarning({Key? key}) : super(key: key);

  @override
  State<TotalEarning> createState() => _TotalEarningState();
}

class _TotalEarningState extends State<TotalEarning> {
  List example = [
    {"money": "1500₺", "time": "14.05.2021"},
    {"money": "1230₺", "time": "13.05.2021"},
    {"money": "1425₺", "time": "12.05.2021"},
    {"money": "1258₺", "time": "11.05.2021"},
    {"money": "1302₺", "time": "10.05.2021"},
  ];
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
            Expanded(flex: 1, child: Text("Toplam Kazanç")),
            Expanded(
              flex: 1,
              child: ListTile(
                leading: Icon(Icons.money),
                title: Text("Toplam Kazanılan Miktar"),
                subtitle: Text("6715₺"),
              ),
            ),
            Expanded(child: Text("Günlük Kazanç")),
            Expanded(
                flex: 5,
                child: ListView.builder(
                    itemCount: example.length,
                    itemBuilder: (context, index) {
                      var item = example[index];
                      return ListTile(
                        leading: Icon(Icons.attach_money_sharp),
                        title: Text(item["time"]),
                        subtitle: Text(item["money"]),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
