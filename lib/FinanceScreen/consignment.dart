import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'sidebar_navigation.dart';

class ConsignmentFinance extends StatefulWidget {
  @override
  _ConsignmentFinanceState createState() => _ConsignmentFinanceState();
}

class _ConsignmentFinanceState extends State<ConsignmentFinance> {
  late Query _ref;
  String? mtoken = "";
  CollectionReference reference =
  FirebaseFirestore.instance.collection('OrderB2B');
  List<String> filter = ["unpaid","paid"];
  String? selectedValue="unpaid";
  String search='';
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  User? user = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    _ref = FirebaseFirestore.instance.collection('OrderB2B').where('paymentStatus', isEqualTo: "unpaid");

  }

  Future<bool> getSwitch() async{
    String userid= user!.uid.toString();
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(userid).get();
    bool consignmentnotification = snap['consignmentnotification'];
    return consignmentnotification;
  }

  void updateSwitch(bool newValue) async {
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      'consignmentnotification': newValue,
    });

    if(newValue==true){
      await FirebaseMessaging.instance.subscribeToTopic("topicconsignment");
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic("topicconsignment");
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

  initInfo(){
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async{
      try{
        if(payload !=null && payload.isNotEmpty){

        } else{

        }
      } catch(e){

      }
      return;
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(".......onMessage.......");
      print("onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(message.notification!.body.toString(), htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(), htmlFormatContentTitle: true,);

      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('dbfood', 'dbfood', importance: Importance.high,
          styleInformation: bigTextStyleInformation, priority: Priority.high, playSound: true, groupKey: 'com.example.ftrsb_mobile');

      NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title, message.notification?.body, platformChannelSpecifics,
          //navigate second page - payload
          payload: message.data['title']);
    });
  }

  void sendPushMessage(String token, String body, String title) async {
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String,String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAquYJm3g:APA91bHUq0lYoo_IHhXkWn7xeIY4WkJbW_D9P3d0Kpkfv1kJDq50L8LOBHE4VSZkw03mk91ICY72-z8Mv8MoBmmJWPHlZJa8X6vDxXmOTkl4gWux9zhIJNtnUlOeZTiNrlye6OaXZTZS',
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data'  : <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },

            "notification" : <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "dbfood"
            },
            "to": "/topics/topicconsignment",
          },
        ),
      );
    } catch(e){
      if(kDebugMode){
        print("error push notification");
      }
    }

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



  Widget _buildVerifyItem({required Map verify}) {
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
              children: [
                Row(
                  children: [
                    Text('Customer Name: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        verify['custName'],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Amount: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      verify['amount'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Payment Collection Date: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        DateFormat('dd/MM/yyyy').format((verify['collectionDate']as Timestamp).toDate()).toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
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
                    Text('Address: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      verify['custAddress'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Phone: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      verify['custPhone'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('PIC: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      verify['pic'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Order Date: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format((verify['orderDate']as Timestamp).toDate()).toString(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Order ID: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      verify['orderID'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Payment Status: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      verify['paymentStatus'] ,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showActionDialog(verify: verify);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_note,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Change Payment Status',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
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

  _showActionDialog({required Map verify}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Order B2B from ${verify['custName']}'),
            content: Text('Payment Collected?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.grey),)),
              TextButton(
                  onPressed: () async {
                    await reference
                        .doc(verify['key']).update({
                      'paymentStatus' : 'unpaid',
                    }).whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('No', style: TextStyle(color: Colors.red),)),
              TextButton(
                  onPressed: () async {
                    await reference
                        .doc(verify['key']).update({
                      'paymentStatus' : 'paid',
                    }).whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Yes', style: TextStyle(color: Colors.green),)),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
  if (selectedValue == "paid") {
      _ref = FirebaseFirestore.instance.collection('OrderB2B').where('paymentStatus', isEqualTo: "paid").orderBy("custName").startAt([search])
          .endAt([search + '\uf8ff']);
      print(selectedValue);
    }
    else{
      _ref = FirebaseFirestore.instance.collection('OrderB2B').where('paymentStatus', isEqualTo: "unpaid").orderBy("custName").startAt([search])
          .endAt([search + '\uf8ff']);
      print(selectedValue);
    }
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text('Outright/Consignment'),
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
      body: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
            children: [
              Flexible(
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: TextField(
                    onChanged: (text){
                      setState(() {
                        search=text;
                      });
                    },
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                        fillColor: Colors.white30,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.teal)
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18
                        ),
                        prefixIcon: Icon(Icons.search)
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Text("Filter: ", style: TextStyle(fontWeight: FontWeight.bold, height: 0, fontSize: 16),),
                  DropdownButton(
                    value: selectedValue,
                    items: filter.map((item) => DropdownMenuItem<String>(value: item,child: Text(item))).toList(),
                    onChanged: (String? newValue){
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },

                  ),
                ],
              ),
            ],
          ),
          Flexible(
            child: FirestoreAnimatedList(
              query: _ref,
              itemBuilder: (BuildContext context, DocumentSnapshot? snapshot,
                  Animation<double> animation, int index) {
                Map<String, dynamic> verify = snapshot?.data() as Map<String, dynamic>;
                verify['key'] = snapshot?.id;
                return _buildVerifyItem(verify: verify);
              },
            ),
          )],
      ),

    );
  }


}