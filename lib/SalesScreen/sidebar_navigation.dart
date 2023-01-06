import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/add_prospect.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/distrChannelList.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/SalesScreen/order/orderSummaryb2b.dart';
import 'package:ftrsb_mobile/SalesScreen/order/orderSummaryb2c.dart';
import 'package:ftrsb_mobile/SalesScreen/order/payment_details_b2b.dart';
import 'package:ftrsb_mobile/SalesScreen/order/payment_details_b2c.dart';
import 'package:ftrsb_mobile/SalesScreen/order/product_details.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_dashboard.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';
import '../screens/login_screen.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //buildHeader(context),
              SizedBox(
                height: 40,
              ),
              buildMenuItems(context),
            ],
          ),
        ),
      );
}

/*Widget buildHeader(BuildContext context) => 
Container(
  color: Colors.white,
  padding: EdgeInsets.only(
    top: MediaQuery.of(context).padding.top,
  ),
  child: Column(
    children: [
      SizedBox(height: 10,),
      Text('',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
      SizedBox(height: 23,),
    ],
  ),
);*/

Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(18),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const HomeScreenSales(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const SalesDashboard(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Submit New Order'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const CustomerDetailsForm(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add_rounded),
            title: const Text('Prospect'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ProspectDetailsForm(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Customer'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const DistrChannelList(),
              ));
            },
          ),
          Divider(
            color: Colors.black54,
            thickness: 0.6,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
