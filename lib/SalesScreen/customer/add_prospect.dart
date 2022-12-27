import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';

class ProspectDetailsForm extends StatefulWidget {
  const ProspectDetailsForm({Key? key}) : super(key: key);

  @override
  State<ProspectDetailsForm> createState() => _ProspectDetailsFormState();
}

enum DistrChannel {
  shopee,
  whatsapp,
  website,
  grabmart,
  tiktok,
  b2b_retail,
  b2b_hypermarket,
  other
}
 DistrChannel? _channel;
 User? user = FirebaseAuth.instance.currentUser;

class _ProspectDetailsFormState extends State<ProspectDetailsForm> {
  // form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final nameEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();
  final emailEditingController = TextEditingController();

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
          hintText: "Name",
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
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
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
          hintText: "Email Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    ///radio button
    //String? distrChannel;
    final channel = Column(
      children: <Widget>[
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("Shopee"),
          value: DistrChannel.shopee,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = DistrChannel.shopee;
            });
          },
        ),
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("WhatsApp"),
          value: DistrChannel.whatsapp,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = DistrChannel.whatsapp;
            });
          },
        ),
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("Website"),
          value: DistrChannel.website,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("GrabMart"),
          value: DistrChannel.grabmart,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("TikTok"),
          value: DistrChannel.tiktok,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("B2B Retail"),
          value: DistrChannel.b2b_retail,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("B2B Hypermarket"),
          value: DistrChannel.b2b_hypermarket,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
        
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("Other"),
          value: DistrChannel.other,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
      ],
    );

    //submit button
    final submitButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.green,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (_channel == null){
              Fluttertoast.showToast(msg: 'Choose a distribution channel!');
            }

            else if (_formKey.currentState!.validate()) {
              FirebaseFirestore.instance.collection('Prospect').add({
                'name': nameEditingController.text,
                'phone': phoneEditingController.text,
                'email': emailEditingController.text,
                'channel': _channel.toString().substring(_channel.toString().indexOf('.')+1),
                'salesStaff': user?.uid
              });

              Fluttertoast.showToast(msg: 'New prospect is successfully added');
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
      bottomNavigationBar: CurvedNavBar(indexnum: 2,),
      backgroundColor: Colors.white,
      drawer: NavigationDrawer(),
      appBar: PreferredSize(
        child: CustomAppBar(bartitle: 'Add Prospect'),
        preferredSize: Size.fromHeight(65),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    nameField,
                    SizedBox(height: 20),
                    phoneField,
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          SizedBox(
                            height: 20,
                            width: 300,
                            child: Text(
                              'Distribution Channel',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          channel,
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    submitButton,
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
