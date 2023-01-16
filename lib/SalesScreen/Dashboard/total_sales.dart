import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TotalSales extends StatefulWidget {
  String? selectedValue;
  TotalSales({Key? key, required this.selectedValue}) : super(key: key);

  @override
  State<TotalSales> createState() => _TotalSalesState();
}

class _TotalSalesState extends State<TotalSales> {

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> expStream;
    if (widget.selectedValue == "Today") {
      expStream = FirebaseFirestore.instance
          .collection('OrderB2C')
          .where('orderDate',
              isEqualTo: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day))
          .snapshots();
      print(widget.selectedValue);
    } else if (widget.selectedValue == "This Month") {
      expStream = FirebaseFirestore.instance
          .collection('OrderB2C')
          .where('paymentDate',
              isGreaterThanOrEqualTo:
                  DateTime(DateTime.now().year, DateTime.now().month, 1))
          .where('paymentDate',
              isLessThan:
                  DateTime(DateTime.now().year, DateTime.now().month, 31))
          .snapshots();
      print(widget.selectedValue);
    } else {
      //Last 7 days
      expStream = FirebaseFirestore.instance
          .collection('OrderB2C')
          .where('paymentDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day))
          .where('paymentDate',
              isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day + 6))
          .snapshots();
    }

    final Stream<QuerySnapshot> expStream1;
    if (widget.selectedValue == "Today") {
      expStream1 = FirebaseFirestore.instance
          .collection('OrderB2B')
          .where('paymentDate',
              isEqualTo: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day))
          .snapshots();
      print(widget.selectedValue);
    } else if (widget.selectedValue == "This Month") {
      expStream1 = FirebaseFirestore.instance
          .collection('OrderB2B')
          .where('orderDate',
              isGreaterThanOrEqualTo:
                  DateTime(DateTime.now().year, DateTime.now().month, 1))
          .where('orderDate',
              isLessThan:
                  DateTime(DateTime.now().year, DateTime.now().month, 31))
          .snapshots();
      print(widget.selectedValue);
    } else {
      //Last 7 days
      expStream1 = FirebaseFirestore.instance
          .collection('OrderB2B')
          .where('orderDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day))
          .where('orderDate',
              isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day + 6))
          .snapshots();
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: expStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int count = snapshot.data!.docs.length;
                int sum = 0;
                for (int i = 0; i < count; i++) {
                  final data = snapshot.data!.docs[i];
                  sum = sum + int.parse(data['amount']);
                }
          
                return Container(
                    decoration: BoxDecoration(
                        boxShadow: kElevationToShadow[2],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text('B2C Order Count:', style: TextStyle(color: Color(0xff0f4a3c), fontSize: 16,fontWeight: FontWeight.bold),),
                          Text(count.toString(), style: TextStyle(color: Colors.green, fontSize: 20,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),     
                          Text('Total Sales (RM): ', style: TextStyle(color: Color(0xff0f4a3c), fontSize: 16,fontWeight: FontWeight.bold),) ,
                          Text(sum.toString(),style: TextStyle(color: Colors.green, fontSize: 20,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ));
              }
              return CircularProgressIndicator();
            },
          ),
          SizedBox(width: 5,),
          StreamBuilder<QuerySnapshot>(
            stream: expStream1,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int count = snapshot.data!.docs.length;
                int sum = 0;
                for (int i = 0; i < count; i++) {
                  final data = snapshot.data!.docs[i];
                  sum = sum + int.parse(data['amount']);
                }
      
                return Container(
                    decoration: BoxDecoration(
                        boxShadow: kElevationToShadow[2],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text('B2B Order Count:', style: TextStyle(color: Color(0xff0f4a3c), fontSize: 16,fontWeight: FontWeight.bold),),
                          Text(count.toString(), style: TextStyle(color: Colors.green, fontSize: 20,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),     
                          Text('Total Sales (RM): ', style: TextStyle(color: Color(0xff0f4a3c), fontSize: 16,fontWeight: FontWeight.bold),) ,
                          Text(sum.toString(),style: TextStyle(color: Colors.green, fontSize: 20,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ));
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
