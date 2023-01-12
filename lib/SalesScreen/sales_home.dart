import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ftrsb_mobile/SalesScreen/Dashboard/linechartday.dart';
import 'package:ftrsb_mobile/SalesScreen/Dashboard/linechartmonth.dart';
import 'package:ftrsb_mobile/SalesScreen/Dashboard/linechartweek.dart';
import 'package:ftrsb_mobile/SalesScreen/Dashboard/top_channel_b2b.dart';
import 'package:ftrsb_mobile/SalesScreen/Dashboard/top_channel_b2c.dart';
import 'sidebar_navigation.dart';
import '../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class HomeScreenSales extends StatefulWidget {
  const HomeScreenSales({Key? key}) : super(key: key);

  @override
  _HomeScreenSalesState createState() => _HomeScreenSalesState();
}

class _HomeScreenSalesState extends State<HomeScreenSales> {
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
    final buttons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: const Size(110, 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text('Today'),
            onPressed: () {
              setState(() {
                selectedValue = 'Today';
              });
            }),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: const Size(110, 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text('This Week'),
            onPressed: () {
              setState(() {
                selectedValue = 'This Week';
              });
            }),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: const Size(110, 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text('This Month'),
            onPressed: () {
              setState(() {
                selectedValue = 'This Month';
              });
            }),
      ],
    );

    return Scaffold(
      //backgroundColor: Colors.transparent,
      drawer: NavigationDrawer(),
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
              buttons,
              SizedBox(height: 20),
              Column(
                children: [
                  if (selectedValue == 'Today') ...[
                    LineChartDay(),
                  ],
                  if (selectedValue == 'This Week') ...[
                    LineChartWeek(),
                  ],
                  if (selectedValue == 'This Month') ...[
                    LineChartMonth(),
                  ],
                ],
              ),
              SizedBox(height: 20),
              TopChannelB2C(
                selectedValue: selectedValue,
              ),
              SizedBox(height: 20),
              TopChannelB2B(
                selectedValue: selectedValue,
              ),
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
