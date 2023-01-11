import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ftrsb_mobile/AdminScreen/home_admin.dart';
import 'package:ftrsb_mobile/FinanceScreen/home_finance.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';
import 'package:ftrsb_mobile/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../screens/login_screen.dart';
import 'model/user_model.dart';
import 'package:ftrsb_mobile/WarehouseScreen/nav.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

    setState(() {});
  }

  Future<UserModel?> getUserModel() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    return UserModel.fromMap(snapshot.data());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Email And Password Login',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        debugShowCheckedModeBanner: false,

        //keep user loggedin
        //login based on role
        home: (FirebaseAuth.instance.currentUser?.uid == null)
            ? LoginScreen()
            : FutureProvider<UserModel?>.value(
                value: getUserModel(),
                initialData: null,
                builder: (context, child) {
                  UserModel? user = Provider.of<UserModel?>(context);

                  if (user == null) {
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: SpinKitPulse(
                        color: Color.fromARGB(255, 160, 202, 159),
                      ),
                    );
                  }

                  log('not null');

                  return (loggedInUser.role == "Finance")
                      ? HomeScreenFinance()
                      : (loggedInUser.role == "Sales & Marketing")
                          ? HomeScreenSales()
                          : (loggedInUser.role == "Warehouse")
                              ? WarehouseNav()
                              : (loggedInUser.role == "Admin")
                                  ? HomeScreenAdmin()
                                  : HomeScreen();
                },
              )
        //value: (FirebaseAuth.instance.currentUser?.uid == null) ? LoginScreen(): (loggedInUser.role="Finance") ? HomeScreenFinance() : HomeScreen()
        );
  }
}
