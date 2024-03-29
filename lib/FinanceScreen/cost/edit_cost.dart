import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCost extends StatefulWidget {
  String costKey;

  EditCost({required this.costKey});

  @override
  _EditCostState createState() => _EditCostState();
}

class _EditCostState extends State<EditCost> {
  late TextEditingController _nameController, _amountController, _supplierController, _referencenoController;
  late CollectionReference _ref;
  final _formKey = GlobalKey<FormState>();
  late String sentence;
  int year1=1;
  int month1=1;
  int day1=1;
  DateTime? dateselect = new DateTime.now();
  var selectedCategory;
  var selectedSupplier;
  String? selectedValue = null;
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Online Banking"),value: "Online Banking"),
      DropdownMenuItem(child: Text("Credit/Debit"),value: "Credit/Debit"),
      DropdownMenuItem(child: Text("Cash"),value: "Cash"),
    ];
    return menuItems;
  }


  // Future<DateTime> getDate() async {
  //   DocumentSnapshot snapshot = (await _ref.doc(widget.costKey).get());
  //   Map cost = snapshot.data() as Map;
  //   dateselect = (cost['date'] as Timestamp).toDate();
  //   return dateselect!;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _amountController = TextEditingController();
    _supplierController = TextEditingController();

    _referencenoController = TextEditingController();
    // getDate();
    _ref = FirebaseFirestore.instance.collection('Cost');
    getCostDetail();
    initialize();
    initialize2();
    setState(() {});
  }

  void initialize() async{
    var document = await FirebaseFirestore.instance.collection('Cost').doc(widget.costKey).get();
    // if the category inside the category collection exists
    CollectionReference checkexist = FirebaseFirestore.instance.collection('Category');
    QuerySnapshot _query = await checkexist
        .where('category', isEqualTo: document['category']).get();
    if (_query.docs.length > 0) {
      selectedCategory = document['category'];
    } else{
      selectedCategory = null;
    }

    // if the supplier inside the Suppliers collection exists
    CollectionReference checkexistsupplier = FirebaseFirestore.instance.collection('Suppliers');
    QuerySnapshot _query2 = await checkexistsupplier
        .where('companyname', isEqualTo: document['supplier']).get();
    if (_query2.docs.length > 0) {
      selectedSupplier = document['supplier'];
    } else{
      selectedSupplier = null;
    }

    dateselect = (document['date'] as Timestamp).toDate();

    setState(() {});
  }

  void initialize2() async{
    var document = await FirebaseFirestore.instance.collection('Cost').doc(widget.costKey).get();
    var myList = ["Online Banking", "Credit/Debit", "Cash"];

    if(myList.contains(document['paymenttype'].toString())){
      selectedValue= document['paymenttype'];
    } else{
      selectedValue= null;
    }

  }

  void saveCost() {
    String name = _nameController.text;
    String? category = selectedCategory;
    String amount = _amountController.text;
    String supplier = selectedSupplier?? '-';
    DateTime? date2 = dateselect;
    String referenceno = _referencenoController.text;
    String paymenttype = selectedValue?? '-';

    Map<String,Object?> cost2 = {
      'name':name,
      'category': category!,
      'amount':amount,
      'supplier': supplier,
      'date':date2,
      'referenceno': referenceno,
      'paymenttype': paymenttype,
    };

    if(double.tryParse(_amountController.text) != null){
      FirebaseFirestore.instance.collection('Cost').doc(widget.costKey).update(cost2).then((value) {
        Navigator.pop(context);
      } );
    } else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Enter valid amount!"),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Expenses'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                TextFormField(
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{3,}$');
                    if (value!.isEmpty) {
                      return ("This field cannot be empty!");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter valid input!");
                    }
                    return null;
                  },
                  controller: _nameController,
                  decoration: InputDecoration(
                    label: Text('Expenses Name'),
                    hintText: 'Enter Expenses Name',
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("Category").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const Text("Loading.....");
                      else {
                        List<DropdownMenuItem> categoryItems = [];
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          DocumentSnapshot snap = snapshot.data!.docs[i];
                          categoryItems.add(
                            DropdownMenuItem(
                              child: Text(
                                snap['category'],
                              ),
                              value: "${snap['category']}",
                            ),
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: DropdownButtonFormField<dynamic>(
                                validator: (value) => value == null ? "Select a category" : null,
                                items: categoryItems,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.all(15),
                                ),
                                onChanged: (categoryValue) {
                                  setState(() {
                                    selectedCategory = categoryValue;
                                  });
                                },
                                value: selectedCategory,
                                isExpanded: false,
                                hint: new Text(
                                  "Choose Category",
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    RegExp regex = RegExp(r'(\d+)');
                    if (value!.isEmpty) {
                      return ("This field cannot be empty!");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter valid amount!");
                    }
                    return null;
                  },
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
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("Suppliers").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const Text("Loading.....");
                      else {
                        List<DropdownMenuItem> supplierItems = [];
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          DocumentSnapshot snap = snapshot.data!.docs[i];
                          supplierItems.add(
                            DropdownMenuItem(
                              child: Text(
                                snap['companyname'],
                              ),
                              value: "${snap['companyname']}",
                            ),
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: DropdownButtonFormField<dynamic>(
                                items: supplierItems,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.all(15),
                                ),
                                onChanged: (supplierValue) {
                                  setState(() {
                                    selectedSupplier = supplierValue;
                                  });
                                },
                                value: selectedSupplier,
                                isExpanded: false,
                                hint: new Text(
                                  "Choose Supplier",
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                SizedBox(height: 15),
                DropdownButtonFormField(
                    hint: Text("Payment Type"),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    validator: (value) => value == null ? "Select payment type" : null,
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: dropdownItems),
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
                    Text('Date: ${dateselect!.year}-${dateselect!.month}-${dateselect!.day}'),
                    TextButton(onPressed: () async {
                      DateTime? newdate = await showDatePicker(context: context,
                          initialDate: dateselect!,
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
                    child: Text('Update Expenses',style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,

                    ),),
                    onPressed: (){
                    if(_formKey.currentState!.validate()){
                      saveCost();
                    }},

                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }


  getCostDetail() async {
    DocumentSnapshot snapshot = (await _ref.doc(widget.costKey).get());
    Map cost = snapshot.data() as Map;

    _nameController.text = cost['name'];

    selectedCategory = cost['category'];

    _amountController.text = cost['amount'];

    _supplierController.text = cost['supplier'];



    _referencenoController.text = cost['referenceno'];

  }
}