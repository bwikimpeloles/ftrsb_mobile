import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ftrsb_mobile/AdminScreen/paymentapproval.dart';
import 'package:ftrsb_mobile/AdminScreen/user_list.dart';
import 'package:ftrsb_mobile/FinanceScreen/home_finance.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';
import 'package:ftrsb_mobile/WarehouseScreen/nav.dart';
import '../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  _HomeScreenAdminState createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
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
      'token': token,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome - Admin"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(Icons.logout_outlined, size: 25))
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 154, 255, 157).withOpacity(0.5),borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 90,
                      child:
                          Image.asset("assets/logo.png", fit: BoxFit.contain),
                    ),
                    Text(
                      "Welcome Back",
                      style:
                          TextStyle(color: Colors.green[800],fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${loggedInUser.name}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 27, 73, 29),
                          fontWeight: FontWeight.w500,
                        )),
                    Text("${loggedInUser.email}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 27, 73, 29),
                          fontWeight: FontWeight.w500,
                        )),
                        SizedBox(
                height: 10,
              ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,),
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(5),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: [
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WarehouseNav(),
                              ));
                        },
                        splashColor: Colors.green,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warehouse_rounded,
                              size: 55,
                              color: Colors.green,
                            ),
                            Text(
                              "WAREHOUSE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 27, 73, 29)),
                            ),
                          ],
                        )),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreenSales(),
                              ));
                        },
                        splashColor: Colors.green,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sell_rounded,
                              size: 55,
                              color: Colors.green,
                            ),
                            Text(
                              "SALES AND MARKETING",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 27, 73, 29)),
                            ),
                          ],
                        )),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreenFinance(),
                              ));
                        },
                        splashColor: Colors.green,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.monetization_on,
                              size: 55,
                              color: Colors.green,
                            ),
                            Text(
                              "FINANCE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 27, 73, 29)),
                            ),
                          ],
                        )),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserList(),
                              ));
                        },
                        splashColor: Colors.green,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_rounded,
                              size: 55,
                              color: Colors.green,
                            ),
                            Text(
                              "HR MANAGEMENT",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 27, 73, 29)),
                            ),
                          ],
                        )),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PaymentApprovalAdmin(),
                              ));
                        },
                        splashColor: Colors.green,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_box_rounded,
                              size: 55,
                              color: Colors.green,
                            ),
                            Text(
                              "TRANSACTION APPROVAL",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 27, 73, 29)),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
              ),
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
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
