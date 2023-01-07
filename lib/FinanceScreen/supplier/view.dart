import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'photo_page.dart';

import 'database.dart';

class View extends StatefulWidget {
  String supplierKey;
  View({Key? key, required this.detail, required this.db, required this.supplierKey}) : super(key: key);
  Map detail;
  Database db;
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  TextEditingController descController = new TextEditingController();
  TextEditingController datentimeController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.detail);
    descController.text = widget.detail['description'];
    datentimeController.text = widget.detail['datentime'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Description View"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                decoration: inputDecoration("Description"),
                controller: descController,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration("Date"),
                controller: datentimeController,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: BottomAppBar(
          child: TextButton(
              onPressed: () {
                widget.db.update(widget.detail['id'], descController.text,
                     datentimeController.text);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => PhotoPage(supplierKey: widget.supplierKey),
                ));
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.green),
              )),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          width: 2.0,
        ),
      ),
    );
  }
}