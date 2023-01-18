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
    Stream<QuerySnapshot> expStream;

    getStream(int i){
      expStream = FirebaseFirestore.instance
          .collection('OrderB2C')
          .where('paymentDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year,i,
                  1))
          .where('paymentDate',
              isLessThanOrEqualTo: DateTime(DateTime.now().year, i,
                  31))
          .snapshots();

      return expStream;
    }

    if (widget.selectedValue == "Today") {
       expStream = FirebaseFirestore.instance
          .collection('OrderB2C')
          .where('paymentDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day))
          .where('paymentDate',
              isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day + 1))
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
                  DateTime(DateTime.now().year, DateTime.now().month, 32))
          .snapshots();
      print(widget.selectedValue);
    } else if (widget.selectedValue == "This Week"){
      //Last 7 days
      expStream = FirebaseFirestore.instance
          .collection('OrderB2C')
          .where('paymentDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day - 6))
          .where('paymentDate',
              isLessThan: DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day + 1))
          .snapshots();
    } else {
      expStream = FirebaseFirestore.instance
          .collection('OrderB2C').where('paymentDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                  1, 1))
          .where('paymentDate',
              isLessThanOrEqualTo: DateTime(DateTime.now().year,
                  12, 31)).snapshots();
    }

    final Stream<QuerySnapshot> expStream1;
    if (widget.selectedValue == "Today") {
      expStream1 = FirebaseFirestore.instance
          .collection('OrderB2B')
         .where('orderDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day))
          .where('orderDate',
              isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day + 1))
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
                  DateTime(DateTime.now().year, DateTime.now().month, 32))
          .snapshots();
      print(widget.selectedValue);
    } else if (widget.selectedValue == "This Week") {
      //Last 7 days
      expStream1 = FirebaseFirestore.instance
          .collection('OrderB2B')
          .where('orderDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day - 6))
          .where('orderDate',
              isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day + 1))
          .snapshots();
    } else {
      expStream1 = FirebaseFirestore.instance
          .collection('OrderB2B').where('orderDate',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                  1, 1))
          .where('orderDate',
              isLessThanOrEqualTo: DateTime(DateTime.now().year, 12,
                  31)).snapshots();
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
                double sum = 0;
                for (int i = 0; i < count; i++) {
                  final data = snapshot.data!.docs[i];
                  sum = sum + double.parse(data['amount']);
                }
          
                return Container(
                  height: 135,
                  width: 160,
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
                          Text(count.toString(), style: TextStyle(color: Colors.green, fontSize: 20,fontWeight: FontWeight.bold),),
                          Text('B2C Orders', style: TextStyle(color: Color(0xff0f4a3c).withOpacity(0.7), fontSize: 15,fontWeight: FontWeight.bold),),
                          
                          SizedBox(height: 10,),   
                          Text('RM' +sum.toString(),style: TextStyle(color: Colors.green, fontSize: 20,fontWeight: FontWeight.bold),),  
                          Text('Total Sales', style: TextStyle(color: Color(0xff0f4a3c).withOpacity(0.7), fontSize: 15,fontWeight: FontWeight.bold),) ,

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
                double sum = 0;
                for (int i = 0; i < count; i++) {
                  final data = snapshot.data!.docs[i];
                  sum = sum + double.parse(data['amount']);
                }
      
                return Container(
                  height: 135,
                  width: 160,
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
                          Text(count.toString(), style: TextStyle(color: Colors.green, fontSize: 20,fontWeight: FontWeight.bold),),
                          Text('B2B Orders', style: TextStyle(color: Color(0xff0f4a3c).withOpacity(0.7), fontSize: 15,fontWeight: FontWeight.bold),),
                          
                          SizedBox(height: 10,),  
                          Text('RM' +sum.toString(),style: TextStyle(color: Colors.green, fontSize: 20,fontWeight: FontWeight.bold),),   
                          Text('Total Sales', style: TextStyle(color: Color(0xff0f4a3c).withOpacity(0.7), fontSize: 15,fontWeight: FontWeight.bold),) ,
                          
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
