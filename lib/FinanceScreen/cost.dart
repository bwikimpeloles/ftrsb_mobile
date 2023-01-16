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
  List<String> period = ["All","Today","This Month","This Year","30 Days", "365 Days"];
  String? selectedValue="All";
  String total ='';
  double total2=0;

  late List<CostModel> _cost = [];

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
    if (_cost==null) {

      catMap.update("", (value) => 0);
    } else {

    for (var item in _cost) {
      if (catMap.containsKey(item.category) == false) {
        catMap[item.category!] = double.parse(item.amount!);
      } else {
        double a =double.parse(item.amount!);
        catMap.update(item.category!, (double) => catMap[item.category]!+ a);
      }
    }}
    total=catMap.toString();
    Iterable<double> values = catMap.values;
    total2 = values.reduce((sum, value) => sum + value);
    print(total2);
    print("this is ${total}");
    return catMap;
  }

  DataTable printCostData() {
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
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontStyle: FontStyle.italic)),
      centerText: 'Cost',
      legendOptions: LegendOptions(
          showLegendsInRow: false,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendPosition: LegendPosition.right,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontStyle: FontStyle.italic
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
      FirebaseFirestore.instance.collection('Cost').where(
          'date',
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
          FirebaseFirestore.instance.collection('Cost').where(
              'date',
              isGreaterThanOrEqualTo: newDateThisMonth
          ).snapshots();
      print(selectedValue);

    }else if (selectedValue == "This Year") {
      expStream =
          FirebaseFirestore.instance.collection('Cost').where(
              'date',
              isGreaterThanOrEqualTo: newDateThisYear
          ).snapshots();
      print(selectedValue);

    }
    else if (selectedValue == "30 Days") {
      expStream =
          FirebaseFirestore.instance.collection('Cost').where(
              'date',
              isGreaterThanOrEqualTo: newDate30
          ).snapshots();
      print(selectedValue);
    } else if (selectedValue == "365 Days") {
      expStream =
          FirebaseFirestore.instance.collection('Cost').where(
              'date',
              isGreaterThanOrEqualTo: newDate365
          ).snapshots();
      print(selectedValue);

    }
    else{
    expStream =
    FirebaseFirestore.instance.collection('Cost').snapshots();
    print(selectedValue);
  }

    void getExpfromSnapshot(snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _cost = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          CostModel exp = CostModel().fromJson(a.data());
          _cost.add(exp);
        }
      } else{
        _cost = [];
      }
    }

    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text('Cost'),
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
                  return Container(child: printCostData(), width: 300,);
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


            ],
          ),
        ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return ListCostFinance();
            }),
          ).then((value) => setState(() {}));
        },
        label: const Text('Manage Cost'),
        icon: const Icon(Icons.pie_chart),
      ),
    );
  }
}

