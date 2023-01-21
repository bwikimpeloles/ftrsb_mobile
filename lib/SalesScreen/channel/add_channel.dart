import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/channel/list_channel.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';

class AddChannel extends StatefulWidget {
  const AddChannel({Key? key}) : super(key: key);

  @override
  State<AddChannel> createState() => _AddChannelState();
}

enum Type {
  B2C,
  B2B,
}

enum Verify {
  yes,
  no,
}


 Type? _type;
Verify? _verify;

class _AddChannelState extends State<AddChannel> {
  // form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final nameEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _type = null;
    _verify = null;

  }

  @override
  Widget build(BuildContext context) {
    //name field
    final nameField = TextFormField(
        autofocus: false,
        controller: nameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("*required");
          }
          return null;
        },
        onSaved: (value) {
          nameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Channel (e.g. Website, Shopee)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    ///radio button - Type
    final type = Column(
      children: <Widget>[
        RadioListTile<Type>(
          activeColor: Colors.green,
          title: const Text("B2C"),
          value: Type.B2C,
          groupValue: _type,
          onChanged: (Type? value) {
            setState(() {
              _type = Type.B2C;
            });
          },
        ),
         RadioListTile<Type>(
          activeColor: Colors.green,
          title: const Text("B2B"),
          value: Type.B2B,
          groupValue: _type,
          onChanged: (Type? value) {
            setState(() {
              _type = Type.B2B;
            });
          },
        ),
      ],
    );

    ///radio button - Type
    final verify = Column(
      children: <Widget>[
        RadioListTile<Verify>(
          activeColor: Colors.green,
          title: const Text("Yes"),
          value: Verify.yes,
          groupValue: _verify,
          onChanged: (Verify? value) {
            setState(() {
              _verify = Verify.yes;
            });
          },
        ),
         RadioListTile<Verify>(
          activeColor: Colors.green,
          title: const Text("No"),
          value: Verify.no,
          groupValue: _verify,
          onChanged: (Verify? value) {
            setState(() {
              _verify = Verify.no;
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
            if (_verify == null || _type == null){
              Fluttertoast.showToast(msg: 'Incomplete information');
            }

            else if (_formKey.currentState!.validate()) {
              FirebaseFirestore.instance.collection('Channel').doc(nameEditingController.text).set({
                'channel': nameEditingController.text,
                'needVerification': _verify.toString().substring(_verify.toString().indexOf('.')+1),
                'type': _type.toString().substring(_type.toString().indexOf('.')+1),
              });

              Fluttertoast.showToast(msg: 'New channel is successfully added', gravity: ToastGravity.CENTER, fontSize: 16);
              nameEditingController.clear();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ListChannel(),
              ));
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
        child: CustomAppBar(bartitle: 'Add New Channel'),
        preferredSize: Size.fromHeight(65),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  nameField,
                  SizedBox(height: 20),
                  Column(
                    children: [
                      SizedBox(height: 15),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: Text(
                          'Do the payments from this channel \nneed verification?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      verify,
                      SizedBox(height: 30),
                      SizedBox(
                        height: 30,
                        width: 300,
                        child: Text(
                          'Please specify channel type',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      type,
                    ],
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
    );
  }
}
