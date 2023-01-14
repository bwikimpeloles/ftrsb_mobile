import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartDay extends StatefulWidget {
  const LineChartDay({Key? key}) : super(key: key);

  @override
  State<LineChartDay> createState() => _LineChartDayState();
}

class _LineChartDayState extends State<LineChartDay> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  Future<int> getHourlyCount(int hr) async {
    var docs = await FirebaseFirestore.instance
        .collection('OrderB2C')
        .where('paymentDate',
            isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, hr, 0, 0))
        .where('paymentDate',
            isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, hr, 59, 59))
        .get();
    int count = docs.size;
    return count;
  }

  late int count7AM = 0;
  late int count8AM = 0;
  late int count9AM = 0;
  late int count10AM = 0;
  late int count11AM = 0;
  late int count12PM = 0;
  late int count1PM = 0;
  late int count2PM = 0;
  late int count3PM = 0;
  late int count4PM = 0;
  late int count5PM = 0;
  late int count6PM = 0;
  late int count7PM = 0;

  Future<int> getHourlyCountB2B(int hr) async {
    var docs = await FirebaseFirestore.instance
        .collection('OrderB2B')
        .where('orderDate',
            isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, hr, 0, 0))
        .where('orderDate',
            isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, hr, 59, 59))
        .get();
    int count = docs.size;

    return count;
  }

Future startCount() async {
    count7AM = await getHourlyCount(7) + await getHourlyCountB2B(7);
    count8AM = await getHourlyCount(8) + await getHourlyCountB2B(8);
    count9AM = await getHourlyCount(9) + await getHourlyCountB2B(9);
    count10AM = await getHourlyCount(10) + await getHourlyCountB2B(10);
    count11AM = await getHourlyCount(11) + await getHourlyCountB2B(11);
    count12PM = await getHourlyCount(12) + await getHourlyCountB2B(12);
    count1PM = await getHourlyCount(13) + await getHourlyCountB2B(13);
    count2PM = await getHourlyCount(14) + await getHourlyCountB2B(14);
    count3PM = await getHourlyCount(15) + await getHourlyCountB2B(15);
    count4PM = await getHourlyCount(16) + await getHourlyCountB2B(16);
    count5PM = await getHourlyCount(17) + await getHourlyCountB2B(17);
    count6PM = await getHourlyCount(18) + await getHourlyCountB2B(18);
    count7PM = await getHourlyCount(19) + await getHourlyCountB2B(19);
  }

   @override
  void initState() {
    super.initState();
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
                  Text(
                    'Today',
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
      fontSize: 13,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('7AM', style: style);
        break;
      case 2:
        text = const Text('9AM', style: style);
        break;
      case 4:
        text = const Text('11AM', style: style);
        break;
      case 6:
        text = const Text('1PM', style: style);
        break;
      case 8:
        text = const Text('3PM', style: style);
        break;
      case 10:
        text = const Text('5PM', style: style);
        break;
      case 12:
        text = const Text('7PM', style: style);
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
        text = '20';
        break;
      case 3:
        text = '40';
        break;
      case 5:
        text = '60';
        break;
      case 7:
        text = '80';
        break;
      case 9:
        text = '100';
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
      maxX: 12,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, count7AM.toDouble()),
            FlSpot(1, count8AM.toDouble()),
            FlSpot(2, count9AM.toDouble()),
            FlSpot(3, count10AM.toDouble()),
            FlSpot(4, count11AM.toDouble()),
            FlSpot(5, count12PM.toDouble()),
            FlSpot(6, count1PM.toDouble()),
            FlSpot(7, count2PM.toDouble()),
            FlSpot(8, count3PM.toDouble()),
            FlSpot(9, count4PM.toDouble()),
            FlSpot(10, count5PM.toDouble()),
            FlSpot(11, count6PM.toDouble()),
            FlSpot(12, count7PM.toDouble()),
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
