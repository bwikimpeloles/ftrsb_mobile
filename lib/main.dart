import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ftrsb_mobile/AdminScreen/home_admin.dart';
import 'package:ftrsb_mobile/FinanceScreen/home_finance.dart';
import 'package:ftrsb_mobile/screens/home_screen.dart';
import '../screens/login_screen.dart';
import 'model/user_model.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    if(FirebaseAuth.instance.currentUser?.uid != null){    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });}

    setState(() {});
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
      home: (FirebaseAuth.instance.currentUser?.uid == null) ?
      LoginScreen() : (loggedInUser.role=="Finance") ? HomeScreenFinance() : (loggedInUser.role=="Admin") ? HomeScreenAdmin() : HomeScreen(),
      //value: (FirebaseAuth.instance.currentUser?.uid == null) ? LoginScreen(): (loggedInUser.role="Finance") ? HomeScreenFinance() : HomeScreen()
    );
  }
}
