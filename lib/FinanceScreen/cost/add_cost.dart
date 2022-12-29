import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../model/cost_model.dart';
import '../cost.dart';

class AddCost extends StatefulWidget {
  @override
  _AddCostState createState() => _AddCostState();
}

class _AddCostState extends State<AddCost> {
  late TextEditingController _nameController, _categoryController, _amountController, _supplierController, _dateController, _referencenoController;
  DateTime dateselect = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final _dropdownFormKey = GlobalKey<FormState>();
  var uuid = Uuid();


  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Frozen Food"),value: "Frozen Food"),
      DropdownMenuItem(child: Text("Raw Material"),value: "Raw Material"),
      DropdownMenuItem(child: Text("Cookies"),value: "Cookies"),
      DropdownMenuItem(child: Text("Others"),value: "Others"),
    ];
    return menuItems;
  }
  String? selectedValue = null;


  late DatabaseReference _ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _categoryController = TextEditingController();
    _amountController = TextEditingController();
    _supplierController = TextEditingController();
    _dateController = TextEditingController();
    _referencenoController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child('Cost');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cost Details'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  label: Text('Cost Name'),
                  hintText: 'Enter Cost Name',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
              SizedBox(height: 15),
              Form(
                key: _dropdownFormKey,
                child: DropdownButtonFormField(
                    hint: Text("Choose an category"),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide( width: 2),//color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide( width: 2),//color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      //fillColor: Colors.blueAccent,
                    ),
                    validator: (value) => value == null ? "Select a category" : null,
                    //dropdownColor: Colors.blueAccent,
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: dropdownItems),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  label: Text('Amount (RM)'),
                  hintText: 'Enter Amount (RM)',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _supplierController,
                decoration: InputDecoration(
                  label: Text('Supplier'),
                  hintText: 'Enter Supplier',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),

              SizedBox(height: 15),
              TextFormField(
                controller: _referencenoController,
                decoration: InputDecoration(
                  label: Text('Reference No.'),
                  hintText: 'Enter Reference No.',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 15),
                  Text('Date: ${dateselect.year}-${dateselect.month}-${dateselect.day}'),
                  TextButton(onPressed: () async {
                    DateTime? newdate = await showDatePicker(context: context,
                        initialDate: dateselect,
                        firstDate: DateTime(1900), lastDate: DateTime(2200));

                    //if click cancel
                    if(newdate==null) {
                      return;
                    }

                    setState(() {
                      dateselect=newdate;
                    });
                  }, child: Row(
                    children: [
                      Text('Change Date'),
                      Icon(Icons.calendar_month),
                    ],
                  )),
                ],
              ),

              SizedBox(height: 25,),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextButton(style: TextButton.styleFrom(backgroundColor: Theme.of(context).accentColor,),
                  child: Text('Save',style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,

                  ),),
                  onPressed: (){
                    if (_dropdownFormKey.currentState!.validate()) {
                      //valid flow
                      saveCost();
                    }

                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
  void saveCost(){
    //var formatter = new DateFormat('yyyy-MM-dd');
    //String formattedDate = formatter.format(dateselect);
    String v1 = uuid.v1();

    String name = _nameController.text;
    String? category = selectedValue;
    String amount = _amountController.text;
    String supplier = _supplierController.text;
    String date = DateFormat('dd/MM/yyyy').format(dateselect).toString();  //formattedDate;
    String referenceno = _referencenoController.text;

    Map<String,String> cost = {
      'name':name,
      'category': category!,
      'amount':amount,
      'supplier': supplier,
      'date':date,
      'referenceno': referenceno,
    };

    if(double.tryParse(_amountController.text) != null){
      _ref.child(v1).set(cost).then((value) {
        Navigator.pop(context);
      });
      postDetailsToFirestore(v1);

    } else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Enter valid amount!!"),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

  }

  postDetailsToFirestore(String v1) async {
    // calling our firestore
    // calling our cost model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    //User? user = _auth.currentUser;

    CostModel costModel = CostModel();

    // writing all the values

    //costModel.name = nameEditingController.text;
    costModel.name = _nameController.text;
    costModel.category = selectedValue;
    costModel.amount = _amountController.text;
    costModel.supplier = _supplierController.text;
    costModel.date = dateselect; //formattedDate;
    costModel.referenceno = _referencenoController.text;



    await firebaseFirestore
        .collection("Cost")
        .doc(v1)
        .set(costModel.toMap());


  }
}