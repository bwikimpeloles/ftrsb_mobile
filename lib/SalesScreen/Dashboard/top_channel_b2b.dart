import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ftrsb_mobile/model/orderb2b_model.dart';
import 'package:pie_chart/pie_chart.dart';

class TopChannelB2B extends StatefulWidget {
  String? selectedValue;
  TopChannelB2B({Key? key, required this.selectedValue}) : super(key: key);

  @override
  State<TopChannelB2B> createState() => _TopChannelB2BState();
}

class _TopChannelB2BState extends State<TopChannelB2B> {
  int key = 0;
  String total = '';

  late List<OrderB2BModel> _order = [];

  Map<String, double> getChannelData() {
    Map<String, double> catMap = {
      "": 0,
    };
    if (_order == null) {
      catMap.update("", (value) => 0);
    } else {
      // test[item.category] = test[item.category]! + 1;

      for (var item in _order) {
        if (catMap.containsKey(item.channel) == false) {
          catMap[item.channel!] = double.parse(item.amount!);
        } else {
          double a = double.parse(item.amount!);
          catMap.update(item.channel!, (double) => catMap[item.channel]! + a);
          // test[item.category] = test[item.category]! + 1;
        }
        //print(catMap);
      }
    }
    total = catMap.toString();
    print(total);
    return catMap;
  }

  String getChannel(String c) {
    if (c == 'b2b_retail') {
      return 'B2B Retail';
    } else if (c == 'b2b_hypermarket') {
      return 'B2B Hypermarket';
    } else
      return '';
  }

  DataTable printChannelData() {
    DataTable? a;
    Map<String, double> catMap2 = getChannelData();
    catMap2.remove('');
    a = new DataTable(
      columns: const <DataColumn>[
        DataColumn(
            label: Text(
          'Channel',
          style: TextStyle(
            color: Color(0xff0f4a3c),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )),
        DataColumn(
            label: Text('Total (RM)',
                style: TextStyle(
                  color: Color(0xff0f4a3c),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ))),
      ],
      rows: catMap2.entries
          .map((e) => DataRow(cells: [
                DataCell(Text(getChannel(e.key.toString()))),
                DataCell(Text(e.value.toString())),
              ]))
          .toList(),
    );

    return a!;
  }

  List<Color> colorList = [
    Color.fromRGBO(0, 0, 0, 0),
    Color.fromARGB(255, 57, 177, 252),
    Color.fromARGB(255, 241, 77, 197),
  ];

  Widget pieChartExampleOne() {
    return PieChart(
      key: ValueKey(key),
      dataMap: getChannelData(),
      initialAngleInDegree: 0,
      animationDuration: Duration(milliseconds: 2000),
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      ringStrokeWidth: 32,
      colorList: colorList,
      chartLegendSpacing: 32,
      chartValuesOptions: const ChartValuesOptions(
          showChartValuesOutside: true,
          showChartValuesInPercentage: true,
          showChartValueBackground: true,
          showChartValues: true,
          chartValueStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      centerText: 'B2B',
      legendOptions: const LegendOptions(
          showLegendsInRow: false,
          showLegends: true,
          legendShape: BoxShape.rectangle,
          legendPosition: LegendPosition.right,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
//.where('date', isEqualTo: "2022-12-28 00:00:00.000")
    DateTime date = new DateTime.now();
    DateTime newDateThisMonth = new DateTime(date.year, date.month, 1);
    DateTime newDateThisYear = new DateTime(date.year, 1, 1);

    final Stream<QuerySnapshot> expStream;
    if (widget.selectedValue == "Today") {
      expStream = FirebaseFirestore.instance
          .collection('OrderB2B')
          .where('orderDate',
              isEqualTo: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day))
          .snapshots();
      print(widget.selectedValue);
      //["All","Today","This Month","This Year","30 Days", "365 Days"];
    } else if (widget.selectedValue == "This Month") {
      expStream = FirebaseFirestore.instance
          .collection('OrderB2B')
          .where('orderDate', isGreaterThanOrEqualTo: newDateThisMonth)
          .snapshots();
      print(widget.selectedValue);
    } else {
      //THIS WEEK EDIT NANTI
      expStream = FirebaseFirestore.instance
          .collection('OrderB2B')
          .where('orderDate', isGreaterThanOrEqualTo: newDateThisYear)
          .snapshots();
    }

    void getExpfromSnapshot(snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _order = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          // print(a.data());
          OrderB2BModel exp = OrderB2BModel().fromJson(a.data());
          _order.add(exp);
          //print('_order: ' + _order.toString());
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
          boxShadow: kElevationToShadow[3],
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors
              .white //const Color(0xff72d8bf),//Color.fromARGB(255, 234, 255, 226),
          ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Channel',
                    style: TextStyle(
                      color: Color(0xff0f4a3c),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'B2B',
                    style: TextStyle(
                      color: Color(0xff379982),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: StreamBuilder<Object>(
                    stream: expStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("something went wrong");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      final data = snapshot.requireData;
                      print("Data: $data");
                      getExpfromSnapshot(data);
                      return pieChartExampleOne();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            StreamBuilder<Object>(
              stream: expStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                final data = snapshot.requireData;
                print("Data: $data");
                getExpfromSnapshot(data);
                return Container(
                  child: printChannelData(),
                  width: 300,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
