import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/model/product_sold_model.dart';
import 'package:pie_chart/pie_chart.dart';

class SalesBreakdownB2C1 extends StatefulWidget {
  SalesBreakdownB2C1({Key? key,}) : super(key: key);

  @override
  State<SalesBreakdownB2C1> createState() => _SalesBreakdownB2C1State();
}

class _SalesBreakdownB2C1State extends State<SalesBreakdownB2C1> {
  List<dynamic> listproductname = [];
  List<SoldProductModel> sold = [];
  List<dynamic> list = [];
  int key = 0;
  String total = '';

  Map<String, double> getSoldProductData() {
    Map<String, double> catMap = {
      "": 0,
    };
    if (sold == null) {
      catMap.update("", (value) => 0);
    } else {
      for (var item in sold) {
        if (catMap.containsKey(item.name) == false) {
          catMap[item.name!] = double.parse(item.quantity!);
        } else {
          double a = double.parse(item.quantity!);
          catMap.update(item.name!, (double) => catMap[item.name]! + a);
        }
      }
    }
    total = catMap.toString();
    //print(total);
    return catMap;
  }

  List<Color> colorList = [
    Color.fromRGBO(0, 0, 0, 0),
    Color.fromARGB(255, 57, 177, 252),
    Color.fromARGB(255, 241, 77, 197),
    Color.fromARGB(255, 77, 241, 118),
    Color.fromARGB(255, 154, 77, 241),
    Color.fromARGB(255, 77, 233, 241),
    Color.fromARGB(255, 25, 130, 135),
    Color.fromARGB(255, 98, 8, 104),
    Color.fromARGB(255, 26, 125, 61),
    Color.fromARGB(255, 221, 240, 44),
  ];

  Widget pieChartExampleOne() {
    return PieChart(
      key: ValueKey(key),
      dataMap: getSoldProductData(),
      initialAngleInDegree: 0,
      animationDuration: Duration(milliseconds: 2000),
      chartType: ChartType.disc,
      chartRadius: MediaQuery.of(context).size.width / 2,
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
      //centerText: 'B2C',
      legendOptions: const LegendOptions(
          showLegendsInRow: false,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendPosition: LegendPosition.bottom,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
    );
  }

  @override
  void initState() {
    setState(() {
      sold = [];
      total = '';
    });
  }

  @override
  Widget build(BuildContext context) {
  
    return Center(
        child: Column(
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
          .collection('OrderB2C')
          .where('paymentDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day))
          .where('paymentDate',
              isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day + 1))
          .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.length > 0) {
                final int count = snapshot.data!.docs.length;

                for (int i = 0; i < count; i++) {
                  final data = snapshot.data!.docs[i];
                  list.add(data['product']);
                }

                String newproductstr =
                    list.toString().replaceAll(RegExp(r'[\[\]]'), '');

                List newlist = newproductstr
                    .split(':')
                    .toString()
                    .replaceAll(RegExp(r'[\[\]]'), '')
                    .split(',');

                List<String> product = [];
                List<String> qty = [];

                for (int i = 0; i < newlist.length; i++) {
                  if (i.isEven) {
                    product.add(newlist[i]);
                  } else if (i.isOdd) {
                    qty.add(newlist[i]);
                  }
                }

                for (int i = 0; i < product.length; i++) {
                  sold.add(SoldProductModel(
                      name: product[i].trim(), quantity: qty[i].trim()));
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
                    padding: const EdgeInsets.fromLTRB(30.0, 16, 30, 16),
                    child: Column(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const Text(
                                'Sales Breakdown',
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
                                'by product',
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
                              Center(child: pieChartExampleOne()),
                            ]),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            }),
      ],
    ));
  }
}
