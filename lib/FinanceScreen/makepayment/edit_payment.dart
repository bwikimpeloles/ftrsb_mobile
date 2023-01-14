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
  String? selectedValue = null;
  late CollectionReference _ref;
  DateTime? pickedDate;
  DateTime dateselect = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Pending"),value: "Pending"),
      DropdownMenuItem(child: Text("Approved"),value: "Approved"),
      DropdownMenuItem(child: Text("Rejected"),value: "Rejected"),
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
  }

  void initialize() async{
    DocumentSnapshot snapshot = (await _ref.doc(widget.paymentKey).get());
    Map payment = snapshot.data() as Map;
    selectedValue = payment['status'];
    dateselect = DateFormat('dd/MM/yyyy').parse(payment['effectivedate']);
    setState(() {});
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
    String status = selectedValue!;

    Map<String,String> payment = {
      'title':title,
      'accountholder':accountholder,
      'amount': amount,
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
                    decoration: InputDecoration(
                      label: Text('Account Holder (Recipient)'),
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
                    decoration: InputDecoration(
                      label: Text('Amount (RM)'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
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
                    decoration: InputDecoration(
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
                          initialDate: dateselect!,
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
                    decoration: InputDecoration(
                      label: Text('Purchase Order No.'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    enabled: false,
                    controller: _bankreferencenoController,
                    decoration: InputDecoration(
                      label: Text('Bank Reference No.'),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField(
                      hint: Text("Status"),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                      ),
                      validator: (value) => value == null ? "Select status" : null,
                      value: selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: dropdownItems),


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