import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/AdminScreen/home_admin.dart';
import 'package:ftrsb_mobile/SalesScreen/channel/list_channel.dart';
import 'package:ftrsb_mobile/SalesScreen/prospect/add_prospect.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/distrChannelList.dart';
import 'package:ftrsb_mobile/SalesScreen/import_export_csv/selectfilemenu.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/SalesScreen/channel/add_channel.dart';
import 'package:ftrsb_mobile/SalesScreen/prospect/distrchannellist.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';
import '../screens/login_screen.dart';
import '../model/user_model.dart';
import 'order/order_history.dart';

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
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        this.loggedInUser = UserModel.fromMap(value.data());
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //buildHeader(context),
              SizedBox(
                height: 60,
              ),
              buildMenuItems(context, loggedInUser),
            ],
          ),
        ),
      );
}

Widget buildMenuItems(BuildContext context, UserModel loggedInUser) =>
    Container(
      padding: const EdgeInsets.all(18),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              (loggedInUser.role == "Admin")
                  ? Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            HomeScreenAdmin(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    )
                  : Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            HomeScreenSales(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
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
                builder: (context) => DistrChannelListProspect(),
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
          Column(
            children: [
              if (loggedInUser.role == "Admin") ...[
                ListTile(
                  leading: const Icon(Icons.outbox_rounded),
                  title: const Text('Channel'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const ListChannel(),
                    ));
                  },
                )
              ]
            ],
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Order History'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => OrderHistory(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.import_export_rounded),
            title: const Text('Import/Export CSV'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => CSVMenu(),
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
