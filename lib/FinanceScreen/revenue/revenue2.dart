import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/model/revenue_model2.dart';
import 'package:pie_chart/pie_chart.dart';
import '../sidebar_navigation.dart';
import 'bottom_navigation.dart';

class Revenue2Finance extends StatefulWidget {
  @override
  _Revenue2FinanceState createState() => _Revenue2FinanceState();
}

class _Revenue2FinanceState extends State<Revenue2Finance> {
  int key = 0;
  List<String> period = ["All","Today","This Month","This Year","30 Days", "365 Days"];
  String? selectedValue="All";
  String total ='';

  late List<RevenueModel2> _Revenue = [];

  Map<String, double> getCategoryData() {
    Map<String, double> catMap = {"":0,};
    if (_Revenue==null) {

      catMap.update("", (value) => 0);
    } else {
      // test[item.category] = test[item.category]! + 1;

      for (var item in _Revenue) {
        if (catMap.containsKey(item.channel) == false) {
          catMap[item.channel!] = double.parse(item.amount!);
        } else {
          double a =double.parse(item.amount!);
          catMap.update(item.channel!, (double) => catMap[item.channel]!+ a);
          // test[item.category] = test[item.category]! + 1;
        }
        //print(catMap);
      }}
    total=catMap.toString();
    print(total);
    return catMap;
  }

  DataTable printRevenueData() {
    DataTable? a;
    Map<String, double> catMap2 = getCategoryData();
    catMap2.remove('');
    a= new DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Total (RM)')),
      ],
      rows: catMap2.entries
          .map((e) => DataRow(cells: [
        DataCell(Text(e.key.toString())),
        DataCell(Text(e.value.toString())),
      ]))
          .toList(),
    );


    return a!;
  }

  List<Color> colorList = [
    Color.fromRGBO(0, 0, 0, 0),
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
      centerText: 'Revenue',
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
    //.where('date', isEqualTo: "2022-12-28 00:00:00.000")
    DateTime date = new DateTime.now();
    DateTime newDateThisMonth = new DateTime(date.year, date.month, 1);
    DateTime newDateThisYear = new DateTime(date.year, 1, 1);
    DateTime newDate30 = new DateTime(date.year, date.month - 1, date.day);
    DateTime newDate365 = new DateTime(date.year-1, date.month, date.day);
    final Stream<QuerySnapshot> expStream;
    if (selectedValue == "Today") {
      expStream =
          FirebaseFirestore.instance.collection('OrderB2B').where(
              'orderDate',
              isEqualTo: DateTime(DateTime
                  .now()
                  .year, DateTime
                  .now()
                  .month, DateTime
                  .now()
                  .day)
          ).snapshots();
      print(selectedValue);
      //["All","Today","This Month","This Year","30 Days", "365 Days"];
    } else if (selectedValue == "This Month") {
      expStream =
          FirebaseFirestore.instance.collection('OrderB2B').where(
              'orderDate',
              isGreaterThanOrEqualTo: newDateThisMonth
          ).snapshots();
      print(selectedValue);

    }else if (selectedValue == "This Year") {
      expStream =
          FirebaseFirestore.instance.collection('OrderB2B').where(
              'orderDate',
              isGreaterThanOrEqualTo: newDateThisYear
          ).snapshots();
      print(selectedValue);

    }
    else if (selectedValue == "30 Days") {
      expStream =
          FirebaseFirestore.instance.collection('OrderB2B').where(
              'orderDate',
              isGreaterThanOrEqualTo: newDate30
          ).snapshots();
      print(selectedValue);
    } else if (selectedValue == "365 Days") {
      expStream =
          FirebaseFirestore.instance.collection('OrderB2B').where(
              'orderDate',
              isGreaterThanOrEqualTo: newDate365
          ).snapshots();
      print(selectedValue);

    }
    else{
      expStream =
          FirebaseFirestore.instance.collection('OrderB2B').snapshots();
      print(selectedValue);
    }

    void getExpfromSnapshot(snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _Revenue = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          // print(a.data());
          RevenueModel2 exp = RevenueModel2().fromJson(a.data());
          _Revenue.add(exp);
          // print(exp);
        }
      }
    }


    return Scaffold(
      bottomNavigationBar: FinanceCurvedNavBar(indexnum: 1,),
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text('Revenue'),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text("Period: ", style: TextStyle(fontWeight: FontWeight.bold, height: 0, fontSize: 20),),
                DropdownButton(
                  value: selectedValue,
                  items: period.map((item) => DropdownMenuItem<String>(value: item,child: Text(item))).toList(),
                  onChanged: (String? newValue){
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },

                ),
              ],
            ),
            Column(
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
            SizedBox(height: 30,),
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
                return Container(child: printRevenueData(), width: 300,);
              },
            ),
          ],
        ),
      ),
    );
  }
}

