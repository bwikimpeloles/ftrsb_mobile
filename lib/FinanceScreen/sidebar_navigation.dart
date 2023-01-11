import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/FinanceScreen/consignment.dart';
import 'package:ftrsb_mobile/FinanceScreen/cost.dart';
import 'package:ftrsb_mobile/FinanceScreen/cost/list_cost.dart';
import 'package:ftrsb_mobile/FinanceScreen/home_finance.dart';
import 'package:ftrsb_mobile/FinanceScreen/make_payment.dart';
import 'package:ftrsb_mobile/FinanceScreen/payment_verification.dart';
import 'package:ftrsb_mobile/FinanceScreen/revenue/revenue.dart';
import 'package:ftrsb_mobile/FinanceScreen/supplier/photo_page.dart';
import 'package:ftrsb_mobile/FinanceScreen/supplier_information.dart';
import '../AdminScreen/home_admin.dart';
import '../model/user_model.dart';
import '../screens/login_screen.dart';


class NavigationDrawer extends StatefulWidget {

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void initState() {
    super.initState();
    if(FirebaseAuth.instance.currentUser?.uid != null){    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });}

  }

  @override
  Widget build(BuildContext context) =>
      Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context, loggedInUser),
            ],
          ),
        ),
      );
}

Widget buildHeader(BuildContext context) => Container(
  color: Colors.green,
  padding: EdgeInsets.only(
    top: MediaQuery.of(context).padding.top,
  ),
  child: Column(
    children: [
      SizedBox(height: 10,),
      Text('Menu',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
      SizedBox(height: 23,),
    ],
  ),
);
Widget buildMenuItems(BuildContext context, UserModel loggedInUser) => Container(
  padding: const EdgeInsets.all(18),
  child:   Wrap(
    runSpacing: 16,
    children: [
      ListTile(leading: const Icon(Icons.home),
        title: const Text('Home'),
        onTap: (){
          (loggedInUser.role=="Admin") ? Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => HomeScreenAdmin(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          ) :
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => HomeScreenFinance(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );


        },),
      ListTile(leading: const Icon(Icons.bar_chart),
        title: const Text('Revenue'),
        onTap: (){
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => RevenueFinance(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },),
      ListTile(leading: const Icon(Icons.pie_chart),
        title: const Text('Cost'),
        onTap: (){
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => CostFinance(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },),
      ListTile(leading: const Icon(Icons.business_center),
        title: const Text('Outright & Consignment Order'),
        onTap: (){
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => ConsignmentFinance(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );

        },),
      ListTile(leading: const Icon(Icons.domain_verification),
        title: const Text('Payment Verification'),
        onTap: (){
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => PaymentVerificationFinance(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },),
      ListTile(leading: const Icon(Icons.monetization_on),
        title: const Text('Make Payment'),
        onTap: (){
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => MakePaymentFinance(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );

        },),
      ListTile(leading: const Icon(Icons.add_alert),
        title: const Text('Stock Alert'),
        onTap: (){


        },),
      ListTile(leading: const Icon(Icons.airport_shuttle),
        title: const Text('Supplier Information'),
        onTap: (){
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => SupplierInformationFinance(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );

        },),

      Divider(color: Colors.black54,thickness: 0.6,),
      ListTile(leading: const Icon(Icons.logout),
        title: const Text('Log Out'),
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));

        },),
    ],
  ),
);

