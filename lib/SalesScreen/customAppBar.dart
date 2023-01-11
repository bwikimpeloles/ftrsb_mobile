import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';
import 'package:ftrsb_mobile/screens/login_screen.dart';

class CustomAppBar extends StatelessWidget {
  String bartitle = '';
  //String backpath = '';

  CustomAppBar({required this.bartitle,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          if (bartitle == 'Add Customer Information' || bartitle == 'Add Prospect' || bartitle == 'Customer'|| bartitle == 'Order History') {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreenSales()));
          } else {
            Navigator.pop(context);
          }
        },
      ),
      actions: [
        IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout_outlined, size: 25))
      ],
      title: Text(bartitle),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 103, 206, 113),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
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
