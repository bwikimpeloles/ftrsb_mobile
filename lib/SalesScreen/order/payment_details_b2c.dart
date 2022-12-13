import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/model/paymentB2C_model.dart';
import 'package:intl/intl.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({Key? key}) : super(key: key);

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

enum PaymentMethod { banktransfer, creditDebit, cash }

PaymentMethod? _paymentMethod;

class _PaymentDetailsState extends State<PaymentDetails> {
  late DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child('Customer');

  final _formKey = GlobalKey<FormState>();
  //text field controller
  final amountTextCtrl = TextEditingController();
  final banknameCtrl = TextEditingController();
  final dateInput = TextEditingController();

  late PaymentB2C paymentModel = PaymentB2C();

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
            dateInput.text =
                formattedDate; //set output date to TextField value.
          });
        } else {
          return null;
        }
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
                });
              },
            ),
          ],
        )
      ],
    );

    return Scaffold(
      bottomNavigationBar: CurvedNavBar(indexnum: 1,),
      backgroundColor: Colors.white,
      //drawer: NavigationDrawer(),
      appBar: PreferredSize(
          child: AppBar(
            //actions: [
            //  IconButton(
            //     onPressed: () {
            //       logout(context);
            //     },
            //     icon: Icon(Icons.logout_outlined, size: 25))
            //],
            //toolbarHeight: 70,
            //title: const Text("Welcome - Sales & Marketing"),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const CustomerDetailsForm(),
                    ))),
            title: Text('Payment Details'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 103, 206, 113),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(65)),
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
                  SizedBox(height: 20),
                  banknameField,
                  SizedBox(height: 20),
                  Container(
                    child: SizedBox(
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(30),
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

                                  setState(() {
                                    paymentModel.amount = amountTextCtrl.text;
                                    paymentModel.paymentMethod = _paymentMethod.toString();
                                    paymentModel.paymentDate = dateInput.text;
                                    paymentModel.bankName = banknameCtrl.text;
                                    
                                  });

                              /*
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const PaymentDetails(),
              ));
              */

                              /* Map<String?, String?> customer = {
                                'name': cust.name,
                                'phone': cust.phone,
                                'address': cust.address,
                                'email': cust.email,
                                'channel': cust.channel
                              };

                              dbRef.push().set(customer);*/
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
