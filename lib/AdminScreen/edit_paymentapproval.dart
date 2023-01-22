import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../FinanceScreen/makepayment/view_payment.dart';
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
  final _formKey = GlobalKey<FormState>();
  DateTime? pickedDate;
  String? selectedValue = null;
  late CollectionReference _ref;
  var selectedCategory;
  String? selectedValue2 = null;
  String? selectedValue3 = null;
  DateTime dateselect = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Pending"),value: "Pending"),
      DropdownMenuItem(child: Text("Approved"),value: "Approved"),
      DropdownMenuItem(child: Text("Rejected"),value: "Rejected"),
    ];
    return menuItems;
  }
  List<DropdownMenuItem<String>> get dropdownItems2{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Online Banking"),value: "Online Banking"),
      DropdownMenuItem(child: Text("Credit/Debit"),value: "Credit/Debit"),
    ];
    return menuItems;
  }
  List<DropdownMenuItem<String>> get dropdownItems3{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Affin Bank"),value: "Affin Bank"),
      DropdownMenuItem(child: Text("Agrobank"),value: "Agrobank"),
      DropdownMenuItem(child: Text("Alliance Bank"),value: "Alliance Bank"),
      DropdownMenuItem(child: Text("Ambank"),value: "Ambank"),
      DropdownMenuItem(child: Text("Bank Islam"),value: "Bank Islam"),
      DropdownMenuItem(child: Text("Bank Muamalat"),value: "Bank Muamalat"),
      DropdownMenuItem(child: Text("Bank Rakyat"),value: "Bank Rakyat"),
      DropdownMenuItem(child: Text("BSN"),value: "BSN"),
      DropdownMenuItem(child: Text("CIMB"),value: "CIMB"),
      DropdownMenuItem(child: Text("Hong Leong"),value: "Hong Leong"),
      DropdownMenuItem(child: Text("HSBC"),value: "HSBC"),
      DropdownMenuItem(child: Text("Kuwait Finance House"),value: "Kuwait Finance House"),
      DropdownMenuItem(child: Text("Maybank2u"),value: "Maybank2u"),
      DropdownMenuItem(child: Text("OCBC"),value: "OCBC"),
      DropdownMenuItem(child: Text("Public Bank"),value: "Public Bank"),
      DropdownMenuItem(child: Text("RHB"),value: "RHB"),
      DropdownMenuItem(child: Text("Standard Chartered Bank"),value: "Standard Chartered Bank"),
      DropdownMenuItem(child: Text("UOB"),value: "UOB"),
    ];
    return menuItems;
  }

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
    _ref = FirebaseFirestore.instance.collection('MakePayments');
    getPaymentDetail();
    requestPermission();
    getToken();
    initInfo();
    initialize();
    initialize2();
  }
  void initialize() async{
    DocumentSnapshot snapshot = (await _ref.doc(widget.paymentKey).get());
    Map payment = snapshot.data() as Map;
    selectedValue = payment['status'];
    dateselect = DateFormat('dd/MM/yyyy').parse(payment['effectivedate']);

    CollectionReference checkexist = FirebaseFirestore.instance.collection('Category');
    QuerySnapshot _query = await checkexist
        .where('category', isEqualTo: payment['category']).get();
    if (_query.docs.length > 0) {
      selectedCategory = payment['category'];
    } else{
      selectedCategory = null;
    }
    setState(() {});
  }

  void initialize2() async{
    var document = await FirebaseFirestore.instance.collection('MakePayments').doc(widget.paymentKey).get();
    var myList = ["Online Banking", "Credit/Debit", "Cash"];
    if(myList.contains(document['paymenttype'].toString())){
      selectedValue2= document['paymenttype'];
    } else{
      selectedValue2= null;
    }

    var myList2 = ['Affin Bank',
      'Agrobank',
      'Alliance Bank',
      'Ambank',
      'Bank Islam',
      'Bank Muamalat',
      'Bank Rakyat',
      'BSN',
      'CIMB',
      'Hong Leong',
      'HSBC',
      'Kuwait Finance House',
      'Maybank2u',
      'OCBC',
      'Public Bank',
      'RHB',
      'Standard Chartered Bank',
      'UOB',];
    if(myList2.contains(document['bankname'].toString())){
      selectedValue3= document['bankname'];
    } else{
      selectedValue3= null;
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
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ViewPayment(
              paymentKey: widget.paymentKey,
            ),
          ));

        } else{
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ViewPayment(
              paymentKey: widget.paymentKey,
            ),
          ));

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
          styleInformation: bigTextStyleInformation, priority: Priority.high, playSound: true, setAsGroupSummary:true,groupKey: 'com.example.ftrsb_mobile');

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

  getPaymentDetail() async {
    DocumentSnapshot snapshot = (await _ref.doc(widget.paymentKey).get());
    Map payment = snapshot.data() as Map;

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
    String status = selectedValue!;
    String paymenttype = selectedValue2!;
    String bankname = selectedValue3!;
    String category = selectedCategory;

    Map<String,String> payment = {
      'title':title,
      'accountholder':accountholder,
      'amount': amount,
      'effectivedate': effectivedate,
      'ponumber':ponumber,
      'bankreferenceno': bankreferenceno,
      'status':status,
      'category': category,
      'paymenttype': paymenttype,
      'bankname': bankname,
    };

    _ref.doc(widget.paymentKey).update(payment).then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ViewPaymentApproval(
                paymentKey: widget.paymentKey,
              )));
    });
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{3,}$');
                      if (value!.isEmpty) {
                        return ("This field cannot be empty!");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter valid input!");
                      }
                      return null;
                    },
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Title'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{3,}$');
                      if (value!.isEmpty) {
                        return ("This field cannot be empty!");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter valid input!");
                      }
                      return null;
                    },
                    controller: _accountholderController,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                      label: Text('Account Holder/Recipient/Supplier'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      RegExp regex = RegExp(r'(\d+)');
                      if (value!.isEmpty) {
                        return ("This field cannot be empty!");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter valid amount!");
                      }
                      return null;
                    },
                    controller: _amountController,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                      label: Text('Amount (RM)'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                  SizedBox(height: 15),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("Category").snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const Text("Loading.....");
                        else {
                          List<DropdownMenuItem> categoryItems = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data!.docs[i];
                            categoryItems.add(
                              DropdownMenuItem(
                                child: Text(
                                  snap['category'],
                                ),
                                value: "${snap['category']}",
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: DropdownButtonFormField<dynamic>(
                                  validator: (value) => value == null ? "Select a category" : null,
                                  items: categoryItems,
                                  decoration: InputDecoration(border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: EdgeInsets.all(15),
                                  ),
                                  onChanged: (categoryValue) {
                                    setState(() {
                                      selectedCategory = categoryValue;
                                    });
                                  },
                                  value: selectedCategory,
                                  isExpanded: false,
                                  hint: new Text(
                                    "Choose Category",
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _effectivedateController,
                    autofocus: false,
                    readOnly: true,
                    validator: (value) {
                      RegExp regex = RegExp(r'(\d+)');
                      if (value!.isEmpty) {
                        return ("This field cannot be empty!");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter valid date!");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _effectivedateController.text = value!;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.green,
                      ),
                      label: Text('Effective Date'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    onTap: () async {
                      pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        String? formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate!);
                        setState(() {
                          _effectivedateController.text =
                              formattedDate;
                        });
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{3,}$');
                      if (value!.isEmpty) {
                        return ("This field cannot be empty!");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter valid input!");
                      }
                      return null;
                    },
                    controller: _ponumberController,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                      label: Text('Purchase Order No.'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField(
                      hint: Text("Payment Type"),
                      decoration: InputDecoration(border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                      ),
                      validator: (value) => value == null ? "Select payment type" : null,
                      value: selectedValue2,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue2 = newValue!;
                        });
                      },
                      items: dropdownItems2),
                  SizedBox(height: 15),
                  DropdownButtonFormField(
                      hint: Text("Bank Name"),
                      decoration: InputDecoration(border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                      ),
                      validator: (value) => value == null ? "Select Bank Name" : null,
                      value: selectedValue3,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue3 = newValue!;
                        });
                      },
                      items: dropdownItems3),
                  SizedBox(height: 15),
                  TextFormField(
                    //enabled: false,
                    controller: _bankreferencenoController,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                      label: Text('Bank Reference No.'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField(
                      hint: Text("Status"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                      ),
                      validator: (value) => value == null ? "Select status" : null,

                      value: selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: dropdownItems),


                  SizedBox(height: 25,),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(style: TextButton.styleFrom(backgroundColor: Theme.of(context).accentColor,),child: Text('Save',style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,


                    ),),
                      onPressed: ()async {
                        if(_formKey.currentState!.validate()){
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
      ),
    );
  }


}