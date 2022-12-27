import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/AdminScreen/home_admin.dart';
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
        title: const Text('Admin Home'),
        onTap: (){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreenAdmin(),));
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

