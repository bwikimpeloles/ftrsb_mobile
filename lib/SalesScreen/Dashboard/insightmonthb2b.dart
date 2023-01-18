import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InsightMonthB2B extends StatefulWidget {
  InsightMonthB2B({
    Key? key,
  }) : super(key: key);

  @override
  State<InsightMonthB2B> createState() => _InsightMonthB2BState();
}

class _InsightMonthB2BState extends State<InsightMonthB2B> {
  @override
  Widget build(BuildContext context) {
    final customtextstyle = TextStyle(
        color: Colors.teal,
        fontSize: 18,
        fontWeight: FontWeight.bold);
    Stream<QuerySnapshot> expStream;

    getStream(int i) {
      expStream = FirebaseFirestore.instance
          .collection('OrderB2B')
          .where('orderDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year, i, 1))
          .where('orderDate',
              isLessThanOrEqualTo: DateTime(DateTime.now().year, i, 31))
          .snapshots();

      return expStream;
    }

    final january = StreamBuilder<QuerySnapshot>(
      stream: getStream(1),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.docs.length;
          double sum = 0;
          for (int i = 0; i < count; i++) {
            final data = snapshot.data!.docs[i];
            sum = sum + double.parse(data['amount']);
          }

          return Row(
            children: [
              SizedBox(
                  width: 100,
                  child: Text(
                    'January',
                    style: customtextstyle
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    count.toString(),
                    style: customtextstyle,textAlign: TextAlign.center,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    sum.toString(),
                   style: customtextstyle,textAlign: TextAlign.center,
                  )),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );

    final february = StreamBuilder<QuerySnapshot>(
      stream: getStream(2),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.docs.length;
          double sum = 0;
          for (int i = 0; i < count; i++) {
            final data = snapshot.data!.docs[i];
            sum = sum + double.parse(data['amount']);
          }

          return Row(
            children: [
              SizedBox(
                  width: 100,
                  child: Text(
                    'February',
                   style: customtextstyle
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    count.toString(),
                    style: customtextstyle,textAlign: TextAlign.center,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    sum.toString(),
                    style: customtextstyle,textAlign: TextAlign.center
                  )),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );

    final march = StreamBuilder<QuerySnapshot>(
      stream: getStream(3),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.docs.length;
          double sum = 0;
          for (int i = 0; i < count; i++) {
            final data = snapshot.data!.docs[i];
            sum = sum + double.parse(data['amount']);
          }

          return Row(
            children: [
              SizedBox(
                  width: 100, child: Text('March', style: customtextstyle)),
              SizedBox(
                  width: 100,
                  child: Text(
                    count.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    sum.toString(),
                    style: customtextstyle,textAlign: TextAlign.center,
                  )),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );

    final april = StreamBuilder<QuerySnapshot>(
      stream: getStream(4),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.docs.length;
          double sum = 0;
          for (int i = 0; i < count; i++) {
            final data = snapshot.data!.docs[i];
            sum = sum + double.parse(data['amount']);
          }

          return Row(
            children: [
              SizedBox(
                  width: 100, child: Text('April', style: customtextstyle)),
              SizedBox(
                  width: 100,
                  child: Text(
                    count.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    sum.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );

    final may = StreamBuilder<QuerySnapshot>(
      stream: getStream(5),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.docs.length;
          double sum = 0;
          for (int i = 0; i < count; i++) {
            final data = snapshot.data!.docs[i];
            sum = sum + double.parse(data['amount']);
          }

          return Row(
            children: [
              SizedBox(
                  width: 100, child: Text('May', style: customtextstyle)),
              SizedBox(
                  width: 100,
                  child: Text(
                    count.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    sum.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );

    final june = StreamBuilder<QuerySnapshot>(
      stream: getStream(6),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.docs.length;
          double sum = 0;
          for (int i = 0; i < count; i++) {
            final data = snapshot.data!.docs[i];
            sum = sum + double.parse(data['amount']);
          }

          return Row(
            children: [
              SizedBox(
                  width: 100, child: Text('June', style: customtextstyle)),
              SizedBox(
                  width: 100,
                  child: Text(
                    count.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    sum.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );

    final july = StreamBuilder<QuerySnapshot>(
      stream: getStream(7),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.docs.length;
          double sum = 0;
          for (int i = 0; i < count; i++) {
            final data = snapshot.data!.docs[i];
            sum = sum + double.parse(data['amount']);
          }

          return Row(
            children: [
              SizedBox(
                  width: 100, child: Text('July', style: customtextstyle)),
              SizedBox(
                  width: 100,
                  child: Text(
                    count.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    sum.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );

    final august = StreamBuilder<QuerySnapshot>(
      stream: getStream(8),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.docs.length;
          double sum = 0;
          for (int i = 0; i < count; i++) {
            final data = snapshot.data!.docs[i];
            sum = sum + double.parse(data['amount']);
          }

          return Row(
            children: [
              SizedBox(
                  width: 100, child: Text('August', style: customtextstyle)),
              SizedBox(
                  width: 100,
                  child: Text(
                    count.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    sum.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );

    final september = StreamBuilder<QuerySnapshot>(
      stream: getStream(9),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.docs.length;
          double sum = 0;
          for (int i = 0; i < count; i++) {
            final data = snapshot.data!.docs[i];
            sum = sum + double.parse(data['amount']);
          }

          return Row(
            children: [
              SizedBox(
                  width: 100, child: Text('September', style: customtextstyle)),
              SizedBox(
                  width: 100,
                  child: Text(
                    count.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    sum.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );

    final october = StreamBuilder<QuerySnapshot>(
      stream: getStream(10),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.docs.length;
          double sum = 0;
          for (int i = 0; i < count; i++) {
            final data = snapshot.data!.docs[i];
            sum = sum + double.parse(data['amount']);
          }

          return Row(
            children: [
              SizedBox(
                  width: 100, child: Text('October', style: customtextstyle)),
              SizedBox(
                  width: 100,
                  child: Text(
                    count.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    sum.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );

    final november = StreamBuilder<QuerySnapshot>(
      stream: getStream(11),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.docs.length;
          double sum = 0;
          for (int i = 0; i < count; i++) {
            final data = snapshot.data!.docs[i];
            sum = sum + double.parse(data['amount']);
          }

          return Row(
            children: [
              SizedBox(
                  width: 100, child: Text('November', style: customtextstyle)),
              SizedBox(
                  width: 100,
                  child: Text(
                    count.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    sum.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );

    final december = StreamBuilder<QuerySnapshot>(
      stream: getStream(12),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.docs.length;
          double sum = 0;
          for (int i = 0; i < count; i++) {
            final data = snapshot.data!.docs[i];
            sum = sum + double.parse(data['amount']);
          }

          return Row(
            children: [
              SizedBox(
                  width: 100, child: Text('December', style: customtextstyle)),
              SizedBox(
                  width: 100,
                  child: Text(
                    count.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    sum.toString(),
                    style: customtextstyle,
                    textAlign: TextAlign.center,
                  )),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );

    return Container(
      decoration: BoxDecoration(
          boxShadow: kElevationToShadow[2],
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30.0,16,30,16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Sales by Month',
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
                    'B2B',
                    style: TextStyle(
                      color: Color(0xff379982),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ]),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(''),
                ),
                SizedBox(
                    width: 100,
                    child: Text(
                      'Number of Order',
                      style: TextStyle(
                          color: Color.fromARGB(255, 21, 88, 23),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),textAlign: TextAlign.center
                    )),
                SizedBox(
                    width: 100,
                    child: Text(
                      'Total Sales (RM)',
                      style: TextStyle(
                          color: Color.fromARGB(255, 21, 88, 23),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),textAlign: TextAlign.center
                    )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            january,
            SizedBox(
              height: 10,
            ),
            february,
            SizedBox(
              height: 10,
            ),
            march,
            SizedBox(
              height: 10,
            ),
            april,
            SizedBox(
              height: 10,
            ),
            may,
            SizedBox(
              height: 10,
            ),
            june,
            SizedBox(
              height: 10,
            ),
            july,
            SizedBox(
              height: 10,
            ),
            august,
            SizedBox(
              height: 10,
            ),
            september,
            SizedBox(
              height: 10,
            ),
            october,
            SizedBox(
              height: 10,
            ),
            november,
            SizedBox(
              height: 10,
            ),
            december
          ],
        ),
      ),
    );
  }
}
