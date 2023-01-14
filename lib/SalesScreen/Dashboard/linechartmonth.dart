import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartMonth extends StatefulWidget {
  const LineChartMonth({Key? key}) : super(key: key);

  @override
  State<LineChartMonth> createState() => _LineChartMonthState();
}

class _LineChartMonthState extends State<LineChartMonth> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  Future<int> getMonthlyCount(int day) async {
    var docs = await FirebaseFirestore.instance
        .collection('OrderB2C')
        .where('paymentDate',
            isEqualTo: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              day,
            ))
        .get();
    int count = docs.size;
    return count;
  }

  Future<int> getMonthlyCountB2B(int day) async {
    var docs = await FirebaseFirestore.instance
        .collection('OrderB2B')
        .where('orderDate',
            isEqualTo: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              day,
            ))
        .get();
    int count = docs.size;

    return count;
  }

  late int one = 0;
  late int two = 0;
  late int three = 0;
  late int four = 0;
  late int five = 0;
  late int six = 0;
  late int seven = 0;
  late int eight = 0;
  late int nine = 0;
  late int ten = 0;
  late int eleven = 0;
  late int twelve = 0;
  late int thirteen = 0;
  late int fourteen = 0;
  late int fifteen = 0;
  late int sixteen = 0;
  late int seventeen = 0;
  late int eightteen = 0;
  late int nineteen = 0;
  late int twenty = 0;
  late int twentyone = 0;
  late int twentytwo = 0;
  late int twentythree = 0;
  late int twentyfour = 0;
  late int twentyfive = 0;
  late int twentysix = 0;
  late int twentyseven = 0;
  late int twentyeight = 0;
  late int twentynine = 0;
  late int thirty = 0;
  late int thirtyone = 0;

  Future startCount() async {
    one = await getMonthlyCount(1) + await getMonthlyCountB2B(1);
    two = await getMonthlyCount(2) + await getMonthlyCountB2B(2);
    three = await getMonthlyCount(3) + await getMonthlyCountB2B(3);
    four = await getMonthlyCount(4) + await getMonthlyCountB2B(4);
    five = await getMonthlyCount(5) + await getMonthlyCountB2B(5);
    six = await getMonthlyCount(6) + await getMonthlyCountB2B(6);
    seven = await getMonthlyCount(7) + await getMonthlyCountB2B(7);
    eight = await getMonthlyCount(8) + await getMonthlyCountB2B(8);
    nine = await getMonthlyCount(9) + await getMonthlyCountB2B(9);
    ten = await getMonthlyCount(10) + await getMonthlyCountB2B(10);
    eleven = await getMonthlyCount(11) + await getMonthlyCountB2B(11);
    twelve = await getMonthlyCount(12) + await getMonthlyCountB2B(12);
    thirteen = await getMonthlyCount(13) + await getMonthlyCountB2B(13);
    fourteen = await getMonthlyCount(14) + await getMonthlyCountB2B(14);
    fifteen = await getMonthlyCount(15) + await getMonthlyCountB2B(15);
    sixteen = await getMonthlyCount(16) + await getMonthlyCountB2B(16);
    seventeen = await getMonthlyCount(17) + await getMonthlyCountB2B(17);
    eightteen = await getMonthlyCount(18) + await getMonthlyCountB2B(18);
    nineteen = await getMonthlyCount(19) + await getMonthlyCountB2B(19);
    twenty = await getMonthlyCount(20) + await getMonthlyCountB2B(20);
    twentyone = await getMonthlyCount(21) + await getMonthlyCountB2B(21);
    twentytwo = await getMonthlyCount(22) + await getMonthlyCountB2B(22);
    twentythree = await getMonthlyCount(23) + await getMonthlyCountB2B(23);
    twentyfour = await getMonthlyCount(24) + await getMonthlyCountB2B(24);
    twentyfive = await getMonthlyCount(25) + await getMonthlyCountB2B(25);
    twentysix = await getMonthlyCount(26) + await getMonthlyCountB2B(26);
    twentyseven = await getMonthlyCount(27) + await getMonthlyCountB2B(27);
    twentyeight = await getMonthlyCount(28) + await getMonthlyCountB2B(28);
    twentynine = await getMonthlyCount(29) + await getMonthlyCountB2B(29);
    thirty = await getMonthlyCount(30) + await getMonthlyCountB2B(30);
    thirtyone = await getMonthlyCount(31) + await getMonthlyCountB2B(31);
  }

  @override
  void initState() {
    //super.initState();
    startCount();
  }

  @override
  Widget build(BuildContext context) {
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
                    'This Month',
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
                                  right: 14,
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
        text = const Text('1', style: style);
        break;
      case 4:
        text = const Text('5', style: style);
        break;
      case 9:
        text = const Text('10', style: style);
        break;
      case 14:
        text = const Text('15', style: style);
        break;
      case 19:
        text = const Text('20', style: style);
        break;
      case 24:
        text = const Text('25', style: style);
        break;
      case 30:
        text = const Text('31', style: style);
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
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 3:
        text = '3';
        break;
      case 5:
        text = '5';
        break;
      case 7:
        text = '7';
        break;
      case 9:
        text = '9';
        break;
      case 11:
        text = '11';
        break;
      case 13:
        text = '13';
        break;
      case 15:
        text = '15';
        break;
      case 17:
        text = '17';
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
      maxX: 31,
      minY: 0,
      maxY: 20,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, one.toDouble()), //1
            FlSpot(1, two.toDouble()), //7
            FlSpot(2, three.toDouble()), //14
            FlSpot(3, four.toDouble()), //21
            FlSpot(4, five.toDouble()),
            FlSpot(5, six.toDouble()),
            FlSpot(6, seven.toDouble()),
            FlSpot(7, eight.toDouble()),
            FlSpot(8, nine.toDouble()),
            FlSpot(9, ten.toDouble()),
            FlSpot(10, eleven.toDouble()),
            FlSpot(11, twelve.toDouble()),
            FlSpot(12, thirteen.toDouble()),
            FlSpot(13, thirteen.toDouble()),
            FlSpot(14, fourteen.toDouble()),
            FlSpot(15, fifteen.toDouble()),
            FlSpot(16, sixteen.toDouble()),
            FlSpot(17, seventeen.toDouble()),
            FlSpot(18, eightteen.toDouble()),
            FlSpot(19, nineteen.toDouble()),
            FlSpot(20, twenty.toDouble()),
            FlSpot(21, twentyone.toDouble()),
            FlSpot(22, twentytwo.toDouble()),
            FlSpot(23, twentythree.toDouble()),
            FlSpot(24, twentyfour.toDouble()),
            FlSpot(25, twentyfive.toDouble()),
            FlSpot(26, twentysix.toDouble()),
            FlSpot(27, twentyseven.toDouble()),
            FlSpot(28, twentyeight.toDouble()),
            FlSpot(29, twentynine.toDouble()),
            FlSpot(30, thirty.toDouble()),
            FlSpot(31, thirtyone.toDouble()),
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
