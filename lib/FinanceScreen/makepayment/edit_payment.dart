import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'view_payment.dart';

class EditPayment extends StatefulWidget {
  String paymentKey;

  EditPayment({required this.paymentKey});

  @override
  _EditPaymentState createState() => _EditPaymentState();
}

class _EditPaymentState extends State<EditPayment> {
  late TextEditingController _titleController, _accountholderController, _amountController, _effectivedateController, _ponumberController, _bankreferencenoController, _statusController;
  final _formKey = GlobalKey<FormState>();

  late CollectionReference _ref;
  DateTime? pickedDate;
  DateTime dateselect = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  var selectedCategory;
  String? selectedValue2 = null;
  String? selectedValue3 = null;
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Pending"),value: "Pending"),

    ];
    return menuItems;
  }
  List<DropdownMenuItem<String>> get dropdownItems2{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Online Banking"),value: "Online Banking"),
      DropdownMenuItem(child: Text("Credit/Debit"),value: "Credit/Debit"),
    ];
    return menuItems;
  }
  List<DropdownMenuItem<String>> get dropdownItems3{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Affin Bank"),value: "Affin Bank"),
      DropdownMenuItem(child: Text("Agrobank"),value: "Agrobank"),
      DropdownMenuItem(child: Text("Alliance Bank"),value: "Alliance Bank"),
      DropdownMenuItem(child: Text("Ambank"),value: "Ambank"),
      DropdownMenuItem(child: Text("Bank Islam"),value: "Bank Islam"),
      DropdownMenuItem(child: Text("Bank Muamalat"),value: "Bank Muamalat"),
      DropdownMenuItem(child: Text("Bank Rakyat"),value: "Bank Rakyat"),
      DropdownMenuItem(child: Text("BSN"),value: "BSN"),
      DropdownMenuItem(child: Text("CIMB"),value: "CIMB"),
      DropdownMenuItem(child: Text("Hong Leong"),value: "Hong Leong"),
      DropdownMenuItem(child: Text("HSBC"),value: "HSBC"),
      DropdownMenuItem(child: Text("Kuwait Finance House"),value: "Kuwait Finance House"),
      DropdownMenuItem(child: Text("Maybank2u"),value: "Maybank2u"),
      DropdownMenuItem(child: Text("OCBC"),value: "OCBC"),
      DropdownMenuItem(child: Text("Public Bank"),value: "Public Bank"),
      DropdownMenuItem(child: Text("RHB"),value: "RHB"),
      DropdownMenuItem(child: Text("Standard Chartered Bank"),value: "Standard Chartered Bank"),
      DropdownMenuItem(child: Text("UOB"),value: "UOB"),
    ];
    return menuItems;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _accountholderController = TextEditingController();
    _amountController = TextEditingController();
    _effectivedateController = TextEditingController();
    _ponumberController = TextEditingController();
    _bankreferencenoController = TextEditingController();
    _statusController = TextEditingController();
    _ref = FirebaseFirestore.instance.collection('MakePayments');
    getPaymentDetail();
    initialize();
    initialize2();
  }

  void initialize() async{
    DocumentSnapshot snapshot = (await _ref.doc(widget.paymentKey).get());
    Map payment = snapshot.data() as Map;
    dateselect = DateFormat('dd/MM/yyyy').parse(payment['effectivedate']);

    CollectionReference checkexist = FirebaseFirestore.instance.collection('Category');
    QuerySnapshot _query = await checkexist
        .where('category', isEqualTo: payment['category']).get();
    if (_query.docs.length > 0) {
      selectedCategory = payment['category'];
    } else{
      selectedCategory = null;
    }
    setState(() {});
  }

  void initialize2() async{
    var document = await FirebaseFirestore.instance.collection('MakePayments').doc(widget.paymentKey).get();
    var myList = ["Online Banking", "Credit/Debit", "Cash"];
    if(myList.contains(document['paymenttype'].toString())){
      selectedValue2= document['paymenttype'];
    } else{
      selectedValue2= null;
    }

    var myList2 = ['Affin Bank',
      'Agrobank',
      'Alliance Bank',
      'Ambank',
      'Bank Islam',
      'Bank Muamalat',
      'Bank Rakyat',
      'BSN',
      'CIMB',
      'Hong Leong',
      'HSBC',
      'Kuwait Finance House',
      'Maybank2u',
      'OCBC',
      'Public Bank',
      'RHB',
      'Standard Chartered Bank',
      'UOB',];
    if(myList2.contains(document['bankname'].toString())){
      selectedValue3= document['bankname'];
    } else{
      selectedValue3= null;
    }

  }

  getPaymentDetail() async {
    DocumentSnapshot snapshot = (await _ref.doc(widget.paymentKey).get());

    Map payment = snapshot.data() as Map;

    _titleController.text = payment['title'];

    _accountholderController.text = payment['accountholder'];

    _amountController.text = payment['amount'];

    _effectivedateController.text = payment['effectivedate'];

    _ponumberController.text = payment['ponumber'];

    _bankreferencenoController.text = payment['bankreferenceno'];

    _statusController.text = payment['status'];

  }

  void savePayment() {
    String title = _titleController.text;
    String accountholder = _accountholderController.text;
    String amount = _amountController.text;
    String effectivedate = _effectivedateController.text;
    String ponumber = _ponumberController.text;
    String bankreferenceno = _bankreferencenoController.text;
    String status = _statusController.text;
    String paymenttype = selectedValue2!;
    String bankname = selectedValue3!;
    String category = selectedCategory;

    Map<String,String> payment = {
      'title':title,
      'accountholder':accountholder,
      'amount': amount,
      'category': category,
      'paymenttype': paymenttype,
      'bankname': bankname,
      'effectivedate': effectivedate,
      'ponumber':ponumber,
      'bankreferenceno': bankreferenceno,
      'status':status,
    };

    _ref.doc(widget.paymentKey).update(payment).then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ViewPayment(
                paymentKey: widget.paymentKey,
              )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (_) => ViewPayment(
              paymentKey: widget.paymentKey,
            )), (route) => false);

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Update Payment'),
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
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
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Title'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                  SizedBox(height: 15),
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
                    controller: _accountholderController,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                      label: Text('Account Holder/Recipient/Supplier'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
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
                    decoration: InputDecoration(border: OutlineInputBorder(),
                      label: Text('Amount (RM)'),
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
                                  decoration: InputDecoration(border: OutlineInputBorder(),
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
                    controller: _effectivedateController,
                    autofocus: false,
                    readOnly: true,
                    validator: (value) {
                      RegExp regex = RegExp(r'(\d+)');
                      if (value!.isEmpty) {
                        return ("This field cannot be empty!");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter valid date!");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _effectivedateController.text = value!;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.green,
                      ),
                      label: Text('Effective Date'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    onTap: () async {
                      pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        String? formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate!);
                        setState(() {
                          _effectivedateController.text =
                              formattedDate;
                        });
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
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
                    controller: _ponumberController,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                      label: Text('Purchase Order No.'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField(
                      hint: Text("Payment Type"),
                      decoration: InputDecoration(border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                      ),
                      validator: (value) => value == null ? "Select payment type" : null,
                      value: selectedValue2,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue2 = newValue!;
                        });
                      },
                      items: dropdownItems2),
                  SizedBox(height: 15),
                  DropdownButtonFormField(
                      hint: Text("Bank Name"),
                      decoration: InputDecoration(border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                      ),
                      validator: (value) => value == null ? "Select Bank Name" : null,
                      value: selectedValue3,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue3 = newValue!;
                        });
                      },
                      items: dropdownItems3),
                  SizedBox(height: 15),
                  TextFormField(
                    //enabled: false,
                    controller: _bankreferencenoController,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                      label: Text('Bank Reference No.'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    enabled: false,
                    controller: _statusController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Status'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),

                  SizedBox(height: 25,),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(style: TextButton.styleFrom(backgroundColor: Theme.of(context).accentColor,),child: Text('Save',style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,


                    ),),
                      onPressed: ()async {
                        if(_formKey.currentState!.validate()){
                          savePayment();
                        }


                      },

                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}