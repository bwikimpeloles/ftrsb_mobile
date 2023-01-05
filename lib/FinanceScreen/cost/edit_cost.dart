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
  late TextEditingController _nameController, _categoryController, _amountController, _supplierController, _dateController, _referencenoController;
  late CollectionReference _ref;
  final _formKey = GlobalKey<FormState>();
  late String sentence;
  int year1=1;
  int month1=1;
  int day1=1;
  DateTime? dateselect = new DateTime.now();
  String? selectedValue;

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Frozen Food"),value: "Frozen Food"),
      DropdownMenuItem(child: Text("Raw Material"),value: "Raw Material"),
      DropdownMenuItem(child: Text("Cookies"),value: "Cookies"),
      DropdownMenuItem(child: Text("Others"),value: "Others"),
    ];
    return menuItems;
  }

  Future<DateTime> getDate() async {
    DocumentSnapshot snapshot = (await _ref.doc(widget.costKey).get());
    Map cost = snapshot.data() as Map;
    dateselect=DateTime.parse(cost['date'].toString());
    return dateselect!;

  }

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
    getDate();
    _ref = FirebaseFirestore.instance.collection('Cost');
    getCostDetail();
    initialize();
    setState(() {});
  }

  void initialize() async{
    var document = await FirebaseFirestore.instance.collection('Cost').doc(widget.costKey).get();
    selectedValue = document['category'];
    dateselect = (document['date'] as Timestamp).toDate();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Cost'),
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
                    label: Text('Cost Name'),
                    hintText: 'Enter Cost Name',
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                DropdownButtonFormField(
                    hint: Text("Choose an category"),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
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
                    child: Text('Update Cost',style: TextStyle(
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

    _categoryController.text = cost['category'];

    _amountController.text = cost['amount'];

    _supplierController.text = cost['supplier'];

    _dateController.text = cost['date'];

    _referencenoController.text = cost['referenceno'];

  }

  void saveCost() {
    //var formatter = new DateFormat('yyyy-MM-dd');
    //String formattedDate = formatter.format(dateselect);

    String name = _nameController.text;
    String? category = selectedValue;
    String amount = _amountController.text;
    String supplier = _supplierController.text;
    String date = DateFormat('dd/MM/yyyy').format(dateselect!).toString();//formattedDate;
    DateTime? date2 = dateselect;//formattedDate;
    String referenceno = _referencenoController.text;

    Map<String,String> cost = {
      'name':name,
      'category': category!,
      'amount':amount,
      'supplier': supplier,
      'date':date,
      'referenceno': referenceno,
    };
    Map<String,Object?> cost2 = {
      'name':name,
      'category': category!,
      'amount':amount,
      'supplier': supplier,
      'date':date2,
      'referenceno': referenceno,
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
}