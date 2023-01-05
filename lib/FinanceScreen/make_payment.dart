import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'makepayment/view_payment.dart';
import 'sidebar_navigation.dart';
import 'makepayment/add_payment.dart';

class MakePaymentFinance extends StatefulWidget {
  @override
  _MakePaymentFinanceState createState() => _MakePaymentFinanceState();
}

class _MakePaymentFinanceState extends State<MakePaymentFinance> {
  late Query _ref;
  String? mtoken = "";
  CollectionReference reference =
  FirebaseFirestore.instance.collection('MakePayments');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();

    _ref = FirebaseFirestore.instance.collection('MakePayments')
        .orderBy('effectivedate');
  }

  Future<bool> getSwitch() async{
    String userid= user!.uid.toString();
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(userid).get();
    bool approvalnotification = snap['approvalnotification'];
    return approvalnotification;
  }

  void updateSwitch(bool newValue) async {
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      'approvalnotification': newValue,
    });

    if(newValue==true){
      await FirebaseMessaging.instance.subscribeToTopic("topicapprove");
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic("topicapprove");
    }
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(10),

          decoration: new BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
              gradient: new LinearGradient(colors: [Colors.white70, Colors.white],
                  begin: Alignment.centerLeft, end: Alignment.centerRight, tileMode: TileMode.clamp)
          ),

          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Title: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        payment['title'],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
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
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        payment['accountholder'],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
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
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      payment['amount'],
                      style: TextStyle(
                          fontSize: 16,
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
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      payment['status'],
                      style: TextStyle(
                          fontSize: 16,
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
                        .doc(payment['key'])
                        .delete()
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
        actions: <Widget>[
          FutureBuilder(
              future: getSwitch(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!=null) {
                  bool result = snapshot.data as bool;
                  return Switch(
                      activeTrackColor: Colors.white,
                      activeColor: Colors.green.shade900,

                      value: result, onChanged: (bool newVal) {
                    setState(() => result = newVal);
                    updateSwitch(newVal);
                  });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }
          ),
          Icon(Icons.notifications_active),
          SizedBox(width: 10,),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: FirestoreAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DocumentSnapshot? snapshot,
              Animation<double> animation, int index) {
            Map<String, dynamic> payment = snapshot?.data() as Map<String, dynamic>;
            payment['key'] = snapshot?.id;
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