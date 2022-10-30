import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/FinanceScreen/home_finance.dart';
import 'package:ftrsb_mobile/FinanceScreen/supplier_information.dart';
import '../screens/login_screen.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
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
Widget buildMenuItems(BuildContext context) => Container(
  padding: const EdgeInsets.all(18),
  child:   Wrap(
    runSpacing: 16,
    children: [
      ListTile(leading: const Icon(Icons.home),
        title: const Text('Home'),
        onTap: (){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreenFinance(),));
        },),
      ListTile(leading: const Icon(Icons.bar_chart),
        title: const Text('Revenue'),
        onTap: (){

        },),
      ListTile(leading: const Icon(Icons.pie_chart),
        title: const Text('Cost'),
        onTap: (){

        },),
      ListTile(leading: const Icon(Icons.business_center),
        title: const Text('Outright & Consignment Order'),
        onTap: (){

        },),
      ListTile(leading: const Icon(Icons.domain_verification),
        title: const Text('Payment Verification'),
        onTap: (){

        },),
      ListTile(leading: const Icon(Icons.monetization_on),
        title: const Text('Make Payment'),
        onTap: (){

        },),
      ListTile(leading: const Icon(Icons.add_alert),
        title: const Text('Stock Alert'),
        onTap: (){

        },),
      ListTile(leading: const Icon(Icons.airport_shuttle),
        title: const Text('Supplier Information'),
        onTap: (){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SupplierInformationFinance(),));

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

