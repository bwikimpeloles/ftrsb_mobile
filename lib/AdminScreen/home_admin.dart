import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ftrsb_mobile/AdminScreen/paymentapproval.dart';
import 'package:ftrsb_mobile/FinanceScreen/home_finance.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';
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
      'token' : token,
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome - Admin"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 90,
                child: Image.asset("assets/logo.png", fit: BoxFit.contain),
              ),
              Text(
                "Welcome Back",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text("${loggedInUser.name}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              Text("${loggedInUser.email}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //warehouse button
                      SizedBox(
                        height: 100,
                        width: 150,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          onPressed: () {},
                          child: const Text('WAREHOUSE', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      SizedBox(width: 20,),

                      //sales & marketing button button
                      SizedBox(
                        height: 100,
                        width: 150,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => const HomeScreenSales(),));
                          },
                          child: const Text('SALES \n&\nMARKETING', style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,),
                        ),
                      ),

                    ],),

                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //finance button
                    SizedBox(
                      height: 100,
                      width: 150,
                      child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const HomeScreenFinance(),));
                      },
                      child: const Text('FINANCE', style: TextStyle(color: Colors.white),),
                  ),
                    ),
                      SizedBox(width: 20,),

                      //employee accounts button
                      SizedBox(
                        height: 100,
                        width: 150,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.purple,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          onPressed: () {},
                          child: const Text('EMPLOYEE \nACCOUNTS', style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,),
                        ),
                      ),

                  ],),
                  SizedBox(height: 20,),
                  SizedBox(
                    height: 100,
                    width: 150,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.brown,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const PaymentApprovalAdmin(),));
                      },
                      child: const Text('TRANSACTION \n APPROVAL', style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              ActionChip(
                  label: Text("Logout"),
                  onPressed: () {
                    logout(context);
                  }),
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
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}