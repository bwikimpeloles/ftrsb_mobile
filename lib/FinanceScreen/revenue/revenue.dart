import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/FinanceScreen/revenue/bottom_navigation.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../model/revenue_model.dart';
import '../sidebar_navigation.dart';

class RevenueFinance extends StatefulWidget {
  @override
  _RevenueFinanceState createState() => _RevenueFinanceState();
}

class _RevenueFinanceState extends State<RevenueFinance> {
  int key = 0;
  List<String> period = ["All","Today","This Month","This Year","30 Days", "365 Days"];
  String? selectedValue="All";
  String total ='';
  late List<RevenueModel> _Revenue = [];
  double total2=0;

  List<Color> colorList = [
    Color.fromRGBO(0, 0, 0, 0),
    Color.fromRGBO(82, 98, 255, 1),
    Color.fromRGBO(46, 198, 255, 1),
    Color.fromRGBO(123, 201, 82, 1),
    Color.fromRGBO(255, 171, 67, 1),
    Color.fromRGBO(252, 91, 57, 1),
    Color.fromRGBO(139, 135, 130, 1),
  ];

  Map<String, double> getCategoryData() {
    Map<String, double> catMap = {"":0,};
    if (_Revenue==null) {

      catMap.update("", (value) => 0);
    } else {
      for (var item in _Revenue) {
        if (catMap.containsKey(item.channel) == false) {
          catMap[item.channel!] = double.parse(item.amount!);
        } else {
          double a =double.parse(item.amount!);
          catMap.update(item.channel!, (double) => catMap[item.channel]!+ a);
        }
      }}
    total=catMap.toString();
    print(total);
    Iterable<double> values = catMap.values;
    total2 = values.reduce((sum, value) => sum + value);
    print(total2);
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
        DataCell(Text(e.value.toStringAsFixed(2))),
      ]))
          .toList(),
    );


    return a!;
  }

  printTotal(){
    return
      Container(
      height: 29,
      color: Colors.yellow.shade700,
      child: Text('Overall Total: RM${total2.toStringAsFixed(2)}', style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 20,
        fontStyle: FontStyle.italic,
      ),),
    );
  }

  Widget pieChartExampleOne() {
    return PieChart(
      key: ValueKey(key),
      dataMap: getCategoryData(),
      initialAngleInDegree: 0,
      animationDuration: Duration(milliseconds: 2000),
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      ringStrokeWidth: 40,
      colorList: colorList,
      chartLegendSpacing: 40,
      chartValuesOptions: ChartValuesOptions(
          showChartValuesOutside: true,
          showChartValuesInPercentage: true,
          showChartValueBackground: true,
          showChartValues: true,
          chartValueStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontStyle: FontStyle.italic,)),
      centerText: 'Revenue',
      legendOptions: LegendOptions(
          showLegendsInRow: false,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendPosition: LegendPosition.right,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = new DateTime.now();
    DateTime newDateThisMonth = new DateTime(date.year, date.month, 1);
    DateTime newDateThisYear = new DateTime(date.year, 1, 1);
    DateTime newDate30 = new DateTime(date.year, date.month - 1, date.day);
    DateTime newDate365 = new DateTime(date.year-1, date.month, date.day);
    final Stream<QuerySnapshot> expStream;
    if (selectedValue == "Today") {
      expStream =
          FirebaseFirestore.instance.collection('OrderB2C').where(
              'paymentDate',
              isEqualTo: DateTime(DateTime
                  .now()
                  .year, DateTime
                  .now()
                  .month, DateTime
                  .now()
                  .day)
          ).snapshots();
      print(selectedValue);
    } else if (selectedValue == "This Month") {
      expStream =
          FirebaseFirestore.instance.collection('OrderB2C').where(
              'paymentDate',
              isGreaterThanOrEqualTo: newDateThisMonth
          ).snapshots();
      print(selectedValue);

    }else if (selectedValue == "This Year") {
      expStream =
          FirebaseFirestore.instance.collection('OrderB2C').where(
              'paymentDate',
              isGreaterThanOrEqualTo: newDateThisYear
          ).snapshots();
      print(selectedValue);

    }
    else if (selectedValue == "30 Days") {
      expStream =
          FirebaseFirestore.instance.collection('OrderB2C').where(
              'paymentDate',
              isGreaterThanOrEqualTo: newDate30
          ).snapshots();
      print(selectedValue);
    } else if (selectedValue == "365 Days") {
      expStream =
          FirebaseFirestore.instance.collection('OrderB2C').where(
              'paymentDate',
              isGreaterThanOrEqualTo: newDate365
          ).snapshots();
      print(selectedValue);

    }
    else{
      expStream =
          FirebaseFirestore.instance.collection('OrderB2C').snapshots();
      print(selectedValue);
    }

    void getExpfromSnapshot(snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _Revenue = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          RevenueModel exp = RevenueModel().fromJson(a.data());
          _Revenue.add(exp);
        }
      } else{
        _Revenue = [];
      }
    }


    return Scaffold(
      bottomNavigationBar: FinanceCurvedNavBar(indexnum: 0,),
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
                getExpfromSnapshot(data);
                return printTotal();
              },
            ),
            SizedBox(height: 90,),
          ],
        ),
      ),
    );
  }
}

