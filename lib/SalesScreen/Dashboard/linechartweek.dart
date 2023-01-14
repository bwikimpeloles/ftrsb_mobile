import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/model/orderb2c_model.dart';

class LineChartWeek extends StatefulWidget {
  const LineChartWeek({Key? key}) : super(key: key);

  @override
  State<LineChartWeek> createState() => _LineChartWeekState();
}

class _LineChartWeekState extends State<LineChartWeek> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  DateTime mostRecentMonday(DateTime date) =>
      DateTime(date.year, date.month, date.day - (date.weekday - 1));

  late List<OrderB2CModel> _order = [];
  String total = '';

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

  @override
  Widget build(BuildContext context) {

 DateTime date = new DateTime.now();
    DateTime newDateThisMonth = new DateTime(date.year, date.month, 1);
    DateTime newDateThisYear = new DateTime(date.year, 1, 1);
    DateTime newDate30 = new DateTime(date.year, date.month - 1, date.day);
    DateTime newDate365 = new DateTime(date.year - 1, date.month, date.day);

    final Stream<QuerySnapshot> expStream;

    expStream = FirebaseFirestore.instance
        .collection('OrderB2C')
        .where('paymentDate',
            isEqualTo: DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day))
        .snapshots();

    void getExpfromSnapshot(snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _order = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          // print(a.data());
          OrderB2CModel exp = OrderB2CModel().fromJson(a.data());
          _order.add(exp);
          // print(exp);
        }
      }
    }

    final temp = Container();
    final stream = StreamBuilder<Object>(
      stream: expStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SizedBox(height: 50, child: CircularProgressIndicator()));
        }
        final data = snapshot.requireData;
        print("Data: $data");
        getExpfromSnapshot(data);
        getChannelData(); //CATMAP
        return LineChartWeek();
      },
    );

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
            boxShadow: kElevationToShadow[3],
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            color: Colors.white),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Sales Trend',
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
                    'This Week',
                    style: TextStyle(
                      color: Color(0xff379982),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Stack(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 1.3,
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                                color: Color(0xff232d37),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 16,
                                  left: 10,
                                  top: 15,
                                  bottom: 10,
                                ),
                                child: LineChart(
                                  mainData(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('S', style: style);
        break;
      case 1:
        text = const Text('M', style: style);
        break;
      case 2:
        text = const Text('T', style: style);
        break;
        case 3:
        text = const Text('W', style: style);
        break;
        case 4:
        text = const Text('T', style: style);
        break;
        case 5:
        text = const Text('F', style: style);
        break;
        case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 8,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            
            FlSpot(0, 5), //Monday
            FlSpot(1, 7),
            FlSpot(2, 6),
            FlSpot(3, 1),
            FlSpot(4, 2),
            FlSpot(5, 5), 
            FlSpot(6, 3),//Sunday
            
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  
  
}
