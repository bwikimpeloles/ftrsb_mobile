import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../sidebar_navigation.dart';

class ConsignmentFinance extends StatefulWidget {
  @override
  _ConsignmentFinanceState createState() => _ConsignmentFinanceState();
}

class _ConsignmentFinanceState extends State<ConsignmentFinance> {
  TextEditingController actualamount = TextEditingController();
  late Query _ref;
  String? mtoken = "";
  CollectionReference reference =
  FirebaseFirestore.instance.collection('OrderB2B');
  List<String> filter = ["unpaid","paid"];
  List<String> filter2 = ["Consignment","Outright","COD"];
  String? selectedValue="unpaid";
  String? selectedValue2="Consignment";
  String search='';
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  User? user = FirebaseAuth.instance.currentUser;
  late DateTime scheduleDate;
  String token1='';
  bool agree=false;
  late DateTime? dateselect = new DateTime.now();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    _ref = FirebaseFirestore.instance.collection('OrderB2B').where('paymentStatus', isEqualTo: "unpaid");
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("@mipmap/ic_launcher");
    const IOSInitializationSettings iosInitializationSettings =
    IOSInitializationSettings();
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
      macOS: null,
      linux: null,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (dataYouNeedToUseWhenNotificationIsClicked) {},
    );
  }

  Future<bool> getSwitch() async{
    String userid= user!.uid.toString();
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(userid).get();
    bool consignmentnotification = snap['consignmentnotification'];
    token1 = snap['token'];
    agree = snap['consignmentnotification'];
    print(agree);
    return consignmentnotification;
  }

  void updateSwitch(bool newValue) async {
    final String currentTimeZone =  await FlutterNativeTimezone.getLocalTimezone();
    print(currentTimeZone);
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      'consignmentnotification': newValue,
    });

    if(newValue==true){
      await FirebaseMessaging.instance.subscribeToTopic("topicconsignment");
      setState(() {

      });
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic("topicconsignment");
      await flutterLocalNotificationsPlugin.cancelAll();
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

  showNotification(int nom,String title, String body) {
    tz.initializeTimeZones();
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(scheduleDate, tz.local);
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      "ScheduleNotification001",
      "Notify Me",
      importance: Importance.high,
    );

    const IOSNotificationDetails iosNotificationDetails =
    IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      macOS: null,
      linux: null,
    );

    flutterLocalNotificationsPlugin.zonedSchedule(
        nom, title, body, scheduledAt, notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true,
        payload: 'This is the data');
    print('there is notification on ${scheduleDate}');
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

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<DateTime?> pickDate() =>
    showDatePicker(
        context: context,
        initialDate: dateselect!,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() =>
      showTimePicker(
          context: context,
          initialTime: TimeOfDay(
              hour: dateselect!.hour,
              minute: dateselect!.minute));

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateselect = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      this.dateselect=dateselect;
    });
  }

  _showActionDialog({required Map verify}) async{
    actualamount.text = verify['amount'];
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Payment from ${verify['custName']} has been collected?'),
            content: Form(
              key: _formKey,
              child: TextFormField(
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
                controller: actualamount,
                decoration: InputDecoration(
                  label: Text('Actual Amount Collected (RM)'),
                  hintText: 'Enter Actual Amount Collected(RM)',
                  fillColor: Colors.white,
                ),
              ),
            ),
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
                    if (_formKey.currentState!.validate()) {
                      //valid flow
                      await reference
                          .doc(verify['key']).update({
                        'amount': actualamount.text,
                        'paymentStatus' : 'paid',
                      }).whenComplete(() => Navigator.pop(context));
                    }

                  },
                  child: Text('Yes', style: TextStyle(color: Colors.green),)),
            ],
          );
        });
  }

  Widget _buildVerifyItem({required Map verify}) {
    print(agree);

    scheduleDate = (verify['collectionDate'] as Timestamp).toDate();
    if(verify['paymentStatus'] == 'unpaid' && agree==true && scheduleDate.isAfter(DateTime.now())){

      print(scheduleDate);
      String userid= user!.uid.toString();
      String titleText = "Payment Collection Reminder";
      String bodyText = "Collect from ${verify['custName']} RM ${verify['amount']} \n(Collection Date: ${DateFormat('dd/MM/yyyy').format((verify['orderDate']as Timestamp).toDate()).toString()})";
      if(userid!=""){
        print(token1);
        //print(verify['custPhone'].toString().substring(0,8));
        if (int.parse(verify['custPhone']) > 2147483647){
          showNotification(int.parse(verify['custPhone'].toString().substring(0,8)), titleText, bodyText);
        } else {
          showNotification(int.parse(verify['custPhone']), titleText, bodyText);
        }
      }
    }

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
                (verify['paymentStatus'] == 'unpaid')?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('COLLECT IN ${(daysBetween(DateTime.now(), (verify['collectionDate']as Timestamp).toDate())).toString()} DAYS',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.w800),),
                  ],):Text(''),

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
                    Text('Amount: RM',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        verify['amount'],
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
                    Text('Payment Collection Date: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        DateFormat('dd/MM/yyyy hh:mma').format(scheduleDate),
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
                    Flexible(
                      child: Text(
                        verify['custAddress'],
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
                    Text('Phone: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        verify['custPhone'],
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
                    Text('PIC: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        verify['pic'],
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
                    Text('Order Date: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        DateFormat('dd/MM/yyyy').format((verify['orderDate']as Timestamp).toDate()).toString(),
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
                    Text('Order ID: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        verify['orderID'],
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
                    Text('Purchase Type: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        verify['purchaseType'],
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
                    Text('Payment Status: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        verify['paymentStatus'] ,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        dateselect = (verify['collectionDate'] as Timestamp).toDate();
                        await pickDateTime();
                        print('This is ${dateselect}');
                        await reference
                            .doc(verify['key']).update({
                          'collectionDate' : dateselect,
                        }).whenComplete(() => setState(() {}));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Theme.of(context).primaryColor,
                            size: 16,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Change Collection Date',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(width: 20,),
                    GestureDetector(
                      onTap: () {
                        _showActionDialog(verify: verify);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_note,
                            color: Theme.of(context).primaryColor,
                            size: 16,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Update Status',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
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

  @override
  Widget build(BuildContext context) {
  if (selectedValue == "paid" && selectedValue2 == "Outright") {
      _ref = FirebaseFirestore.instance.collection('OrderB2B').where('paymentStatus', isEqualTo: "paid").where('purchaseType', isEqualTo: "Outright").orderBy('orderID').startAt([search])
          .endAt([search + '\uf8ff']);
      print(selectedValue);
    } else if (selectedValue == "paid" && selectedValue2 == "COD") {
    _ref = FirebaseFirestore.instance.collection('OrderB2B').where('paymentStatus', isEqualTo: "paid").where('purchaseType', isEqualTo: "COD").orderBy('orderID').startAt([search])
        .endAt([search + '\uf8ff']);
    print(selectedValue);
  } else if (selectedValue == "paid" && selectedValue2 == "Consignment") {
    _ref = FirebaseFirestore.instance.collection('OrderB2B').where('paymentStatus', isEqualTo: "paid").where('purchaseType', isEqualTo: "Consignment").orderBy('orderID').startAt([search])
        .endAt([search + '\uf8ff']);
    print(selectedValue);
  }
  else if(selectedValue == "unpaid" && selectedValue2 == "Outright"){
  _ref = FirebaseFirestore.instance.collection('OrderB2B').where('paymentStatus', isEqualTo: "unpaid").where('purchaseType', isEqualTo: "Outright").orderBy('orderID').startAt([search])
        .endAt([search + '\uf8ff']);
    print(selectedValue);
    }
  else if (selectedValue == "unpaid" && selectedValue2 == "COD"){
  _ref = FirebaseFirestore.instance.collection('OrderB2B').where('paymentStatus', isEqualTo: "unpaid").where('purchaseType', isEqualTo: "COD").orderBy('orderID').startAt([search])
        .endAt([search + '\uf8ff']);
    print(selectedValue);
    }
    else{
      _ref = FirebaseFirestore.instance.collection('OrderB2B').where('paymentStatus', isEqualTo: "unpaid").where('purchaseType', isEqualTo: "Consignment").orderBy('orderID').startAt([search])
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
                  width: 150,
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
                        hintText: 'Order ID',
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
                  Text("Status: ", style: TextStyle(fontWeight: FontWeight.bold, height: 0, fontSize: 16),),
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
              Stack(
                children: [
                  Text("Type: ", style: TextStyle(fontWeight: FontWeight.bold, height: 0, fontSize: 16),),
                  DropdownButton(
                    value: selectedValue2,
                    items: filter2.map((item) => DropdownMenuItem<String>(value: item,child: Text(item))).toList(),
                    onChanged: (String? newValue){
                      setState(() {
                        selectedValue2 = newValue!;
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