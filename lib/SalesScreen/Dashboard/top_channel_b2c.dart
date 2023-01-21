import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ftrsb_mobile/model/orderb2c_model.dart';
import 'package:pie_chart/pie_chart.dart';

class TopChannelB2C extends StatefulWidget {
  String? selectedValue;
  TopChannelB2C({Key? key, required this.selectedValue}) : super(key: key);

  @override
  State<TopChannelB2C> createState() => _TopChannelB2CState();
}

class _TopChannelB2CState extends State<TopChannelB2C> {
  int key = 0;
  String total = '';

  late List<OrderB2CModel> _order = [];

  Map<String, double> getChannelData() {
    Map<String, double> catMap = {
      "": 0,
    };
    if (_order == null) {
      catMap.update("", (value) => 0);
    } else {
      for (var item in _order) {
        if (catMap.containsKey(item.channel) == false) {
          catMap[item.channel!] = double.parse(item.amount!);
        } else {
          double a = double.parse(item.amount!);
          catMap.update(item.channel!, (double) => catMap[item.channel]! + a);
        }
      }
    }
    total = catMap.toString();
    return catMap;
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
                DataCell(Text(e.key.toString(),)),
                DataCell(Text(e.value.toString())),
              ]))
          .toList(),
    );

    return a!;
  }

  List<Color> colorList = [
    Color.fromRGBO(0, 0, 0, 0),
    Color.fromARGB(255, 251, 138, 18),
    Color.fromARGB(255, 46, 255, 231),
    Color.fromARGB(255, 186, 87, 216),
    Color.fromARGB(255, 105, 67, 255),
    Color.fromARGB(255, 57, 177, 252),
    Color.fromARGB(255, 241, 77, 197),
    Color.fromARGB(255, 126, 35, 102),
    Color.fromARGB(255, 78, 44, 138),
    Color.fromARGB(255, 33, 200, 247),
    Color.fromARGB(255, 200, 77, 241),
    Color.fromARGB(255, 241, 77, 77),
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
      centerText: 'B2C',
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
  void initState() {
    super.initState();
    setState(() {
      _order = [];
      total = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> expStream;
    if (widget.selectedValue == "Today") {
      expStream = FirebaseFirestore.instance
          .collection('OrderB2C')
          .where('paymentDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day))
          .where('paymentDate',
              isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day + 1))
          .snapshots();
      print(widget.selectedValue);
    } else if (widget.selectedValue == "This Month") {
      expStream = FirebaseFirestore.instance
          .collection('OrderB2C')
          .where('paymentDate',
              isGreaterThanOrEqualTo:
                  DateTime(DateTime.now().year, DateTime.now().month, 1))
          .where('paymentDate',
              isLessThan:
                  DateTime(DateTime.now().year, DateTime.now().month, 31))
          .snapshots();
      print(widget.selectedValue);
    } else if (widget.selectedValue == "This Week"){
      //Last 7 days
      expStream = FirebaseFirestore.instance
          .collection('OrderB2C')
          .where('paymentDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day - 6))
          .where('paymentDate',
              isLessThan: DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day + 1))
          .snapshots();
    } else { //This Year
      expStream = FirebaseFirestore.instance
          .collection('OrderB2C').where('paymentDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                  1, 1))
          .where('paymentDate',
              isLessThanOrEqualTo: DateTime(DateTime.now().year,
                  12, 31)).snapshots();
    }

    void getExpfromSnapshot(snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _order = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          OrderB2CModel exp = OrderB2CModel().fromJson(a.data());
          _order.add(exp);
        }
      } else {
        _order = [];
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
        padding: const EdgeInsets.fromLTRB(30.0,16,30,16),
        child: Column(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Top Selling Channel',
                    style: TextStyle(
                      color: Color(0xff0f4a3c),
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'B2C',
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
                StreamBuilder<Object>(
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
                  width: double.infinity,
                  child: printChannelData(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
