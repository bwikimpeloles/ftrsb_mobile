import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/SalesScreen/order/product_details.dart';
import 'package:ftrsb_mobile/model/customer_model.dart';
import 'package:ftrsb_mobile/model/paymentB2C_model.dart';
import 'package:intl/intl.dart';

class PaymentDetails extends StatefulWidget {
  String? verify;
  String? channeltype;
  PaymentDetails({Key? key, required this.verify, required this.channeltype}) : super(key: key);

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

enum PaymentMethod { banktransfer, creditDebit, cash }

PaymentMethod? _paymentMethod;
late PaymentB2C payc = PaymentB2C();

class _PaymentDetailsState extends State<PaymentDetails> {
  //late DatabaseReference dbRef =
  //    FirebaseDatabase.instance.ref().child('PaymentB2C');

  final _formKey = GlobalKey<FormState>();
  //text field controller
  final amountTextCtrl = TextEditingController();
  final banknameCtrl = TextEditingController();
  final dateInput = TextEditingController();

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

  late DateTime? pdate;
  String? selectedbankname = null;

  @override
  initState() {
    super.initState();
    _paymentMethod = null;
  }

  @override
  Widget build(BuildContext context) {
    ///amount field
    final amountField = TextFormField(
        autofocus: false,
        controller: amountTextCtrl,
        keyboardType: TextInputType.phone,
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
        onSaved: (value) {
          amountTextCtrl.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.attach_money,
            color: Colors.green,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Amount (RM)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    ///date field
    DateTime? pickedDate;
    final date = TextFormField(
      controller: dateInput,
      autofocus: false,
      readOnly: true,
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
      onSaved: (value) {
        dateInput.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.calendar_today,
          color: Colors.green,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Payment Date",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
            dateInput.text = formattedDate;
            pdate = pickedDate; //set output date to TextField value.
          });
        }
        print(pickedDate);
      },
    );
    
    ///bank name field
    final banknameField = TextFormField(
        autofocus: false,
        controller: banknameCtrl,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("This field cannot be empty!");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter valid name!");
          }
          return null;
        },
        onSaved: (value) {
          banknameCtrl.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.account_balance,
            color: Colors.green,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Bank Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //radio button
    final paymethod = Column(
      children: [
        SizedBox(height: 15),
        const SizedBox(
          height: 20,
          width: 300,
          child: Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Column(
          children: [
            RadioListTile<PaymentMethod>(
              activeColor: Colors.green,
              title: const Text("Bank Transfer"),
              value: PaymentMethod.banktransfer,
              groupValue: _paymentMethod,
              onChanged: (PaymentMethod? value) {
                setState(() {
                  _paymentMethod = PaymentMethod.banktransfer;
                });
              },
            ),
            RadioListTile<PaymentMethod>(
              activeColor: Colors.green,
              title: const Text("Credit/Debit"),
              value: PaymentMethod.creditDebit,
              groupValue: _paymentMethod,
              onChanged: (PaymentMethod? value) {
                setState(() {
                  _paymentMethod = PaymentMethod.creditDebit;
                });
              },
            ),
            RadioListTile<PaymentMethod>(
              activeColor: Colors.green,
              title: const Text("Cash"),
              value: PaymentMethod.cash,
              groupValue: _paymentMethod,
              onChanged: (PaymentMethod? value) {
                setState(() {
                  _paymentMethod = PaymentMethod.cash;
                  banknameCtrl.text = 'N/A';
                });
              },
            ),
          ],
        )
      ],
    );

    Timestamp _toTimeStamp(DateTime? date) {
      return Timestamp.fromMillisecondsSinceEpoch(date!.millisecondsSinceEpoch);
    }

    return Scaffold(
      //bottomNavigationBar: CurvedNavBar(indexnum: 1,),
      backgroundColor: Colors.white,
      //drawer: NavigationDrawer(),
      appBar: PreferredSize(
        child: CustomAppBar(bartitle: 'Add Payment Information'),
        preferredSize: Size.fromHeight(65),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: paymethod),
                  SizedBox(height: 20),
                  amountField,
                  SizedBox(height: 20),
                  date,
                  //SizedBox(height: 20),
                  //banknameField,
                  SizedBox(height: 20),
                  DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                        hint: Text("Bank Name"),
                    icon: Icon(Icons.arrow_drop_down_circle_rounded,
                    color: Colors.green),
                        dropdownColor: Colors.green.shade50,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(15),
                          prefixIcon: const Icon(
                            Icons.account_balance,
                            color: Colors.green,
                          ),
                        ),
                        validator: (value) => value == null ? "Select Bank Name" : null,
                        value: selectedbankname,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedbankname = newValue!;
                          });
                        },
                        items: dropdownItems3),
                  ),
                      SizedBox(height: 20),
                  Container(
                    child: SizedBox(
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green,
                        child: MaterialButton(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            if (_paymentMethod == null) {
                              Fluttertoast.showToast(
                                  msg: "Please select a payment method");
                            } else if (_formKey.currentState!.validate() &&
                                _paymentMethod != null) {
                              //print(pdate);

                              _toTimeStamp(pdate);

                              print(_toTimeStamp(pdate));

                              setState(() {
                                payc.amount = amountTextCtrl.text;
                                payc.paymentMethod = _paymentMethod
                                    .toString()
                                    .substring(payc.paymentMethod
                                            .toString()
                                            .indexOf('.') +
                                        1);
                                payc.paymentDate = _toTimeStamp(pdate);
                                payc.bankName = selectedbankname;

                                if (widget.verify == 'yes') {
                                  payc.paymentVerify = '-';
                                  payc.action = 'Processing';
                                } else {
                                  payc.paymentVerify = 'Auto-verified';
                                  payc.action = 'Approved';
                                }
                              });

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDetails(channeltype: widget.channeltype,),
                              ));
                            }
                          },
                          child: const Text(
                            'Next',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
