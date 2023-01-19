import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ftrsb_mobile/SalesScreen/Dashboard/insightmonthb2b.dart';
import 'package:ftrsb_mobile/SalesScreen/Dashboard/salesbreakdownb2b1.dart';
import 'package:ftrsb_mobile/SalesScreen/Dashboard/salesbreakdownb2b2.dart';
import 'package:ftrsb_mobile/SalesScreen/Dashboard/salesbreakdownb2b3.dart';
import 'package:ftrsb_mobile/SalesScreen/Dashboard/salesbreakdownb2b4.dart';
import 'package:ftrsb_mobile/SalesScreen/Dashboard/top_channel_b2b.dart';
import 'package:ftrsb_mobile/SalesScreen/Dashboard/total_sales.dart';
import 'package:ftrsb_mobile/SalesScreen/nav_bar_home.dart';
import 'sidebar_navigation.dart';
import '../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class HomeScreenSales2 extends StatefulWidget {
  const HomeScreenSales2({Key? key}) : super(key: key);

  @override
  _HomeScreenSales2State createState() => _HomeScreenSales2State();
}

class _HomeScreenSales2State extends State<HomeScreenSales2> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  late String? selectedValue = 'Today';

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
  }

  @override
  Widget build(BuildContext context) {
    final tabbar = DefaultTabController(
        length: 4,
        child: ButtonsTabBar(
          onTap: (p0) {
            if (p0 == 0) {
              setState(() {
                selectedValue = 'Today';
              });
            }
            if (p0 == 1) {
              setState(() {
                selectedValue = 'This Week';
              });
            }
            if (p0 == 2) {
              setState(() {
                selectedValue = 'This Month';
              });
            }
            if (p0 == 3) {
              setState(() {
                selectedValue = 'This Year';
              });
            }
          },
          backgroundColor: Colors.green,
          unselectedBackgroundColor: Colors.grey[300],
          unselectedLabelStyle:
              TextStyle(color: Color.fromARGB(255, 57, 129, 59)),
          labelStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          tabs: [
            Tab(
              text: "  Today  ",
            ),
            Tab(
              text: "  Last 7 Days  ",
            ),
            Tab(text: '  This Month  '),
            Tab(text: '  This Year  '),
          ],
        ));

    return Scaffold(
      //backgroundColor: Colors.transparent,
      drawer: NavigationDrawer(),
      bottomNavigationBar: CurvedNavBar2(indexnum: 1),
      appBar: PreferredSize(
          child: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    logout(context);
                  },
                  icon: Icon(Icons.logout_outlined, size: 25))
            ],
            title: Image.asset(
              "assets/logo.png",
              fit: BoxFit.contain,
              height: 45,
            ),
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
          ),
          preferredSize: Size.fromHeight(65)),

      //bottomNavigationBar: CurvedNavBar(indexnum: 0,),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hi, " + "${loggedInUser.name} !",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
              tabbar,
              SizedBox(height: 14),
              TotalSales(
                selectedValue: selectedValue,
              ),
              SizedBox(height: 14),
              Column(
                children: [                
                  if (selectedValue == 'This Year') ...[
                    InsightMonthB2B(),
                    SizedBox(height: 20),
                  ],
                ],
              ),
              

              TopChannelB2B(
                selectedValue: selectedValue,
              ),
              SizedBox(height: 20),
               Column(
                children: [
                  if (selectedValue == 'Today') ...[
                    SalesBreakdownB2B1(),
                  ],
                  if (selectedValue == 'This Week') ...[
                    SalesBreakdownB2B2(),
                  ],
                  if (selectedValue == 'This Month') ...[
                    SalesBreakdownB2B3(),
                  ],
                  if (selectedValue == 'This Year') ...[
                    SalesBreakdownB2B4(),
                  ],
                ],),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
