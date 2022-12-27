import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'view_paymentapproval.dart';

class EditPaymentApproval extends StatefulWidget {
  String paymentKey;

  EditPaymentApproval({required this.paymentKey});

  @override
  _EditPaymentApprovalState createState() => _EditPaymentApprovalState();
}

class _EditPaymentApprovalState extends State<EditPaymentApproval> {
  late TextEditingController _titleController, _accountholderController, _amountController, _effectivedateController, _ponumberController, _bankreferencenoController, _statusController;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  String? mtoken = "";
  User? user = FirebaseAuth.instance.currentUser;

  late DatabaseReference _ref;
  final _dropdownFormKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Approved"),value: "Approved"),
      DropdownMenuItem(child: Text("Rejected"),value: "Rejected"),
    ];
    return menuItems;
  }
  String? selectedValue = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _accountholderController = TextEditingController();
    _amountController = TextEditingController();
    _effectivedateController = TextEditingController();
    _ponumberController = TextEditingController();
    _bankreferencenoController = TextEditingController();
    _statusController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child('MakePayments');
    getPaymentDetail();
    requestPermission();
    getToken();
    initInfo();
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
            "to": "/topics/topicapprove",
          },
        ),
      );
    } catch(e){
      if(kDebugMode){
        print("error push notification");
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (_) => ViewPaymentApproval(
              paymentKey: widget.paymentKey,
            )), (route) => false);

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Update Payment'),
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter Title',
                    label: Text('Title'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _accountholderController,
                  decoration: InputDecoration(
                    hintText: 'Enter Account Holder (Recipient)',
                    label: Text('Account Holder (Recipient)'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    hintText: 'Enter Amount (RM)',
                    label: Text('Amount (RM)'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _effectivedateController,
                  decoration: InputDecoration(
                    hintText: 'Enter Effective Date',
                    label: Text('Effective Date'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _ponumberController,
                  decoration: InputDecoration(
                    hintText: 'Enter Purchase Order No.',
                    label: Text('Purchase Order No.'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _bankreferencenoController,
                  decoration: InputDecoration(
                    hintText: 'Enter Bank Reference No.',
                    label: Text('Bank Reference No.'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                Form(
                  key: _dropdownFormKey,
                  child: DropdownButtonFormField(
                      hint: Text("Choose status action"),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide( width: 2),//color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide( width: 2),//color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        //fillColor: Colors.blueAccent,
                      ),
                      validator: (value) => value == null ? "Select status action" : null,
                      //dropdownColor: Colors.blueAccent,
                      value: selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: dropdownItems),
                ),


                SizedBox(height: 25,),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(style: TextButton.styleFrom(backgroundColor: Theme.of(context).accentColor,),child: Text('Save',style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,

                  ),),
                    onPressed: () async{
                      if (_dropdownFormKey.currentState!.validate()) {
                        //valid flow
                        String userid= user!.uid.toString();
                      String titleText = _titleController.text;
                      String bodyText = "Transfer ${selectedValue} RM ${_amountController.text} to ${_accountholderController.text} \n(Reference Number: ${_bankreferencenoController.text})";
                      savePayment();
                      if(userid!=""){
                        DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(userid).get();
                        String token = snap['token'];
                        print(token);
                        sendPushMessage(token, bodyText, titleText);
                      }
                      }

                    },

                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  getPaymentDetail() async {
    DataSnapshot snapshot = (await _ref.child(widget.paymentKey).once()).snapshot;

    Map payment = snapshot.value as Map;

    _titleController.text = payment['title'];

    _accountholderController.text = payment['accountholder'];

    _amountController.text = payment['amount'];

    _effectivedateController.text = payment['effectivedate'];

    _ponumberController.text = payment['ponumber'];

    _bankreferencenoController.text = payment['bankreferenceno'];

    _statusController.text = payment['status'];

  }

  void savePayment() {
    String title = _titleController.text;
    String accountholder = _accountholderController.text;
    String amount = _amountController.text;
    String effectivedate = _effectivedateController.text;
    String ponumber = _ponumberController.text;
    String bankreferenceno = _bankreferencenoController.text;
    String status = selectedValue.toString();

    Map<String,String> payment = {
      'title':title,
      'accountholder':accountholder,
      'amount': amount,
      'effectivedate': effectivedate,
      'ponumber':ponumber,
      'bankreferenceno': bankreferenceno,
      'status':status,
    };

    _ref.child(widget.paymentKey).update(payment).then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ViewPaymentApproval(
                paymentKey: widget.paymentKey,
              )));
    });
  }
}