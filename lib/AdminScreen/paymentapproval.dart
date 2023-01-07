import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ftrsb_mobile/AdminScreen/sidebar_navigation.dart';
import 'package:ftrsb_mobile/AdminScreen/view_paymentapproval.dart';
import '../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class PaymentApprovalAdmin extends StatefulWidget {
  const PaymentApprovalAdmin({Key? key}) : super(key: key);

  @override
  _PaymentApprovalAdminState createState() => _PaymentApprovalAdminState();
}

class _PaymentApprovalAdminState extends State<PaymentApprovalAdmin> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String? mtoken = "";
  late Query _ref;
  CollectionReference reference =
  FirebaseFirestore.instance.collection('MakePayments');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    getToken();
    requestPermission();

    _ref = FirebaseFirestore.instance.collection('MakePayments')
        .orderBy('effectivedate');
  }
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      'token' : token,
    });
  }
  Future<bool> getSwitch() async{
    String userid= user!.uid.toString();
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(userid).get();
    bool paymentnotification = snap['paymentnotification'];
    return paymentnotification;
  }

  void updateSwitch(bool newValue) async {
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      'paymentnotification': newValue,
    });

    if(newValue==true){
      await FirebaseMessaging.instance.subscribeToTopic("topicmakepay");
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic("topicmakepay");
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ViewPaymentApproval(
                                  paymentKey: payment['key'],
                                )));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.receipt,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('View',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
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
        title: Text('Check Payment'),
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
            Map payment = snapshot?.data() as Map;
            payment['key'] = snapshot?.id;
            return _buildPaymentItem(payment: payment);
          },
        ),
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}

