import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/model/orderb2c_model.dart';
import 'package:graphic/graphic.dart';

class SalesOutreach extends StatefulWidget {
  const SalesOutreach({Key? key}) : super(key: key);

  @override
  State<SalesOutreach> createState() => _SalesOutreachState();
}

class _SalesOutreachState extends State<SalesOutreach> {
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

  

  final basicData = [
    {'genre': 'Sports', 'sold': 275},
    {'genre': 'Strategy', 'sold': 115},
    {'genre': 'Action', 'sold': 120},
    {'genre': 'Shooter', 'sold': 500},
    {'genre': 'Other', 'sold': 150},
  ];

  @override
  Widget build(BuildContext context) {

    //List<OrderB2CModel> weightData =getChannelData().entries.map<OrderB2CModel>( (entry) => OrderB2CModel(entry.key, entry.value)).toList();
List<OrderB2CModel> _list = getChannelData().entries.map<OrderB2CModel>( (entry) => OrderB2CModel()).toList();
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

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
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
                          'Sales Outreach',
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
                          'by channel',
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
                        stream: FirebaseFirestore.instance
                            .collection('OrderB2C')
                            .where('paymentDate',
                                isGreaterThanOrEqualTo:
                                    DateTime(DateTime.now().year, 1, 1))
                            .where('paymentDate',
                                isLessThanOrEqualTo:
                                    DateTime(DateTime.now().year, 12, 31))
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("something went wrong");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          final data = snapshot.requireData;
                          print("Data: $data");
                          getExpfromSnapshot(data);
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: 350,
                            height: 300,
                            child: Chart(
                              data: basicData,
                              variables: {
                                'genre': Variable(
                                  accessor: (Map map) => map['genre'] as String,
                                ),
                                'sold': Variable(
                                  accessor: (Map map) => map['sold'] as num,
                                ),
                              },
                              elements: [
                                IntervalElement(
                                  label: LabelAttr(
                                      encoder: (tuple) =>
                                          Label(tuple['sold'].toString())),
                                  gradient: GradientAttr(
                                      value: const LinearGradient(colors: [
                                        Color.fromARGB(134, 131, 246, 156),
                                        Color.fromARGB(135, 24, 240, 42),
                                        Color.fromARGB(204, 24, 240, 24),
                                      ], stops: [
                                        0,
                                        0.5,
                                        1
                                      ]),
                                      updaters: {
                                        'tap': {
                                          true: (_) =>
                                              const LinearGradient(colors: [
                                                Color.fromARGB(
                                                    134, 131, 246, 156),
                                                Color.fromARGB(
                                                    135, 24, 240, 42),
                                                Color.fromARGB(
                                                    204, 24, 240, 24),
                                              ], stops: [
                                                0,
                                                0.7,
                                                1
                                              ])
                                        }
                                      }),
                                )
                              ],
                              coord: RectCoord(transposed: true),
                              axes: [
                                Defaults.verticalAxis
                                  ..line = Defaults.strokeStyle
                                  ..grid = null,
                                Defaults.horizontalAxis
                                  ..line = null
                                  ..grid = Defaults.strokeStyle,
                              ],
                              selections: {'tap': PointSelection(dim: Dim.x)},
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
