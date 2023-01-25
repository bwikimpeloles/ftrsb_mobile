import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftrsb_mobile/FinanceScreen/LowStock/low_stock.dart';
import 'package:ftrsb_mobile/FinanceScreen/consignment/consignment.dart';
import 'package:ftrsb_mobile/FinanceScreen/cost/cost.dart';
import 'package:ftrsb_mobile/FinanceScreen/makepayment/make_payment.dart';
import 'package:ftrsb_mobile/FinanceScreen/verifypayment/payment_verification.dart';
import 'package:ftrsb_mobile/FinanceScreen/revenue/revenue.dart';
import 'package:ftrsb_mobile/FinanceScreen/supplier/supplier_information.dart';
import 'package:ftrsb_mobile/screens/verify_email.dart';
import 'sidebar_navigation.dart';
import '../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class HomeScreenFinance extends StatefulWidget {
  const HomeScreenFinance({Key? key}) : super(key: key);

  @override
  _HomeScreenFinanceState createState() => _HomeScreenFinanceState();
}

class _HomeScreenFinanceState extends State<HomeScreenFinance> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String? mtoken = "";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: NavigationDrawer(),
      appBar: AppBar(
        //title: const Text("Welcome - Finance"),
        backgroundColor: Colors.grey.shade100,
        iconTheme: IconThemeData(color: Colors.green.shade700),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient:LinearGradient(
                      colors: [
                        Colors.green.shade700,
                        Colors.green,
                        Colors.lime,
                        Colors.yellow,
                        //add more colors for gradient
                      ],
                      begin: Alignment.topLeft, //begin of the gradient color
                      end: Alignment.bottomRight, //end of the gradient color
                      stops: [0, 0.3, 0.6, 0.8] //stops for individual color
                    //set the stops number equal to numbers of color
                  ),

                  borderRadius: BorderRadius.circular(20), //border corner radius

                ),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    SizedBox(
                      height: 60,
                      child: Image.asset("assets/logo.png", fit: BoxFit.contain),
                    ),
                    SizedBox(width: 15,),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: Text(
                              "Hi ${loggedInUser.name}!",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),

                          Flexible(
                            child: Text("${loggedInUser.email}",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Flexible(
                child: Text(
                  "What would you like to do?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: GridView.count(
                  //padding: EdgeInsets.all(5),
                  //shrinkWrap: true,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  crossAxisCount: 3,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RevenueFinance(),
                              ));
                        },
                        splashColor: Colors.green,
                        child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bar_chart,
                                  size: 40,
                                  color: Colors.green.shade400,
                                ),
                                Text(
                                  "Check Revenue",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 27, 73, 29)),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CostFinance(),
                              ));
                        },
                        splashColor: Colors.green,
                        child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.pie_chart,
                                  size: 40,
                                  color: Colors.green.shade400,
                                ),
                                Text(
                                  "View Expenses",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 27, 73, 29)),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConsignmentFinance(),
                              ));
                        },
                        splashColor: Colors.green,
                        child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.business_center,
                                  size: 40,
                                  color: Colors.green.shade400,
                                ),
                                Text(
                                  "View Outright & Consignment Order",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 27, 73, 29)),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentVerificationFinance(),
                              ));
                        },
                        splashColor: Colors.green,
                        child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.domain_verification,
                                  size: 40,
                                  color: Colors.green.shade400,
                                ),
                                Text(
                                  "Verify Order",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 27, 73, 29)),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                 MakePaymentFinance(),
                              ));
                        },
                        splashColor: Colors.green,
                        child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_box_rounded,
                                  size: 40,
                                  color: Colors.green.shade400,
                                ),
                                Text(
                                  "Make Transaction",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 27, 73, 29)),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LowStock(),
                              ));
                        },
                        splashColor: Colors.green,
                        child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_alert,
                                  size: 40,
                                  color: Colors.green.shade400,
                                ),
                                Text(
                                  "Check Low Stock Alert",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 27, 73, 29)),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Text(''),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SupplierInformationFinance(),
                              ));
                        },
                        splashColor: Colors.green,
                        child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.airport_shuttle,
                                  size: 40,
                                  color: Colors.green.shade400,
                                ),
                                Text(
                                  "View Supplier Information",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 27, 73, 29)),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Text(''),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ActionChip(
                  label: Text("Logout"),
                  onPressed: () {
                    logout(context);
                  }),
            ],
          ),
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

