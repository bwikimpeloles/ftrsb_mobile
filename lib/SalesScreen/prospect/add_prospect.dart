import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';
import 'package:intl/intl.dart';

class ProspectDetailsForm extends StatefulWidget {
  String channel;
  ProspectDetailsForm({Key? key, required this.channel}) : super(key: key);

  @override
  State<ProspectDetailsForm> createState() => _ProspectDetailsFormState();
}

class _ProspectDetailsFormState extends State<ProspectDetailsForm> {
  // form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final nameEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();
  final emailEditingController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  late String? _channeltype;
  late String? _verify;

  @override
  Widget build(BuildContext context) {
    //name field
    final nameField = TextFormField(
        autofocus: false,
        controller: nameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          nameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.account_circle,
            color: Colors.green,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Customer/Company Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //phone field
    final phoneField = TextFormField(
        autofocus: false,
        controller: phoneEditingController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          RegExp regex = RegExp(r'(\d+)');
          if (value!.isEmpty) {
            return ("Phone number cannot be empty!");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter valid phone number!");
          }
          return null;
        },
        onSaved: (value) {
          phoneEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.phone,
            color: Colors.green,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                  .hasMatch(value!) &&
              value.isNotEmpty) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.mail,
            color: Colors.green,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email Address   (optional)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    Timestamp _toTimeStamp(DateTime? date) {
      return Timestamp.fromMillisecondsSinceEpoch(date!.millisecondsSinceEpoch);
    }

    //submit button
    final submitButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.green,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              FirebaseFirestore.instance.collection('Prospect').add({
                'name': nameEditingController.text,
                'phone': phoneEditingController.text,
                'email': emailEditingController.text,
                'channel': widget.channel,
                'salesStaff': user?.uid,
                'dateSubmitted': _toTimeStamp(DateTime.now()),
              });
              Fluttertoast.showToast(
                  msg: 'New prospect is successfully added',
                  gravity: ToastGravity.CENTER,
                  fontSize: 16);
              nameEditingController.clear();
              phoneEditingController.clear();
              emailEditingController.clear();
            }
          },
          child: const Text(
            "Submit",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      //bottomNavigationBar: CurvedNavBar(indexnum: 2),
      backgroundColor: Colors.white,
      drawer: NavigationDrawer(),
      appBar: PreferredSize(
        child: CustomAppBar(bartitle: 'Add Prospect'),
        preferredSize: Size.fromHeight(65),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  nameField,
                  SizedBox(height: 20),
                  phoneField,
                  SizedBox(height: 20),
                  emailField,
                  SizedBox(height: 20),
                  submitButton,
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
