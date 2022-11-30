import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as Database;
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'makepayment/view_payment.dart';
import 'sidebar_navigation.dart';
import 'makepayment/add_payment.dart';
import 'makepayment/edit_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MakePaymentFinance extends StatefulWidget {
  @override
  _MakePaymentFinanceState createState() => _MakePaymentFinanceState();
}

class _MakePaymentFinanceState extends State<MakePaymentFinance> {
  late Database.Query _ref;
  String? mtoken = "";
  Database.DatabaseReference reference =
  Database.FirebaseDatabase.instance.reference().child('MakePayments');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();

    _ref = Database.FirebaseDatabase.instance
        .reference()
        .child('MakePayments')
        .orderByChild('time');
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );


    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }
    else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }


    Widget _buildPaymentItem({required Map payment}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => ViewPayment(
                  paymentKey: payment['key'],
                )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        height: 160,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 0.5, color: Colors.lightGreen.shade500),
              bottom: BorderSide(width: 0.5, color: Colors.lightGreen.shade500),
            )),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Title: ',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[900],
                      fontWeight: FontWeight.w800),),
                SizedBox(
                  width: 6,
                ),
                Text(
                  payment['title'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text('To: ',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[900],
                      fontWeight: FontWeight.w800),),
                SizedBox(
                  width: 6,
                ),
                Text(
                  payment['accountholder'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 15),

              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text('Amount (RM): ',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[900],
                      fontWeight: FontWeight.w800),),
                SizedBox(
                  width: 6,
                ),
                Text(
                  payment['amount'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 15),

              ],
            ),
            SizedBox(
              height: 10,
            ),

            Row(
              children: [
                Text('Status: ',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[900],
                      fontWeight: FontWeight.w800),),
                SizedBox(
                  width: 6,
                ),
                Text(
                  payment['status'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 15),

              ],
            ),
            SizedBox(
              height: 8,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _showDeleteDialog(payment: payment);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red[700],
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text('Delete',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red[700],
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _showDeleteDialog({required Map payment}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${payment['title']}'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    reference
                        .child(payment['key'])
                        .remove()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text('Make Payment'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, Database.DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map payment = snapshot.value as Map;
            payment['key'] = snapshot.key;
            return _buildPaymentItem(payment: payment);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return AddPayment();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }


}