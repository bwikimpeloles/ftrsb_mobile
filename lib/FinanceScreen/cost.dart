import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/FinanceScreen/cost/list_cost.dart';
import 'package:pie_chart/pie_chart.dart';

import '../model/cost_model.dart';
import 'sidebar_navigation.dart';

class CostFinance extends StatefulWidget {
  @override
  _CostFinanceState createState() => _CostFinanceState();
}

class _CostFinanceState extends State<CostFinance> {
  int key = 0;

  late List<CostModel> _cost = [];

  Map<String, double> getCategoryData() {
    Map<String, double> catMap = {};
    for (var item in _cost) {
      print(item.category);
      if (catMap.containsKey(item.category) == false) {
        catMap[item.category!] = 1;
      } else {
        catMap.update(item.category!, (int) => catMap[item.category]! + 1);
        // test[item.category] = test[item.category]! + 1;
      }
      print(catMap);
    }
    return catMap;
  }

  List<Color> colorList = [
    Color.fromRGBO(82, 98, 255, 1),
    Color.fromRGBO(46, 198, 255, 1),
    Color.fromRGBO(123, 201, 82, 1),
    Color.fromRGBO(255, 171, 67, 1),
    Color.fromRGBO(252, 91, 57, 1),
    Color.fromRGBO(139, 135, 130, 1),
  ];

  Widget pieChartExampleOne() {
    return PieChart(
      key: ValueKey(key),
      dataMap: getCategoryData(),
      initialAngleInDegree: 0,
      animationDuration: Duration(milliseconds: 2000),
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      ringStrokeWidth: 32,
      colorList: colorList,
      chartLegendSpacing: 32,
      chartValuesOptions: ChartValuesOptions(
          showChartValuesOutside: true,
          showChartValuesInPercentage: true,
          showChartValueBackground: true,
          showChartValues: true,
          chartValueStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      centerText: 'CostModel',
      legendOptions: LegendOptions(
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
    final Stream<QuerySnapshot> expStream =
    FirebaseFirestore.instance.collection('Cost').snapshots();

    void getExpfromSnapshot(snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _cost = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          // print(a.data());
          CostModel exp = CostModel().fromJson(a.data());
          _cost.add(exp);
          // print(exp);
        }
      }
    }


    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text('Cost'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
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
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return ListCostFinance();
            }),
          );
        },
        label: const Text('Manage Cost'),
        icon: const Icon(Icons.pie_chart),
      ),
    );
  }
}

