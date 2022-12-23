import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/screens/login_screen.dart';

class CustomAppBar extends StatelessWidget {
    
    String bartitle = '';

    CustomAppBar({required this.bartitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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